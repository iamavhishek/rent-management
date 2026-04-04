import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:rent_bill_maker/bloc/settings/settings_cubit.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/models/property/property_model.dart';
import 'package:rent_bill_maker/models/tenant/tenant_model.dart';
import 'package:rent_bill_maker/utils/l10n.dart';

class BillReceiptWidget extends StatelessWidget {

  const BillReceiptWidget({
    required this.bill,
    required this.property,
    required this.tenant,
    super.key,
    this.padding = const EdgeInsets.all(28),
  });
  final BillModel bill;
  final PropertyModel property;
  final TenantModel tenant;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final L10n l10n = L10n.of(context);

    String monthName;
    String dueDateStr;
    final bool isBS = context.watch<SettingsCubit>().state == DateSystem.bs;

    if (isBS) {
      monthName = NepaliDateFormat(
        'MMMM yyyy',
      ).format(DateTime(bill.year, bill.month, 15).toNepaliDateTime());
      dueDateStr = NepaliDateFormat(
        'dd MMM yyyy',
      ).format(bill.dueDate.toNepaliDateTime());
    } else {
      monthName = DateFormat(
        'MMMM yyyy',
      ).format(DateTime(bill.year, bill.month, 15));
      dueDateStr = DateFormat('dd MMM yyyy').format(bill.dueDate);
    }

    return Container(
      width: 380,
      color: Colors.white,
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Top accent bar
            Container(
              width: double.infinity,
              height: 4,
              decoration: const BoxDecoration(color: Color(0xFF2563EB)),
            ),
            const SizedBox(height: 20),

            // Thin divider
            const Divider(height: 1, thickness: 0.5, color: Color(0xFFE2E8F0)),
            const SizedBox(height: 14),

            // Bill title
            Text(
              l10n.get('share_bill').toUpperCase(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2563EB),
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${l10n.get('bill_number')}: ${bill.billNumber}',
              style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 14),

            // Thin divider
            const Divider(height: 1, thickness: 0.5, color: Color(0xFFE2E8F0)),
            const SizedBox(height: 14),

            // Tenant info only
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.get('tenants').toUpperCase(),
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF64748B),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tenant.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  tenant.phone,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
                if (tenant.citizenshipNumber.isNotEmpty)
                  Text(
                    '${l10n.get('citizenship')}: ${tenant.citizenshipNumber}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF64748B),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),

            // Thin divider
            const Divider(height: 1, thickness: 0.5, color: Color(0xFFE2E8F0)),
            const SizedBox(height: 10),

            // Billing period
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${l10n.get('billing_period')}: $monthName',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${l10n.get('due_date')}: $dueDateStr',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Thin divider
            const Divider(height: 1, thickness: 0.5, color: Color(0xFFE2E8F0)),
            const SizedBox(height: 8),

            // Charges table header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              color: const Color(0xFFF8F9FA),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      l10n.get('other_desc').toUpperCase(),
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF64748B),
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Text(
                    l10n.get('total_amount').toUpperCase(),
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF64748B),
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),

            // Charges list
            _chargeRow(
              l10n.get('monthly_rent'),
              '${l10n.get('currency')}${bill.rentAmount.toStringAsFixed(0)}',
            ),
            if (bill.electricityCharges > 0)
              _chargeRow(
                bill.electricityUnits != null
                    ? (bill.previousElectricityReading != null &&
                              bill.currentElectricityReading != null)
                          ? '${l10n.get('electricity')} (${bill.previousElectricityReading!.toStringAsFixed(0)}-${bill.currentElectricityReading!.toStringAsFixed(0)}: ${bill.electricityUnits!.toStringAsFixed(1)} ${l10n.get('units_label')})'
                          : '${l10n.get('electricity')} (${bill.electricityUnits!.toStringAsFixed(1)} ${l10n.get('units_label')})'
                    : l10n.get('electricity'),
                '${l10n.get('currency')}${bill.electricityCharges.toStringAsFixed(0)}',
              ),
            if (bill.waterCharges > 0)
              _chargeRow(
                bill.waterUnits != null
                    ? (bill.previousWaterReading != null &&
                              bill.currentWaterReading != null)
                          ? '${l10n.get('water')} (${bill.previousWaterReading!.toStringAsFixed(0)}-${bill.currentWaterReading!.toStringAsFixed(0)}: ${bill.waterUnits!.toStringAsFixed(1)} ${l10n.get('units_label')})'
                          : '${l10n.get('water')} (${bill.waterUnits!.toStringAsFixed(1)} ${l10n.get('units_label')})'
                    : l10n.get('water'),
                '${l10n.get('currency')}${bill.waterCharges.toStringAsFixed(0)}',
              ),
            if (bill.internetCharges > 0)
              _chargeRow(
                l10n.get('internet'),
                '${l10n.get('currency')}${bill.internetCharges.toStringAsFixed(0)}',
              ),
            if (bill.otherCharges > 0)
              _chargeRow(
                bill.otherChargesDescription.isNotEmpty
                    ? bill.otherChargesDescription
                    : l10n.get('other'),
                '${l10n.get('currency')}${bill.otherCharges.toStringAsFixed(0)}',
              ),
            for (final MapEntry<String, double> entry in bill.dynamicCharges.entries)
              _chargeRow(
                entry.key,
                '${l10n.get('currency')}${entry.value.toStringAsFixed(0)}',
              ),
            for (final MapEntry<String, double> entry in bill.dynamicDeductions.entries)
              _chargeRow(
                entry.key,
                '-${l10n.get('currency')}${entry.value.toStringAsFixed(0)}',
              ),
            if (bill.discount > 0)
              _chargeRow(
                l10n.get('discount'),
                '-${l10n.get('currency')}${bill.discount.toStringAsFixed(0)}',
              ),

            // Total section
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    TextSpan(
                      text: '${l10n.get('total_amount_label').toUpperCase()}  ',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    TextSpan(
                      text:
                          '${l10n.get('currency')}${bill.totalAmount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (bill.paidAmount > 0) ...<Widget>[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${l10n.get('paid_amt')}: ${l10n.get('currency')}${bill.paidAmount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF16A34A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${l10n.get('outstanding')}: ${l10n.get('currency')}${bill.outstandingAmount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: bill.outstandingAmount > 0
                          ? Colors.orange
                          : Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],

            // Status badge
            const SizedBox(height: 10),
            _statusBadge(bill.status, l10n),

            const SizedBox(height: 20),

            // Thin divider
            const Divider(height: 1, thickness: 0.5, color: Color(0xFFE2E8F0)),
            const SizedBox(height: 10),

            // Footer
            const SizedBox(height: 10),
            Center(
              child: Text(
                l10n.get('thank_you'),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
            const SizedBox(height: 4),

            // Bottom accent bar
            Container(
              width: double.infinity,
              height: 4,
              decoration: const BoxDecoration(color: Color(0xFF2563EB)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chargeRow(String label, String amount) => Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF0F0F0), width: 0.5),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12))),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );

  Widget _statusBadge(PaymentStatus status, L10n l10n) {
    Color color;
    String text;

    switch (status) {
      case PaymentStatus.paid:
        color = const Color(0xFF16A34A);
        text = l10n.get('status_paid');
      case PaymentStatus.pending:
        color = const Color(0xFFF59E0B);
        text = l10n.get('status_pending');
      case PaymentStatus.overdue:
        color = const Color(0xFFDC2626);
        text = l10n.get('status_overdue');
      case PaymentStatus.partiallyPaid:
        color = const Color(0xFF2563EB);
        text = l10n.get('status_partial');
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
