import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:nepali_utils/nepali_utils.dart';
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

  Future<Map<String, dynamic>> getMonthlyReport(
    int month,
    int year,
    DateSystem dateSystem,
  ) async {
    // 1. Determine the target Gregorian year/month for storage lookups
    int targetStorageMonth;
    int targetStorageYear;

    if (dateSystem == DateSystem.ad) {
      targetStorageMonth = month;
      targetStorageYear = year;
    } else {
      final DateTime adDate = NepaliDateTime(year, month).toDateTime();
      targetStorageMonth = adDate.month;
      targetStorageYear = adDate.year;
    }

    // Define the actual timeframe boundaries for COLLECTION tracking (based on paidDate)
    late DateTime timeframeStart;
    late DateTime timeframeEnd;

    if (dateSystem == DateSystem.ad) {
      timeframeStart = DateTime(year, month);
      timeframeEnd = DateTime(
        year,
        month + 1,
      ).subtract(const Duration(seconds: 1));
    } else {
      timeframeStart = NepaliDateTime(year, month).toDateTime();
      final int nextMonth = month == 12 ? 1 : month + 1;
      final int nextYear = month == 12 ? year + 1 : year;
      timeframeEnd = NepaliDateTime(
        nextYear,
        nextMonth,
      ).toDateTime().subtract(const Duration(seconds: 1));
    }

    final List<BillModel> allBills = billBox.values.toList();

    // A bill BELONGS to this period if its storage year/month exactly matches
    final List<BillModel> periodBills = allBills.where((BillModel bill) => bill.month == targetStorageMonth && bill.year == targetStorageYear).toList();

    // A bill is COLLECTED in this period if paidDate falls within the timeframe
    final List<BillModel> collectionBills = allBills.where((BillModel bill) {
      if (bill.paidDate == null) return false;
      return bill.paidDate!.isAfter(
            timeframeStart.subtract(const Duration(seconds: 1)),
          ) &&
          bill.paidDate!.isBefore(timeframeEnd.add(const Duration(seconds: 1)));
    }).toList();

    double totalRentCollected = 0;
    double totalPending = 0;
    double totalOverdue = 0;
    final int paidCount = collectionBills.length;
    int pendingCount = 0;
    int overdueCount = 0;

    // Total Collection comes from bills paid in this timeframe
    for (BillModel bill in collectionBills) {
      totalRentCollected += bill.paidAmount;
    }

    // Pending and Overdue counts come from the bills BELONGING to this period
    for (BillModel bill in periodBills) {
      if (bill.status == PaymentStatus.pending ||
          bill.status == PaymentStatus.partiallyPaid) {
        totalPending += bill.outstandingAmount;
        pendingCount++;
      }
      if (bill.isOverdue) {
        totalOverdue += bill.outstandingAmount;
        overdueCount++;
      }
    }

    final double totalBillAmountForPeriod = periodBills.fold<double>(
      0.0,
      (double sum, BillModel bill) => sum + bill.totalAmount,
    );

    return <String, dynamic>{
      'totalBills': periodBills.length,
      'totalRentCollected': totalRentCollected,
      'totalPending': totalPending,
      'totalOverdue': totalOverdue,
      'paidCount': paidCount,
      'pendingCount': pendingCount,
      'overdueCount': overdueCount,
      'collectionRate': totalBillAmountForPeriod == 0
          ? 0.0
          : (totalRentCollected / totalBillAmountForPeriod) * 100,
    };
  }

  Future<Map<String, dynamic>> getYearlyReport(
    int year,
    DateSystem dateSystem,
  ) async {
    late DateTime targetYearStart;
    late DateTime targetYearEnd;

    if (dateSystem == DateSystem.ad) {
      targetYearStart = DateTime(year);
      targetYearEnd = DateTime(year, 12, 31, 23, 59, 59);
    } else {
      targetYearStart = NepaliDateTime(year).toDateTime();
      targetYearEnd = NepaliDateTime(
        year + 1,
      ).toDateTime().subtract(const Duration(seconds: 1));
    }

    final List<BillModel> allBills = billBox.values.toList();

    // Filter bills BELONGING to this timeframe
    final List<BillModel> periodBills = allBills.where((BillModel bill) {
      if (dateSystem == DateSystem.ad) {
        return bill.year == year;
      } else {
        // Find if its storage date maps to this target year in BS
        final NepaliDateTime midDate = DateTime(bill.year, bill.month, 15).toNepaliDateTime();
        return midDate.year == year;
      }
    }).toList();

    // Filter bills COLLECTED in this timeframe
    final List<BillModel> collectionBills = allBills.where((BillModel bill) {
      if (bill.paidDate == null) return false;
      return bill.paidDate!.isAfter(
            targetYearStart.subtract(const Duration(seconds: 1)),
          ) &&
          bill.paidDate!.isBefore(
            targetYearEnd.add(const Duration(seconds: 1)),
          );
    }).toList();

    final Map<int, double> monthlyCollection = <int, double>{};
    final Map<int, int> monthlyBillsCount = <int, int>{};

    for (int month = 1; month <= 12; month++) {
      monthlyCollection[month] = 0;
      monthlyBillsCount[month] = 0;
    }

    // Monthly breakdown of actual COLLECTIONS
    for (BillModel bill in collectionBills) {
      if (bill.paidDate != null) {
        int month;
        if (dateSystem == DateSystem.ad) {
          month = bill.paidDate!.month;
        } else {
          month = bill.paidDate!.toNepaliDateTime().month;
        }
        if (month >= 1 && month <= 12) {
          monthlyCollection[month] =
              (monthlyCollection[month] ?? 0) + bill.paidAmount;
        }
      }
    }

    // Snapshot of bills BELONGING to this timeframe
    for (BillModel bill in periodBills) {
      int month;
      if (dateSystem == DateSystem.ad) {
        month = bill.month;
      } else {
        final NepaliDateTime midDate = DateTime(bill.year, bill.month, 15).toNepaliDateTime();
        month = midDate.month;
      }
      if (month >= 1 && month <= 12) {
        monthlyBillsCount[month] = (monthlyBillsCount[month] ?? 0) + 1;
      }
    }

    return <String, dynamic>{
      'totalYearlyCollection': monthlyCollection.values.fold<double>(
        0.0,
        (double sum, double val) => sum + val,
      ),
      'totalBills': periodBills.length,
      'monthlyCollection': monthlyCollection,
      'monthlyBills': monthlyBillsCount,
    };
  }
}
