import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/models/property/property_model.dart';
import 'package:rent_bill_maker/models/tenant/tenant_model.dart';
import 'package:rent_bill_maker/utils/constants.dart';
import 'package:rent_bill_maker/utils/l10n.dart';

class BillReceiptWidget extends StatelessWidget {
  final BillModel bill;
  final EdgeInsets padding;

  const BillReceiptWidget({
    super.key,
    required this.bill,
    this.padding = const EdgeInsets.all(28),
  });

  @override
  Widget build(BuildContext context) {
    final propertyBox = Hive.box<PropertyModel>(Constants.propertiesBox);
    final tenantBox = Hive.box<TenantModel>(Constants.tenantsBox);
    final l10n = L10n.of(context);

    final property = propertyBox.get(bill.propertyId);
    final tenant = tenantBox.get(bill.tenantId);

    if (property == null || tenant == null) {
      return const Center(child: Text('Data not found'));
    }

    String monthName;
    String dueDateStr;

    if (bill.dateSystem == DateSystem.bs) {
      monthName = NepaliDateFormat(
        'MMMM yyyy',
      ).format(DateTime(bill.year, bill.month, 15).toNepaliDateTime());
      dueDateStr = NepaliDateFormat(
        'dd MMM yyyy',
      ).format(bill.dueDate.toNepaliDateTime());
    } else {
      monthName = DateFormat(
        'MMMM yyyy',
      ).format(DateTime(bill.year, bill.month));
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
          children: [
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
              children: [
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
                    'Citizenship: ${tenant.citizenshipNumber}',
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
              children: [
                Text(
                  'Period: $monthName',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Due: $dueDateStr',
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
                children: [
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
            for (final entry in bill.dynamicCharges.entries)
              _chargeRow(
                entry.key,
                '${l10n.get('currency')}${entry.value.toStringAsFixed(0)}',
              ),
            for (final entry in bill.dynamicDeductions.entries)
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
                  children: [
                    const TextSpan(
                      text: 'TOTAL  ',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
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

            if (bill.paidAmount > 0) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Paid: ${Constants.currency}${bill.paidAmount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF16A34A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Outstanding: ${Constants.currency}${bill.outstandingAmount.toStringAsFixed(0)}',
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
            _statusBadge(bill.status),

            const SizedBox(height: 20),

            // Thin divider
            const Divider(height: 1, thickness: 0.5, color: Color(0xFFE2E8F0)),
            const SizedBox(height: 10),

            // Footer
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Thank you!',
                style: TextStyle(
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

  Widget _chargeRow(String label, String amount) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF0F0F0), width: 0.5),
        ),
      ),
      child: Row(
        children: [
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
  }

  Widget _statusBadge(PaymentStatus status) {
    Color color;
    String text;

    switch (status) {
      case PaymentStatus.paid:
        color = const Color(0xFF16A34A);
        text = 'PAID';
      case PaymentStatus.pending:
        color = const Color(0xFFF59E0B);
        text = 'PENDING';
      case PaymentStatus.overdue:
        color = const Color(0xFFDC2626);
        text = 'OVERDUE';
      case PaymentStatus.partiallyPaid:
        color = const Color(0xFF2563EB);
        text = 'PARTIALLY PAID';
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
