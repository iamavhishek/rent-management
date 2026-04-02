import 'package:equatable/equatable.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'tenant_model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class TenantModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String phone;

  @HiveField(4)
  final String propertyId;

  @HiveField(5)
  final DateTime moveInDate;

  @HiveField(6)
  final DateTime? leaseEndDate;

  @HiveField(9)
  final String citizenshipNumber;

  @HiveField(10)
  final String? citizenshipImagePath;

  @HiveField(11)
  final DateTime createdAt;

  @HiveField(12)
  final DateTime updatedAt;

  @HiveField(13)
  final bool isActive;

  const TenantModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.propertyId,
    required this.moveInDate,
    this.leaseEndDate,
    required this.citizenshipNumber,
    this.citizenshipImagePath,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  factory TenantModel.create({
    required String name,
    required String phone,
    required String propertyId,
    required DateTime moveInDate,
    DateTime? leaseEndDate,
    required String citizenshipNumber,
    String? citizenshipImagePath,
  }) {
    final now = DateTime.now();
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
    );
  }

  TenantModel copyWith({
    String? name,
    String? phone,
    String? propertyId,
    DateTime? moveInDate,
    DateTime? leaseEndDate,
    String? citizenshipNumber,
    String? citizenshipImagePath,
    bool? isActive,
  }) {
    return TenantModel(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      propertyId: propertyId ?? this.propertyId,
      moveInDate: moveInDate ?? this.moveInDate,
      leaseEndDate: leaseEndDate ?? this.leaseEndDate,
      citizenshipNumber: citizenshipNumber ?? this.citizenshipNumber,
      citizenshipImagePath: citizenshipImagePath ?? this.citizenshipImagePath,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      isActive: isActive ?? this.isActive,
    );
  }

  factory TenantModel.fromJson(Map<String, dynamic> json) =>
      _$TenantModelFromJson(json);
  Map<String, dynamic> toJson() => _$TenantModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    name,
    phone,
    propertyId,
    moveInDate,
    leaseEndDate,
    citizenshipNumber,
    citizenshipImagePath,
    createdAt,
    updatedAt,
    isActive,
  ];
}
