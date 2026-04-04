import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:uuid/uuid.dart';

part 'property_model.freezed.dart';
part 'property_model.g.dart';

@freezed
@HiveType(typeId: 0)
abstract class PropertyModel with _$PropertyModel {
  const PropertyModel._();

  const factory PropertyModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String address,
    @HiveField(3) required String unitNumber,
    @HiveField(4) required double monthlyRent,
    @HiveField(5) required double securityDeposit,
    @HiveField(6) required String ownerName,
    @HiveField(7) required String ownerPhone,
    @HiveField(13) required DateTime createdAt,
    @HiveField(14) required DateTime updatedAt,
    @HiveField(15) required bool isActive,
  }) = _PropertyModel;

  factory PropertyModel.create({
    required String name,
    required String address,
    required String unitNumber,
    required double monthlyRent,
    required String ownerName, required String ownerPhone, double securityDeposit = 0,
  }) {
    final DateTime now = DateTime.now();
    return PropertyModel(
      id: const Uuid().v4(),
      name: name,
      address: address,
      unitNumber: unitNumber,
      monthlyRent: monthlyRent,
      securityDeposit: securityDeposit,
      ownerName: ownerName,
      ownerPhone: ownerPhone,
      createdAt: now,
      updatedAt: now,
      isActive: true,
    );
  }

  factory PropertyModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyModelFromJson(json);
}
