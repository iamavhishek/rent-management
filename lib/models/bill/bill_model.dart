import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:uuid/uuid.dart';

part 'bill_model.freezed.dart';
part 'bill_model.g.dart';

@HiveType(typeId: 4)
enum PaymentStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  paid,
  @HiveField(2)
  overdue,
  @HiveField(3)
  partiallyPaid,
}

@HiveType(typeId: 5)
enum DateSystem {
  @HiveField(0)
  ad,
  @HiveField(1)
  bs,
}

@freezed
@HiveType(typeId: 2)
abstract class BillModel with _$BillModel {
  factory BillModel.fromJson(Map<String, dynamic> json) =>
      _$BillModelFromJson(json);
  const BillModel._();

  const factory BillModel({
    @HiveField(0) required String id,
    @HiveField(1) required String billNumber,
    @HiveField(2) required String tenantId,
    @HiveField(3) required String propertyId,
    @HiveField(4) required int month,
    @HiveField(5) required int year,
    @HiveField(6) required double rentAmount,
    @HiveField(7) required double electricityCharges,
    @HiveField(8) required double waterCharges,
    @HiveField(10) required double internetCharges,
    @HiveField(14) required double otherCharges,
    @HiveField(15) required String otherChargesDescription,
    @HiveField(16) required double discount,
    @HiveField(17) required double totalAmount,
    @HiveField(18) required double paidAmount,
    @HiveField(19) required DateTime dueDate,
    @HiveField(20) required PaymentStatus status,
    @HiveField(26) required DateTime createdAt,
    @HiveField(27) required DateTime updatedAt,
    @HiveField(21) DateTime? paidDate,
    @HiveField(22) String? paymentMode,
    @HiveField(24) String? notes,
    @HiveField(25) String? pdfPath,
    @HiveField(28)
    @Default(<String, double>{})
    Map<String, double> dynamicCharges,
    @HiveField(29)
    @Default(<String, double>{})
    Map<String, double> dynamicDeductions,
    @HiveField(31) double? electricityUnits,
    @HiveField(32) double? waterUnits,
    @HiveField(33) double? previousElectricityReading,
    @HiveField(34) double? currentElectricityReading,
    @HiveField(35) double? previousWaterReading,
    @HiveField(36) double? currentWaterReading,
  }) = _BillModel;

  factory BillModel.create({
    required String tenantId,
    required String propertyId,
    required int month,
    required int year,
    required double rentAmount,
    required DateTime dueDate,
    double electricityCharges = 0,
    double waterCharges = 0,
    double internetCharges = 0,
    double otherCharges = 0,
    String otherChargesDescription = '',
    double discount = 0,
    Map<String, double> dynamicCharges = const <String, double>{},
    Map<String, double> dynamicDeductions = const <String, double>{},
    double? electricityUnits,
    double? waterUnits,
    double? previousElectricityReading,
    double? currentElectricityReading,
    double? previousWaterReading,
    double? currentWaterReading,
  }) {
    final double totalAmount =
        rentAmount +
        electricityCharges +
        waterCharges +
        internetCharges +
        otherCharges -
        discount;

    double extraChargesSum = 0;
    for (double value in dynamicCharges.values) {
      extraChargesSum += value;
    }

    double deductionsSum = 0;
    for (double value in dynamicDeductions.values) {
      deductionsSum += value;
    }

    final double finalTotal = totalAmount + extraChargesSum - deductionsSum;

    final DateTime now = DateTime.now();
    return BillModel(
      id: const Uuid().v4(),
      billNumber:
          'BILL-$year-${month.toString().padLeft(2, '0')}-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      tenantId: tenantId,
      propertyId: propertyId,
      month: month,
      year: year,
      rentAmount: rentAmount,
      electricityCharges: electricityCharges,
      waterCharges: waterCharges,
      internetCharges: internetCharges,
      otherCharges: otherCharges,
      otherChargesDescription: otherChargesDescription,
      discount: discount,
      dynamicCharges: dynamicCharges,
      dynamicDeductions: dynamicDeductions,
      totalAmount: finalTotal,
      paidAmount: 0,
      dueDate: dueDate,
      status: PaymentStatus.pending,
      createdAt: now,
      updatedAt: now,
      electricityUnits: electricityUnits,
      waterUnits: waterUnits,
      previousElectricityReading: previousElectricityReading,
      currentElectricityReading: currentElectricityReading,
      previousWaterReading: previousWaterReading,
      currentWaterReading: currentWaterReading,
    );
  }

  double get outstandingAmount => totalAmount - paidAmount;
  bool get isFullyPaid => paidAmount >= totalAmount;
  bool get isOverdue =>
      dueDate.isBefore(DateTime.now()) && status != PaymentStatus.paid;
}
