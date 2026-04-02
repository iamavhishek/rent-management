// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PropertyModelAdapter extends TypeAdapter<PropertyModel> {
  @override
  final typeId = 0;

  @override
  PropertyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PropertyModel(
      id: fields[0] as String,
      name: fields[1] as String,
      address: fields[2] as String,
      unitNumber: fields[3] as String,
      monthlyRent: (fields[4] as num).toDouble(),
      securityDeposit: (fields[5] as num).toDouble(),
      ownerName: fields[6] as String,
      ownerPhone: fields[7] as String,
      createdAt: fields[13] as DateTime,
      updatedAt: fields[14] as DateTime,
      isActive: fields[15] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PropertyModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.unitNumber)
      ..writeByte(4)
      ..write(obj.monthlyRent)
      ..writeByte(5)
      ..write(obj.securityDeposit)
      ..writeByte(6)
      ..write(obj.ownerName)
      ..writeByte(7)
      ..write(obj.ownerPhone)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt)
      ..writeByte(15)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PropertyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyModel _$PropertyModelFromJson(Map<String, dynamic> json) =>
    PropertyModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      unitNumber: json['unitNumber'] as String,
      monthlyRent: (json['monthlyRent'] as num).toDouble(),
      securityDeposit: (json['securityDeposit'] as num).toDouble(),
      ownerName: json['ownerName'] as String,
      ownerPhone: json['ownerPhone'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$PropertyModelToJson(PropertyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'unitNumber': instance.unitNumber,
      'monthlyRent': instance.monthlyRent,
      'securityDeposit': instance.securityDeposit,
      'ownerName': instance.ownerName,
      'ownerPhone': instance.ownerPhone,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'isActive': instance.isActive,
    };
