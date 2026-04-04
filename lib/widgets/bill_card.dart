import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rent_bill_maker/bloc/bill/bill_bloc.dart';
import 'package:rent_bill_maker/bloc/settings/settings_cubit.dart';
import 'package:rent_bill_maker/bloc/tenant/tenant_bloc.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/models/tenant/tenant_model.dart';
import 'package:rent_bill_maker/screens/create_bill_screen.dart';
import 'package:rent_bill_maker/utils/constants.dart';
import 'package:rent_bill_maker/utils/l10n.dart';
import 'package:rent_bill_maker/widgets/bill_preview_overlay.dart';
import 'package:share_plus/share_plus.dart';

class BillCard extends StatelessWidget {
  const BillCard({required this.bill, super.key});
  final BillModel bill;

  @override
  Widget build(BuildContext context) {
    final TenantState tenantState = context.watch<TenantBloc>().state;
    final L10n l10n = L10n.of(context);
    String tenantName = '';
    if (tenantState is TenantLoaded) {
      final Iterable<TenantModel> tenant = tenantState.tenants.where(
        (TenantModel t) => t.id == bill.tenantId,
      );
      if (tenant.isNotEmpty) tenantName = tenant.first.name;
    }

    final DateSystem dateSystem = context.watch<SettingsCubit>().state;
    final bool isBS = dateSystem == DateSystem.bs;

    return Card(
      child: InkWell(
        onTap: () => _showBillDetails(context, tenantName),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: _statusColor(bill.status).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.receipt_long_outlined,
                      color: _statusColor(bill.status),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (tenantName.isNotEmpty)
                          Text(
                            tenantName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        Text(
                          isBS
                              ? NepaliDateFormat('MMMM yyyy').format(
                                  DateTime(
                                    bill.year,
                                    bill.month,
                                    15,
                                  ).toNepaliDateTime(),
                                )
                              : DateFormat(
                                  'MMMM yyyy',
                                ).format(DateTime(bill.year, bill.month, 15)),
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _statusBadge(bill.status, l10n),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${l10n.get('currency')}${bill.totalAmount.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        if (bill.outstandingAmount > 0 &&
                            bill.status != PaymentStatus.paid)
                          Text(
                            '${l10n.get('outstanding')}: ${l10n.get('currency')}${bill.outstandingAmount.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _iconBtn(
                        context,
                        Icons.share_outlined,
                        () => _shareBill(context),
                      ),
                      if (bill.status != PaymentStatus.paid) ...<Widget>[
                        const SizedBox(width: 4),
                        _iconBtn(
                          context,
                          Icons.check_circle_outline,
                          () => _markAsPaid(context),
                          color: const Color(0xFF16A34A),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconBtn(
    BuildContext context,
    IconData icon,
    VoidCallback onTap, {
    Color? color,
  }) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          size: 20,
          color: color ?? Theme.of(context).textTheme.bodySmall?.color,
        ),
      ),
    ),
  );

  Widget _statusBadge(PaymentStatus status, L10n l10n) {
    final Color color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Text(
        _statusText(status, l10n),
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Future<void> _markAsPaid(BuildContext context, [L10n? l10n]) async {
    l10n ??= L10n.of(context);
    final BillBloc billBloc = context.read<BillBloc>();
    await showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n!.get('mark_paid_confirm')),
        content: Text(
          '${l10n.get('currency')}${bill.totalAmount.toStringAsFixed(0)} ${l10n.get('is_paid_question')}',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.get('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              billBloc.add(
                MarkBillAsPaid(billId: bill.id, paymentMode: 'Cash'),
              );
            },
            child: Text(l10n.get('yes_paid')),
          ),
        ],
      ),
    );
  }

  Future<void> _markAsUnpaid(BuildContext context, [L10n? l10n]) async {
    l10n ??= L10n.of(context);
    final BillBloc billBloc = context.read<BillBloc>();
    await showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n!.get('mark_unpaid_confirm')),
        content: Text(
          '${l10n.get('currency')}${bill.totalAmount.toStringAsFixed(0)} ${l10n.get('is_unpaid_question')}',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.get('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              billBloc.add(MarkBillAsUnpaid(bill.id));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
            ),
            child: Text(l10n.get('yes_unpaid')),
          ),
        ],
      ),
    );
  }

  void _showBillDetails(BuildContext context, String tenantName) {
    final L10n l10n = L10n.of(context);
    final NavigatorState navigator = Navigator.of(context);
    final bool isBS = context.read<SettingsCubit>().state == DateSystem.bs;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      l10n.get('bill_details'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    _statusBadge(bill.status, l10n),
                  ],
                ),
                const SizedBox(height: 14),
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    if (tenantName.isNotEmpty)
                      _detailRow(ctx, l10n.get('tenants'), tenantName),
                    _detailRow(ctx, l10n.get('bill_number'), bill.billNumber),
                    _detailRow(
                      ctx,
                      l10n.get('billing_period'),
                      isBS
                          ? NepaliDateFormat('MMMM yyyy').format(
                              DateTime(
                                bill.year,
                                bill.month,
                                15,
                              ).toNepaliDateTime(),
                            )
                          : DateFormat(
                              'MMMM yyyy',
                            ).format(DateTime(bill.year, bill.month)),
                    ),
                    _detailRow(
                      ctx,
                      l10n.get('due_date_label'),
                      isBS
                          ? NepaliDateFormat(
                              'dd MMM yyyy',
                            ).format(bill.dueDate.toNepaliDateTime())
                          : DateFormat('dd MMM yyyy').format(bill.dueDate),
                    ),
                    const Divider(height: 20),
                    _detailRow(
                      ctx,
                      l10n.get('monthly_rent'),
                      '${l10n.get('currency')}${bill.rentAmount.toStringAsFixed(0)}',
                    ),
                    if (bill.electricityCharges > 0)
                      _detailRow(
                        ctx,
                        bill.electricityUnits != null
                            ? (bill.previousElectricityReading != null &&
                                      bill.currentElectricityReading != null)
                                  ? '${l10n.get('electricity')} (${bill.previousElectricityReading!.toStringAsFixed(0)}-${bill.currentElectricityReading!.toStringAsFixed(0)}: ${bill.electricityUnits!.toStringAsFixed(1)}${l10n.get('units_label')})'
                                  : '${l10n.get('electricity')} (${bill.electricityUnits!.toStringAsFixed(1)} ${l10n.get('units_label')})'
                            : l10n.get('electricity'),
                        '${l10n.get('currency')}${bill.electricityCharges.toStringAsFixed(0)}',
                      ),
                    if (bill.waterCharges > 0)
                      _detailRow(
                        ctx,
                        bill.waterUnits != null
                            ? (bill.previousWaterReading != null &&
                                      bill.currentWaterReading != null)
                                  ? '${l10n.get('water')} (${bill.previousWaterReading!.toStringAsFixed(0)}-${bill.currentWaterReading!.toStringAsFixed(0)}: ${bill.waterUnits!.toStringAsFixed(1)}${l10n.get('units_label')})'
                                  : '${l10n.get('water')} (${bill.waterUnits!.toStringAsFixed(1)} ${l10n.get('units_label')})'
                            : l10n.get('water'),
                        '${l10n.get('currency')}${bill.waterCharges.toStringAsFixed(0)}',
                      ),
                    if (bill.internetCharges > 0)
                      _detailRow(
                        ctx,
                        l10n.get('internet'),
                        '${Constants.currency}${bill.internetCharges.toStringAsFixed(0)}',
                      ),
                    if (bill.otherCharges > 0)
                      _detailRow(
                        ctx,
                        bill.otherChargesDescription.isNotEmpty
                            ? bill.otherChargesDescription
                            : l10n.get('other'),
                        '${Constants.currency}${bill.otherCharges.toStringAsFixed(0)}',
                      ),
                    ...bill.dynamicCharges.entries.map(
                      (MapEntry<String, double> e) => _detailRow(
                        ctx,
                        e.key,
                        '${Constants.currency}${e.value.toStringAsFixed(0)}',
                      ),
                    ),
                    ...bill.dynamicDeductions.entries.map(
                      (MapEntry<String, double> e) => _detailRow(
                        ctx,
                        e.key,
                        '-${Constants.currency}${e.value.toStringAsFixed(0)}',
                      ),
                    ),
                    if (bill.discount > 0)
                      _detailRow(
                        ctx,
                        l10n.get('discount_label'),
                        '-${Constants.currency}${bill.discount.toStringAsFixed(0)}',
                      ),
                    const Divider(height: 20),
                    _detailRow(
                      ctx,
                      l10n.get('total_amount_label'),
                      '${Constants.currency}${bill.totalAmount.toStringAsFixed(0)}',
                      isBold: true,
                    ),
                    if (bill.paidAmount > 0) ...<Widget>[
                      _detailRow(
                        ctx,
                        l10n.get('paid_amt'),
                        '${Constants.currency}${bill.paidAmount.toStringAsFixed(0)}',
                      ),
                      _detailRow(
                        ctx,
                        l10n.get('remaining'),
                        '${Constants.currency}${bill.outstandingAmount.toStringAsFixed(0)}',
                        isBold: true,
                      ),
                    ],
                    if (bill.notes != null && bill.notes!.isNotEmpty)
                      _detailRow(ctx, l10n.get('notes'), bill.notes!),
                    const SizedBox(height: 24),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              navigator.pop();
                              navigator.push<bool>(
                                MaterialPageRoute<bool>(
                                  builder: (BuildContext ctx) =>
                                      CreateBillScreen(bill: bill),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit_outlined, size: 20),
                            label: Text(l10n.get('edit_bill')),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF2563EB),
                              side: const BorderSide(color: Color(0xFF2563EB)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              navigator.pop();
                              _confirmDelete(context, l10n);
                            },
                            icon: const Icon(Icons.delete_outline, size: 20),
                            label: Text(l10n.get('delete')),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFDC2626),
                              side: const BorderSide(color: Color(0xFFDC2626)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        navigator.pop();
                        _shareBill(context);
                      },
                      icon: const Icon(Icons.share, size: 20),
                      label: Text(l10n.get('share_bill')),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (bill.status != PaymentStatus.paid)
                      ElevatedButton.icon(
                        onPressed: () {
                          navigator.pop();
                          _markAsPaid(context, l10n);
                        },
                        icon: const Icon(Icons.check_circle_outline, size: 20),
                        label: Text(l10n.get('mark_paid')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF16A34A),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    if (bill.status == PaymentStatus.paid)
                      ElevatedButton.icon(
                        onPressed: () {
                          navigator.pop();
                          _markAsUnpaid(context, l10n);
                        },
                        icon: const Icon(Icons.history, size: 20),
                        label: Text(l10n.get('mark_unpaid')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDC2626),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRow(
    BuildContext context,
    String label,
    String value, {
    bool isBold = false,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    ),
  );

  void _confirmDelete(BuildContext context, L10n l10n) {
    final BillBloc billBloc = context.read<BillBloc>();
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text(l10n.get('delete_bill')),
        content: Text(l10n.get('delete_bill_msg')),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.get('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              billBloc.add(DeleteBill(bill.id));
              messenger.showSnackBar(
                SnackBar(content: Text(l10n.get('delete_bill'))),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
            ),
            child: Text(l10n.get('delete')),
          ),
        ],
      ),
    );
  }

  Future<void> _shareBill(BuildContext context) async {
    final L10n l10n = L10n.of(context);
    try {
      // Navigate to a full-screen overlay where the bill can be captured
      final dynamic result = await Navigator.of(context).push<Uint8List?>(
        MaterialPageRoute<Uint8List?>(
          builder: (_) => BillPreviewOverlay(bill: bill),
          fullscreenDialog: true,
        ),
      );
      if (result != null && result is Uint8List) {
        final Directory dir = await getApplicationDocumentsDirectory();
        final String fileName =
            'rent_bill_${bill.billNumber.replaceAll('/', '_')}.png';
        final File file = File('${dir.path}/$fileName');
        await file.writeAsBytes(result);

        // Update bill with image path
        final BillModel updatedBill = bill.copyWith(pdfPath: file.path);
        if (context.mounted) {
          context.read<BillBloc>().add(UpdateBill(updatedBill));
        }

        await SharePlus.instance.share(
          ShareParams(
            files: <XFile>[XFile(file.path)],
            text: '${l10n.get('share_bill')} - ${bill.billNumber}',
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.get('share_failed')}: $e')),
        );
      }
    }
  }

  Color _statusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return const Color(0xFF16A34A);
      case PaymentStatus.pending:
        return const Color(0xFFF59E0B);
      case PaymentStatus.overdue:
        return const Color(0xFFDC2626);
      case PaymentStatus.partiallyPaid:
        return const Color(0xFF2563EB);
    }
  }

  String _statusText(PaymentStatus status, L10n l10n) {
    switch (status) {
      case PaymentStatus.paid:
        return l10n.get('status_paid');
      case PaymentStatus.pending:
        return l10n.get('status_pending');
      case PaymentStatus.overdue:
        return l10n.get('status_overdue');
      case PaymentStatus.partiallyPaid:
        return l10n.get('status_partial');
    }
  }
}
