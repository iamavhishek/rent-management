import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rent_bill_maker/bloc/bill/bill_bloc.dart';
import 'package:rent_bill_maker/bloc/tenant/tenant_bloc.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/services/pdf_generator.dart';
import 'package:rent_bill_maker/utils/constants.dart';
import 'package:rent_bill_maker/utils/l10n.dart';
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
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
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
                          DateFormat(
                            'MMMM yyyy',
                          ).format(DateTime(bill.year, bill.month)),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _statusBadge(bill.status, l10n),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${Constants.currency}${bill.totalAmount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (bill.outstandingAmount > 0 &&
                            bill.status != PaymentStatus.paid)
                          Text(
                            '${l10n.get('outstanding')}: ${Constants.currency}${bill.outstandingAmount.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.orange.shade700,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _iconBtn(
                        Icons.picture_as_pdf_outlined,
                        () => _viewPDF(context),
                      ),
                      const SizedBox(width: 4),
                      _iconBtn(Icons.share_outlined, () => _shareBill(context)),
                      if (bill.status != PaymentStatus.paid) ...[
                        const SizedBox(width: 4),
                        _iconBtn(
                          Icons.check_circle_outline,
                          () => _markAsPaid(context),
                          color: Colors.green,
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

  Widget _iconBtn(IconData icon, VoidCallback onTap, {Color? color}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 20, color: color ?? Colors.grey.shade600),
      ),
    );
  }

  Widget _statusBadge(PaymentStatus status, L10n l10n) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        _statusText(status, l10n),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  void _markAsPaid(BuildContext context) {
    final l10n = L10n.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.get('mark_paid_confirm')),
        content: Text(
          '${Constants.currency}${bill.totalAmount.toStringAsFixed(0)} ${l10n.get('is_paid_question')}',
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.85,
        expand: false,
        builder: (context, scrollController) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
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
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    _statusBadge(bill.status, l10n),
                  ],
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: [
                      if (tenantName.isNotEmpty)
                        _detailRow(l10n.get('tenants'), tenantName),
                      _detailRow(l10n.get('bill_number'), bill.billNumber),
                      _detailRow(
                        l10n.get('billing_period'),
                        DateFormat(
                          'MMMM yyyy',
                        ).format(DateTime(bill.year, bill.month)),
                      ),
                      _detailRow(
                        l10n.get('due_date_label'),
                        DateFormat('dd MMM yyyy').format(bill.dueDate),
                      ),
                      const Divider(height: 20),
                      _detailRow(
                        l10n.get('monthly_rent'),
                        '${Constants.currency}${bill.rentAmount.toStringAsFixed(0)}',
                      ),
                      if (bill.electricityCharges > 0)
                        _detailRow(
                          l10n.get('electricity'),
                          '${Constants.currency}${bill.electricityCharges.toStringAsFixed(0)}',
                        ),
                      if (bill.waterCharges > 0)
                        _detailRow(
                          l10n.get('water'),
                          '${Constants.currency}${bill.waterCharges.toStringAsFixed(0)}',
                        ),
                      if (bill.internetCharges > 0)
                        _detailRow(
                          l10n.get('internet'),
                          '${Constants.currency}${bill.internetCharges.toStringAsFixed(0)}',
                        ),
                      if (bill.otherCharges > 0)
                        _detailRow(
                          bill.otherChargesDescription.isNotEmpty
                              ? bill.otherChargesDescription
                              : l10n.get('other'),
                          '${Constants.currency}${bill.otherCharges.toStringAsFixed(0)}',
                        ),
                      ...bill.dynamicCharges.entries.map((e) => _detailRow(
                        e.key,
                        '${Constants.currency}${e.value.toStringAsFixed(0)}',
                      )),
                      ...bill.dynamicDeductions.entries.map((e) => _detailRow(
                        e.key,
                        '-${Constants.currency}${e.value.toStringAsFixed(0)}',
                      )),
                      if (bill.discount > 0)
                        _detailRow(
                          l10n.get('discount_label'),
                          '-${Constants.currency}${bill.discount.toStringAsFixed(0)}',
                        ),
                      const Divider(height: 20),
                      _detailRow(
                        l10n.get('total_amount_label'),
                        '${Constants.currency}${bill.totalAmount.toStringAsFixed(0)}',
                        isBold: true,
                      ),
                      if (bill.paidAmount > 0) ...[
                        _detailRow(
                          l10n.get('paid_amt'),
                          '${Constants.currency}${bill.paidAmount.toStringAsFixed(0)}',
                        ),
                        _detailRow(
                          l10n.get('remaining'),
                          '${Constants.currency}${bill.outstandingAmount.toStringAsFixed(0)}',
                          isBold: true,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _detailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _viewPDF(BuildContext context) async {
    final l10n = L10n.of(context);
    try {
      await PdfGenerator.generateBillPDF(bill);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.get('pdf_generated'))),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.get('error')}: $e')),
      );
    }
  }

  void _shareBill(BuildContext context) async {
    final l10n = L10n.of(context);
    try {
      String pdfPath;
      if (bill.pdfPath != null) {
        pdfPath = bill.pdfPath!;
      } else {
        pdfPath = await PdfGenerator.generateBillPDF(bill);
      }
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(pdfPath)],
          text: '${l10n.get('share_bill')} - ${bill.billNumber}',
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.get('share_failed')}: $e')),
      );
    }
  }

  Color _statusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return Colors.green;
      case PaymentStatus.pending:
        return Colors.orange;
      case PaymentStatus.overdue:
        return Colors.red;
      case PaymentStatus.partiallyPaid:
        return Colors.blue;
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
