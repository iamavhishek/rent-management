import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rent_bill_maker/bloc/bill/bill_bloc.dart';
import 'package:rent_bill_maker/bloc/tenant/tenant_bloc.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/utils/constants.dart';
import 'package:rent_bill_maker/utils/l10n.dart';
import 'package:rent_bill_maker/widgets/bill_preview_overlay.dart';
import 'package:rent_bill_maker/screens/create_bill_screen.dart';
import 'package:share_plus/share_plus.dart';

class BillCard extends StatelessWidget {
  final BillModel bill;

  const BillCard({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    final tenantState = context.watch<TenantBloc>().state;
    final l10n = L10n.of(context);
    String tenantName = '';
    if (tenantState is TenantLoaded) {
      final tenant = tenantState.tenants.where((t) => t.id == bill.tenantId);
      if (tenant.isNotEmpty) tenantName = tenant.first.name;
    }

    return Card(
      child: InkWell(
        onTap: () => _showBillDetails(context, tenantName),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
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
                      children: [
                        if (tenantName.isNotEmpty)
                          Text(
                            tenantName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        Text(
                          bill.dateSystem == DateSystem.bs
                              ? NepaliDateFormat(
                                  'MMMM yyyy',
                                ).format(
                                  DateTime(bill.year, bill.month, 15)
                                      .toNepaliDateTime(),
                                )
                              : DateFormat(
                                  'MMMM yyyy',
                                ).format(DateTime(bill.year, bill.month)),
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
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                    children: [
                      _iconBtn(
                        context,
                        Icons.share_outlined,
                        () => _shareBill(context),
                      ),
                      if (bill.status != PaymentStatus.paid) ...[
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
  }) {
    return Material(
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
  }

  Widget _statusBadge(PaymentStatus status, L10n l10n) {
    final color = _statusColor(status);
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

  void _markAsPaid(BuildContext context, [L10n? l10n]) {
    l10n ??= L10n.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n!.get('mark_paid_confirm')),
        content: Text(
          '${l10n.get('currency')}${bill.totalAmount.toStringAsFixed(0)} ${l10n.get('is_paid_question')}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.get('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<BillBloc>().add(
                MarkBillAsPaid(billId: bill.id, paymentMode: 'Cash'),
              );
            },
            child: Text(l10n.get('yes_paid')),
          ),
        ],
      ),
    );
  }

  void _showBillDetails(BuildContext context, String tenantName) {
    final l10n = L10n.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
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
              children: [
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
                  children: [
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
                  children: [
                    if (tenantName.isNotEmpty)
                      _detailRow(context, l10n.get('tenants'), tenantName),
                    _detailRow(
                      context,
                      l10n.get('bill_number'),
                      bill.billNumber,
                    ),
                    _detailRow(
                      context,
                      l10n.get('billing_period'),
                      bill.dateSystem == DateSystem.bs
                          ? NepaliDateFormat(
                              'MMMM yyyy',
                            ).format(
                              DateTime(bill.year, bill.month, 15)
                                  .toNepaliDateTime(),
                            )
                          : DateFormat(
                              'MMMM yyyy',
                            ).format(DateTime(bill.year, bill.month)),
                    ),
                    _detailRow(
                      context,
                      l10n.get('due_date_label'),
                      bill.dateSystem == DateSystem.bs
                          ? NepaliDateFormat(
                              'dd MMM yyyy',
                            ).format(bill.dueDate.toNepaliDateTime())
                          : DateFormat('dd MMM yyyy').format(bill.dueDate),
                    ),
                    const Divider(height: 20),
                    _detailRow(
                      context,
                      l10n.get('monthly_rent'),
                      '${l10n.get('currency')}${bill.rentAmount.toStringAsFixed(0)}',
                    ),
                    if (bill.electricityCharges > 0)
                      _detailRow(
                        context,
                        bill.electricityUnits != null
                            ? (bill.previousElectricityReading != null &&
                                    bill.currentElectricityReading != null)
                                ? 'Electricity (${bill.previousElectricityReading!.toStringAsFixed(0)}-${bill.currentElectricityReading!.toStringAsFixed(0)}: ${bill.electricityUnits!.toStringAsFixed(1)}u)'
                                : 'Electricity (${bill.electricityUnits!.toStringAsFixed(1)} units)'
                            : 'Electricity',
                        '${l10n.get('currency')}${bill.electricityCharges.toStringAsFixed(0)}',
                      ),
                    if (bill.waterCharges > 0)
                      _detailRow(
                        context,
                        bill.waterUnits != null
                            ? (bill.previousWaterReading != null &&
                                    bill.currentWaterReading != null)
                                ? 'Water (${bill.previousWaterReading!.toStringAsFixed(0)}-${bill.currentWaterReading!.toStringAsFixed(0)}: ${bill.waterUnits!.toStringAsFixed(1)}u)'
                                : 'Water (${bill.waterUnits!.toStringAsFixed(1)} units)'
                            : 'Water',
                        '${l10n.get('currency')}${bill.waterCharges.toStringAsFixed(0)}',
                      ),
                    if (bill.internetCharges > 0)
                      _detailRow(
                        context,
                        l10n.get('internet'),
                        '${Constants.currency}${bill.internetCharges.toStringAsFixed(0)}',
                      ),
                    if (bill.otherCharges > 0)
                      _detailRow(
                        context,
                        bill.otherChargesDescription.isNotEmpty
                            ? bill.otherChargesDescription
                            : l10n.get('other'),
                        '${Constants.currency}${bill.otherCharges.toStringAsFixed(0)}',
                      ),
                    ...bill.dynamicCharges.entries.map(
                      (e) => _detailRow(
                        context,
                        e.key,
                        '${Constants.currency}${e.value.toStringAsFixed(0)}',
                      ),
                    ),
                    ...bill.dynamicDeductions.entries.map(
                      (e) => _detailRow(
                        context,
                        e.key,
                        '-${Constants.currency}${e.value.toStringAsFixed(0)}',
                      ),
                    ),
                    if (bill.discount > 0)
                      _detailRow(
                        context,
                        l10n.get('discount_label'),
                        '-${Constants.currency}${bill.discount.toStringAsFixed(0)}',
                      ),
                    const Divider(height: 20),
                    _detailRow(
                      context,
                      l10n.get('total_amount_label'),
                      '${Constants.currency}${bill.totalAmount.toStringAsFixed(0)}',
                      isBold: true,
                    ),
                    if (bill.paidAmount > 0) ...[
                      _detailRow(
                        context,
                        l10n.get('paid_amt'),
                        '${Constants.currency}${bill.paidAmount.toStringAsFixed(0)}',
                      ),
                      _detailRow(
                        context,
                        l10n.get('remaining'),
                        '${Constants.currency}${bill.outstandingAmount.toStringAsFixed(0)}',
                        isBold: true,
                      ),
                    ],
                    if (bill.notes != null && bill.notes!.isNotEmpty)
                      _detailRow(context, l10n.get('notes'), bill.notes!),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateBillScreen(
                                    bill: bill,
                                  ),
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
                              Navigator.pop(context);
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
                        Navigator.pop(context);
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
                          Navigator.pop(context);
                          _markAsPaid(context, l10n);
                        },
                        icon: const Icon(Icons.check_circle_outline, size: 20),
                        label: Text(l10n.get('mark_paid')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF16A34A),
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
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
  }

  void _confirmDelete(BuildContext context, L10n l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.get('delete_bill')),
        content: Text(l10n.get('delete_bill_msg')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.get('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<BillBloc>().add(DeleteBill(bill.id));
              ScaffoldMessenger.of(context).showSnackBar(
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
    final l10n = L10n.of(context);
    try {
      // Navigate to a full-screen overlay where the bill can be captured
      final result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BillPreviewOverlay(bill: bill),
          fullscreenDialog: true,
        ),
      );
      if (result != null && result is Uint8List) {
        final dir = await getApplicationDocumentsDirectory();
        final fileName =
            'rent_bill_${bill.billNumber.replaceAll('/', '_')}.png';
        final file = File('${dir.path}/$fileName');
        await file.writeAsBytes(result);

        // Update bill with image path
        final updatedBill = bill.copyWith(pdfPath: file.path);
        Hive.box<BillModel>(Constants.billsBox).put(bill.id, updatedBill);

        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(file.path)],
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
