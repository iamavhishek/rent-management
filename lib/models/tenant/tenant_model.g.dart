// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TenantModelAdapter extends TypeAdapter<TenantModel> {
  @override
  final typeId = 1;

  @override
  TenantModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TenantModel(
      id: fields[0] as String,
      name: fields[1] as String,
      phone: fields[2] as String,
      propertyId: fields[4] as String,
      moveInDate: fields[5] as DateTime,
      leaseEndDate: fields[6] as DateTime?,
      citizenshipNumber: fields[9] as String,
      citizenshipImagePath: fields[10] as String?,
      createdAt: fields[11] as DateTime,
      updatedAt: fields[12] as DateTime,
      isActive: fields[13] as bool,
      electricityRate: fields[14] == null ? 0 : (fields[14] as num).toDouble(),
      waterRate: fields[15] == null ? 0 : (fields[15] as num).toDouble(),
      initialElectricityReading: fields[16] == null
          ? 0
          : (fields[16] as num).toDouble(),
      initialWaterReading: fields[17] == null
          ? 0
          : (fields[17] as num).toDouble(),
      leftDate: fields[18] as DateTime?,
      monthlyRent: fields[19] == null ? 0 : (fields[19] as num).toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, TenantModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.propertyId)
      ..writeByte(5)
      ..write(obj.moveInDate)
      ..writeByte(6)
      ..write(obj.leaseEndDate)
      ..writeByte(9)
      ..write(obj.citizenshipNumber)
      ..writeByte(10)
      ..write(obj.citizenshipImagePath)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt)
      ..writeByte(13)
      ..write(obj.isActive)
      ..writeByte(14)
      ..write(obj.electricityRate)
      ..writeByte(15)
      ..write(obj.waterRate)
      ..writeByte(16)
      ..write(obj.initialElectricityReading)
      ..writeByte(17)
      ..write(obj.initialWaterReading)
      ..writeByte(18)
      ..write(obj.leftDate)
      ..writeByte(19)
      ..write(obj.monthlyRent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TenantModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TenantModel _$TenantModelFromJson(Map<String, dynamic> json) => _TenantModel(
  id: json['id'] as String,
  name: json['name'] as String,
  phone: json['phone'] as String,
  propertyId: json['propertyId'] as String,
  moveInDate: DateTime.parse(json['moveInDate'] as String),
  leaseEndDate: json['leaseEndDate'] == null
      ? null
      : DateTime.parse(json['leaseEndDate'] as String),
  citizenshipNumber: json['citizenshipNumber'] as String,
  citizenshipImagePath: json['citizenshipImagePath'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  isActive: json['isActive'] as bool,
  electricityRate: (json['electricityRate'] as num?)?.toDouble() ?? 0,
  waterRate: (json['waterRate'] as num?)?.toDouble() ?? 0,
  initialElectricityReading:
      (json['initialElectricityReading'] as num?)?.toDouble() ?? 0,
  initialWaterReading: (json['initialWaterReading'] as num?)?.toDouble() ?? 0,
  leftDate: json['leftDate'] == null
      ? null
      : DateTime.parse(json['leftDate'] as String),
  monthlyRent: (json['monthlyRent'] as num?)?.toDouble() ?? 0,
);

Map<String, dynamic> _$TenantModelToJson(_TenantModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'propertyId': instance.propertyId,
      'moveInDate': instance.moveInDate.toIso8601String(),
      'leaseEndDate': instance.leaseEndDate?.toIso8601String(),
      'citizenshipNumber': instance.citizenshipNumber,
      'citizenshipImagePath': instance.citizenshipImagePath,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'isActive': instance.isActive,
      'electricityRate': instance.electricityRate,
      'waterRate': instance.waterRate,
      'initialElectricityReading': instance.initialElectricityReading,
      'initialWaterReading': instance.initialWaterReading,
      'leftDate': instance.leftDate?.toIso8601String(),
      'monthlyRent': instance.monthlyRent,
    };
