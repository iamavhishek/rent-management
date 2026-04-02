import 'dart:io';

import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/models/property/property_model.dart';
import 'package:rent_bill_maker/models/tenant/tenant_model.dart';
import 'package:rent_bill_maker/utils/constants.dart';

class PdfGenerator {
  static Future<String> generateBillPDF(BillModel bill) async {
    try {
      final propertyBox = Hive.box<PropertyModel>(Constants.propertiesBox);
      final tenantBox = Hive.box<TenantModel>(Constants.tenantsBox);

      final property = propertyBox.get(bill.propertyId);
      final tenant = tenantBox.get(bill.tenantId);

      if (property == null || tenant == null) {
        throw Exception('Property or Tenant not found');
      }

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
          build: (pw.Context context) => [
            _buildHeader(property),
            pw.SizedBox(height: 10),
            _buildBillTitle(bill),
            pw.Divider(height: 20, thickness: 0.5),
            _buildInfoSection(property, tenant),
            pw.Divider(height: 20, thickness: 0.5),
            _buildBillPeriod(bill),
            pw.Divider(height: 20, thickness: 0.5),
            _buildChargesTable(bill),
            pw.SizedBox(height: 10),
            _buildTotalSection(bill),
            pw.Divider(height: 30, thickness: 0.5),
            _buildFooter(),
          ],
        ),
      );

      final output = await getApplicationDocumentsDirectory();
      final fileName = 'rent_bill_${bill.billNumber.replaceAll('/', '_')}.pdf';
      final file = File('${output.path}/$fileName');
      await file.writeAsBytes(await pdf.save());

      return file.path;
    } catch (e) {
      throw Exception('Failed to generate PDF: $e');
    }
  }

  static pw.Widget _buildHeader(PropertyModel property) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          property.ownerName,
          style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'घरधनी',
          style: pw.TextStyle(fontSize: 11, color: PdfColors.grey600),
        ),
        pw.SizedBox(height: 6),
        pw.Text(property.ownerPhone, style: pw.TextStyle(fontSize: 10)),
      ],
    );
  }

  static pw.Widget _buildBillTitle(BillModel bill) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 8),
      padding: const pw.EdgeInsets.all(10),
      color: PdfColors.grey100,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'भाडा बिल',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue800,
                ),
              ),
              pw.Text(
                'Bill No: ${bill.billNumber}',
                style: pw.TextStyle(fontSize: 9),
              ),
            ],
          ),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Text(
              _getPaymentStatusText(bill.status),
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                color: _getPaymentStatusColor(bill.status),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildInfoSection(
    PropertyModel property,
    TenantModel tenant,
  ) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'सम्पत्ति विवरण',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(property.name, style: pw.TextStyle(fontSize: 10)),
              pw.Text(property.address, style: pw.TextStyle(fontSize: 10)),
              if (property.unitNumber.isNotEmpty)
                pw.Text(
                  'कोठा: ${property.unitNumber}',
                  style: pw.TextStyle(fontSize: 10),
                ),
            ],
          ),
        ),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'भाडावाल विवरण',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(tenant.name, style: pw.TextStyle(fontSize: 10)),
              pw.Text(tenant.phone, style: pw.TextStyle(fontSize: 10)),
              if (tenant.citizenshipNumber.isNotEmpty)
                pw.Text(
                  'नागरिकता: ${tenant.citizenshipNumber}',
                  style: pw.TextStyle(fontSize: 10),
                ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildBillPeriod(BillModel bill) {
    final monthName = DateFormat('MMMM yyyy').format(
      DateTime(bill.year, bill.month),
    );

    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.RichText(
          text: pw.TextSpan(
            children: [
              pw.TextSpan(
                text: 'अवधि: ',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
              ),
              pw.TextSpan(text: monthName, style: pw.TextStyle(fontSize: 10)),
            ],
          ),
        ),
        pw.RichText(
          text: pw.TextSpan(
            children: [
              pw.TextSpan(
                text: 'तिर्ने मिति: ',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
              ),
              pw.TextSpan(
                text: DateFormat('dd MMM yyyy').format(bill.dueDate),
                style: pw.TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildChargesTable(BillModel bill) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey100),
          children: [
            _buildTableCell('विवरण', fontWeight: pw.FontWeight.bold),
            _buildTableCell(
              'रकम (रू)',
              fontWeight: pw.FontWeight.bold,
              alignment: pw.Alignment.centerRight,
            ),
          ],
        ),
        _buildTableRow('भाडा', bill.rentAmount),
        if (bill.electricityCharges > 0)
          _buildTableRow('बिजुली', bill.electricityCharges),
        if (bill.waterCharges > 0)
          _buildTableRow('पानी', bill.waterCharges),
        if (bill.internetCharges > 0)
          _buildTableRow('इन्टरनेट', bill.internetCharges),
        if (bill.otherCharges > 0)
          _buildTableRow(
            bill.otherChargesDescription.isNotEmpty
                ? bill.otherChargesDescription
                : 'अन्य',
            bill.otherCharges,
          ),
        ...bill.dynamicCharges.entries.map((e) => _buildTableRow(e.key, e.value)),
        ...bill.dynamicDeductions.entries.map((e) => _buildTableRow(e.key, -e.value)),
        if (bill.discount > 0) _buildTableRow('छुट', -bill.discount),
      ],
    );
  }

  static pw.Widget _buildTotalSection(BillModel bill) {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Text(
            'जम्मा: रू${bill.totalAmount.toStringAsFixed(2)}',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          if (bill.paidAmount > 0) ...[
            pw.SizedBox(height: 4),
            pw.Text(
              'तिरिएको: रू${bill.paidAmount.toStringAsFixed(2)}',
              style: pw.TextStyle(fontSize: 10),
            ),
            pw.Text(
              'बाँकी: रू${bill.outstandingAmount.toStringAsFixed(2)}',
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: bill.outstandingAmount > 0
                    ? PdfColors.red
                    : PdfColors.green,
              ),
            ),
          ],
        ],
      ),
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Column(
      children: [
        pw.Text(
          'यो कम्प्युटरबाट बनाइएको बिल हो, हस्ताक्षर आवश्यक छैन।',
          style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'धन्यवाद!',
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          textAlign: pw.TextAlign.center,
        ),
      ],
    );
  }

  static pw.Widget _buildTableCell(
    String text, {
    pw.FontWeight? fontWeight,
    pw.Alignment alignment = pw.Alignment.centerLeft,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Align(
        alignment: alignment,
        child: pw.Text(
          text,
          style: pw.TextStyle(fontWeight: fontWeight, fontSize: 10),
        ),
      ),
    );
  }

  static pw.TableRow _buildTableRow(String description, double amount) {
    return pw.TableRow(
      children: [
        _buildTableCell(description),
        _buildTableCell(
          'रू${amount.toStringAsFixed(2)}',
          alignment: pw.Alignment.centerRight,
        ),
      ],
    );
  }

  static String _getPaymentStatusText(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return 'तिरिएको';
      case PaymentStatus.pending:
        return 'बाँकी';
      case PaymentStatus.overdue:
        return 'म्याद सकियो';
      case PaymentStatus.partiallyPaid:
        return 'आंशिक';
    }
  }

  static PdfColor _getPaymentStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return PdfColors.green;
      case PaymentStatus.pending:
        return PdfColors.orange;
      case PaymentStatus.overdue:
        return PdfColors.red;
      case PaymentStatus.partiallyPaid:
        return PdfColors.blue;
    }
  }
}
