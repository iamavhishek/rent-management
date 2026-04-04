import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:uuid/uuid.dart';

part 'tenant_model.freezed.dart';
part 'tenant_model.g.dart';

@freezed
@HiveType(typeId: 1)
abstract class TenantModel with _$TenantModel {
  const TenantModel._();

  const factory TenantModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String phone,
    @HiveField(4) required String propertyId,
    @HiveField(5) required DateTime moveInDate,
    @HiveField(9) required String citizenshipNumber, @HiveField(11) required DateTime createdAt, @HiveField(12) required DateTime updatedAt, @HiveField(13) required bool isActive, @HiveField(6) DateTime? leaseEndDate,
    @HiveField(10) String? citizenshipImagePath,
    @HiveField(14) @Default(0) double electricityRate,
    @HiveField(15) @Default(0) double waterRate,
    @HiveField(16) @Default(0) double initialElectricityReading,
    @HiveField(17) @Default(0) double initialWaterReading,
    @HiveField(18) DateTime? leftDate,
    @HiveField(19) @Default(0) double monthlyRent,
  }) = _TenantModel;

  factory TenantModel.create({
    required String name,
    required String phone,
    required String propertyId,
    required DateTime moveInDate,
    required String citizenshipNumber, DateTime? leaseEndDate,
    String? citizenshipImagePath,
    DateTime? leftDate,
    double electricityRate = 0,
    double waterRate = 0,
    double initialElectricityReading = 0,
    double initialWaterReading = 0,
    double monthlyRent = 0,
  }) {
    final DateTime now = DateTime.now();
    return TenantModel(
      id: const Uuid().v4(),
      name: name,
      phone: phone,
      propertyId: propertyId,
      moveInDate: moveInDate,
      leaseEndDate: leaseEndDate,
      citizenshipNumber: citizenshipNumber,
      citizenshipImagePath: citizenshipImagePath,
      createdAt: now,
      updatedAt: now,
      isActive: true,
      leftDate: leftDate,
      electricityRate: electricityRate,
      waterRate: waterRate,
      initialElectricityReading: initialElectricityReading,
      initialWaterReading: initialWaterReading,
      monthlyRent: monthlyRent,
    );
  }

  factory TenantModel.fromJson(Map<String, dynamic> json) =>
      _$TenantModelFromJson(json);
}
