import 'package:equatable/equatable.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

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

@HiveType(typeId: 2)
@JsonSerializable()
class BillModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String billNumber;

  @HiveField(2)
  final String tenantId;

  @HiveField(3)
  final String propertyId;

  @HiveField(4)
  final int month;

  @HiveField(5)
  final int year;

  @HiveField(6)
  final double rentAmount;

  @HiveField(7)
  final double electricityCharges;

  @HiveField(8)
  final double waterCharges;

  @HiveField(10)
  final double internetCharges;

  @HiveField(14)
  final double otherCharges;

  @HiveField(15)
  final String otherChargesDescription;

  @HiveField(16)
  final double discount;

  @HiveField(17)
  final double totalAmount;

  @HiveField(18)
  final double paidAmount;

  @HiveField(19)
  final DateTime dueDate;

  @HiveField(20)
  final PaymentStatus status;

  @HiveField(21)
  final DateTime? paidDate;

  @HiveField(22)
  final String? paymentMode;

  @HiveField(24)
  final String? notes;

  @HiveField(25)
  final String? pdfPath;

  @HiveField(26)
  final DateTime createdAt;

  @HiveField(27)
  final DateTime updatedAt;

  @HiveField(28)
  final Map<String, double> dynamicCharges;

  @HiveField(29)
  final Map<String, double> dynamicDeductions;

  const BillModel({
    required this.id,
    required this.billNumber,
    required this.tenantId,
    required this.propertyId,
    required this.month,
    required this.year,
    required this.rentAmount,
    required this.electricityCharges,
    required this.waterCharges,
    required this.internetCharges,
    required this.otherCharges,
    required this.otherChargesDescription,
    required this.discount,
    required this.totalAmount,
    required this.paidAmount,
    required this.dueDate,
    required this.status,
    this.paidDate,
    this.paymentMode,
    this.notes,
    this.pdfPath,
    required this.createdAt,
    required this.updatedAt,
    this.dynamicCharges = const {},
    this.dynamicDeductions = const {},
  });

  factory BillModel.create({
    required String tenantId,
    required String propertyId,
    required int month,
    required int year,
    required double rentAmount,
    double electricityCharges = 0,
    double waterCharges = 0,
    double internetCharges = 0,
    double otherCharges = 0,
    String otherChargesDescription = '',
    double discount = 0,
    Map<String, double> dynamicCharges = const {},
    Map<String, double> dynamicDeductions = const {},
    required DateTime dueDate,
  }) {
    final totalAmount =
        rentAmount +
        electricityCharges +
        waterCharges +
        internetCharges +
        otherCharges -
        discount;

    double extraChargesSum = 0;
    for (var value in dynamicCharges.values) {
      extraChargesSum += value;
    }

    double deductionsSum = 0;
    for (var value in dynamicDeductions.values) {
      deductionsSum += value;
    }

    final finalTotal = totalAmount + extraChargesSum - deductionsSum;

    final now = DateTime.now();
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
    );
  }

  BillModel copyWith({
    String? id,
    String? billNumber,
    String? tenantId,
    String? propertyId,
    int? month,
    int? year,
    double? rentAmount,
    double? electricityCharges,
    double? waterCharges,
    double? internetCharges,
    double? otherCharges,
    String? otherChargesDescription,
    double? discount,
    double? totalAmount,
    double? paidAmount,
    DateTime? dueDate,
    PaymentStatus? status,
    DateTime? paidDate,
    String? paymentMode,
    String? notes,
    String? pdfPath,
    DateTime? updatedAt,
    Map<String, double>? dynamicCharges,
    Map<String, double>? dynamicDeductions,
  }) {
    return BillModel(
      id: id ?? this.id,
      billNumber: billNumber ?? this.billNumber,
      tenantId: tenantId ?? this.tenantId,
      propertyId: propertyId ?? this.propertyId,
      month: month ?? this.month,
      year: year ?? this.year,
      rentAmount: rentAmount ?? this.rentAmount,
      electricityCharges: electricityCharges ?? this.electricityCharges,
      waterCharges: waterCharges ?? this.waterCharges,
      internetCharges: internetCharges ?? this.internetCharges,
      otherCharges: otherCharges ?? this.otherCharges,
      otherChargesDescription:
          otherChargesDescription ?? this.otherChargesDescription,
      discount: discount ?? this.discount,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      paidDate: paidDate ?? this.paidDate,
      paymentMode: paymentMode ?? this.paymentMode,
      notes: notes ?? this.notes,
      pdfPath: pdfPath ?? this.pdfPath,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      dynamicCharges: dynamicCharges ?? this.dynamicCharges,
      dynamicDeductions: dynamicDeductions ?? this.dynamicDeductions,
    );
  }

  double get outstandingAmount => totalAmount - paidAmount;
  bool get isFullyPaid => paidAmount >= totalAmount;
  bool get isOverdue =>
      dueDate.isBefore(DateTime.now()) && status != PaymentStatus.paid;

  factory BillModel.fromJson(Map<String, dynamic> json) =>
      _$BillModelFromJson(json);
  Map<String, dynamic> toJson() => _$BillModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    billNumber,
    tenantId,
    propertyId,
    month,
    year,
    rentAmount,
    electricityCharges,
    waterCharges,
    internetCharges,
    otherCharges,
    otherChargesDescription,
    discount,
    totalAmount,
    paidAmount,
    dueDate,
    status,
    paidDate,
    paymentMode,
    notes,
    pdfPath,
    createdAt,
    updatedAt,
    dynamicCharges,
    dynamicDeductions,
  ];
}
