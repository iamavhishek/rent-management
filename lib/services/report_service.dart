import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/models/property/property_model.dart';
import 'package:rent_bill_maker/models/tenant/tenant_model.dart';
import 'package:rent_bill_maker/utils/constants.dart';

class ReportService {
  final Box<BillModel> billBox = Hive.box<BillModel>(Constants.billsBox);
  final Box<PropertyModel> propertyBox = Hive.box<PropertyModel>(
    Constants.propertiesBox,
  );
  final Box<TenantModel> tenantBox = Hive.box<TenantModel>(
    Constants.tenantsBox,
  );

  Future<Map<String, dynamic>> getMonthlyReport(int month, int year) async {
    final bills = billBox.values
        .where((bill) => bill.month == month && bill.year == year)
        .toList();

    double totalRentCollected = 0;
    double totalPending = 0;
    double totalOverdue = 0;
    int paidCount = 0;
    int pendingCount = 0;
    int overdueCount = 0;

    for (var bill in bills) {
      if (bill.status == PaymentStatus.paid) {
        totalRentCollected += bill.totalAmount;
        paidCount++;
      } else if (bill.status == PaymentStatus.pending ||
          bill.status == PaymentStatus.partiallyPaid) {
        totalPending += bill.outstandingAmount;
        pendingCount++;
      }
      if (bill.isOverdue) {
        totalOverdue += bill.outstandingAmount;
        overdueCount++;
      }
    }

    final totalBillAmount = bills.fold<double>(
      0.0,
      (sum, bill) => sum + bill.totalAmount,
    );

    return {
      'totalBills': bills.length,
      'totalRentCollected': totalRentCollected,
      'totalPending': totalPending,
      'totalOverdue': totalOverdue,
      'paidCount': paidCount,
      'pendingCount': pendingCount,
      'overdueCount': overdueCount,
      'collectionRate': totalBillAmount == 0
          ? 0.0
          : (totalRentCollected / totalBillAmount) * 100,
    };
  }

  Future<Map<String, dynamic>> getYearlyReport(int year) async {
    final bills = billBox.values.where((bill) => bill.year == year).toList();

    Map<int, double> monthlyCollection = {};
    Map<int, int> monthlyBills = {};

    for (int month = 1; month <= 12; month++) {
      monthlyCollection[month] = 0;
      monthlyBills[month] = 0;
    }

    for (var bill in bills) {
      if (bill.status == PaymentStatus.paid) {
        monthlyCollection[bill.month] =
            (monthlyCollection[bill.month] ?? 0) + bill.totalAmount;
        monthlyBills[bill.month] = (monthlyBills[bill.month] ?? 0) + 1;
      }
    }

    return {
      'totalYearlyCollection': monthlyCollection.values.fold<double>(
        0.0,
        (sum, val) => sum + val,
      ),
      'totalBills': bills.length,
      'monthlyCollection': monthlyCollection,
      'monthlyBills': monthlyBills,
    };
  }
}
