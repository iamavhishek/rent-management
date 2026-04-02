import 'package:equatable/equatable.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'property_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class PropertyModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String address;

  @HiveField(3)
  final String unitNumber;

  @HiveField(4)
  final double monthlyRent;

  @HiveField(5)
  final double securityDeposit;

  @HiveField(6)
  final String ownerName;

  @HiveField(7)
  final String ownerPhone;

  @HiveField(13)
  final DateTime createdAt;

  @HiveField(14)
  final DateTime updatedAt;

  @HiveField(15)
  final bool isActive;

  const PropertyModel({
    required this.id,
    required this.name,
    required this.address,
    required this.unitNumber,
    required this.monthlyRent,
    required this.securityDeposit,
    required this.ownerName,
    required this.ownerPhone,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  factory PropertyModel.create({
    required String name,
    required String address,
    required String unitNumber,
    required double monthlyRent,
    double securityDeposit = 0,
    required String ownerName,
    required String ownerPhone,
  }) {
    final now = DateTime.now();
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

  PropertyModel copyWith({
    String? name,
    String? address,
    String? unitNumber,
    double? monthlyRent,
    double? securityDeposit,
    String? ownerName,
    String? ownerPhone,
    bool? isActive,
  }) {
    return PropertyModel(
      id: id,
      name: name ?? this.name,
      address: address ?? this.address,
      unitNumber: unitNumber ?? this.unitNumber,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      securityDeposit: securityDeposit ?? this.securityDeposit,
      ownerName: ownerName ?? this.ownerName,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      isActive: isActive ?? this.isActive,
    );
  }

  factory PropertyModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyModelFromJson(json);
  Map<String, dynamic> toJson() => _$PropertyModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    name,
    address,
    unitNumber,
    monthlyRent,
    securityDeposit,
    ownerName,
    ownerPhone,
    createdAt,
    updatedAt,
    isActive,
  ];
}
