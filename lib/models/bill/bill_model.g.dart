// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BillModelAdapter extends TypeAdapter<BillModel> {
  @override
  final typeId = 2;

  @override
  BillModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BillModel(
      id: fields[0] as String,
      billNumber: fields[1] as String,
      tenantId: fields[2] as String,
      propertyId: fields[3] as String,
      month: (fields[4] as num).toInt(),
      year: (fields[5] as num).toInt(),
      dateSystem: fields[30] == null ? DateSystem.ad : fields[30] as DateSystem,
      rentAmount: (fields[6] as num).toDouble(),
      electricityCharges: (fields[7] as num).toDouble(),
      waterCharges: (fields[8] as num).toDouble(),
      internetCharges: (fields[10] as num).toDouble(),
      otherCharges: (fields[14] as num).toDouble(),
      otherChargesDescription: fields[15] as String,
      discount: (fields[16] as num).toDouble(),
      totalAmount: (fields[17] as num).toDouble(),
      paidAmount: (fields[18] as num).toDouble(),
      dueDate: fields[19] as DateTime,
      status: fields[20] as PaymentStatus,
      paidDate: fields[21] as DateTime?,
      paymentMode: fields[22] as String?,
      notes: fields[24] as String?,
      pdfPath: fields[25] as String?,
      createdAt: fields[26] as DateTime,
      updatedAt: fields[27] as DateTime,
      dynamicCharges: fields[28] == null
          ? const {}
          : (fields[28] as Map).cast<String, double>(),
      dynamicDeductions: fields[29] == null
          ? const {}
          : (fields[29] as Map).cast<String, double>(),
      electricityUnits: (fields[31] as num?)?.toDouble(),
      waterUnits: (fields[32] as num?)?.toDouble(),
      previousElectricityReading: (fields[33] as num?)?.toDouble(),
      currentElectricityReading: (fields[34] as num?)?.toDouble(),
      previousWaterReading: (fields[35] as num?)?.toDouble(),
      currentWaterReading: (fields[36] as num?)?.toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, BillModel obj) {
    writer
      ..writeByte(32)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.billNumber)
      ..writeByte(2)
      ..write(obj.tenantId)
      ..writeByte(3)
      ..write(obj.propertyId)
      ..writeByte(4)
      ..write(obj.month)
      ..writeByte(5)
      ..write(obj.year)
      ..writeByte(6)
      ..write(obj.rentAmount)
      ..writeByte(7)
      ..write(obj.electricityCharges)
      ..writeByte(8)
      ..write(obj.waterCharges)
      ..writeByte(10)
      ..write(obj.internetCharges)
      ..writeByte(14)
      ..write(obj.otherCharges)
      ..writeByte(15)
      ..write(obj.otherChargesDescription)
      ..writeByte(16)
      ..write(obj.discount)
      ..writeByte(17)
      ..write(obj.totalAmount)
      ..writeByte(18)
      ..write(obj.paidAmount)
      ..writeByte(19)
      ..write(obj.dueDate)
      ..writeByte(20)
      ..write(obj.status)
      ..writeByte(21)
      ..write(obj.paidDate)
      ..writeByte(22)
      ..write(obj.paymentMode)
      ..writeByte(24)
      ..write(obj.notes)
      ..writeByte(25)
      ..write(obj.pdfPath)
      ..writeByte(26)
      ..write(obj.createdAt)
      ..writeByte(27)
      ..write(obj.updatedAt)
      ..writeByte(28)
      ..write(obj.dynamicCharges)
      ..writeByte(29)
      ..write(obj.dynamicDeductions)
      ..writeByte(30)
      ..write(obj.dateSystem)
      ..writeByte(31)
      ..write(obj.electricityUnits)
      ..writeByte(32)
      ..write(obj.waterUnits)
      ..writeByte(33)
      ..write(obj.previousElectricityReading)
      ..writeByte(34)
      ..write(obj.currentElectricityReading)
      ..writeByte(35)
      ..write(obj.previousWaterReading)
      ..writeByte(36)
      ..write(obj.currentWaterReading);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PaymentStatusAdapter extends TypeAdapter<PaymentStatus> {
  @override
  final typeId = 4;

  @override
  PaymentStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PaymentStatus.pending;
      case 1:
        return PaymentStatus.paid;
      case 2:
        return PaymentStatus.overdue;
      case 3:
        return PaymentStatus.partiallyPaid;
      default:
        return PaymentStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, PaymentStatus obj) {
    switch (obj) {
      case PaymentStatus.pending:
        writer.writeByte(0);
      case PaymentStatus.paid:
        writer.writeByte(1);
      case PaymentStatus.overdue:
        writer.writeByte(2);
      case PaymentStatus.partiallyPaid:
        writer.writeByte(3);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DateSystemAdapter extends TypeAdapter<DateSystem> {
  @override
  final typeId = 5;

  @override
  DateSystem read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DateSystem.ad;
      case 1:
        return DateSystem.bs;
      default:
        return DateSystem.ad;
    }
  }

  @override
  void write(BinaryWriter writer, DateSystem obj) {
    switch (obj) {
      case DateSystem.ad:
        writer.writeByte(0);
      case DateSystem.bs:
        writer.writeByte(1);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateSystemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillModel _$BillModelFromJson(Map<String, dynamic> json) => BillModel(
  id: json['id'] as String,
  billNumber: json['billNumber'] as String,
  tenantId: json['tenantId'] as String,
  propertyId: json['propertyId'] as String,
  month: (json['month'] as num).toInt(),
  year: (json['year'] as num).toInt(),
  dateSystem:
      $enumDecodeNullable(_$DateSystemEnumMap, json['dateSystem']) ??
      DateSystem.ad,
  rentAmount: (json['rentAmount'] as num).toDouble(),
  electricityCharges: (json['electricityCharges'] as num).toDouble(),
  waterCharges: (json['waterCharges'] as num).toDouble(),
  internetCharges: (json['internetCharges'] as num).toDouble(),
  otherCharges: (json['otherCharges'] as num).toDouble(),
  otherChargesDescription: json['otherChargesDescription'] as String,
  discount: (json['discount'] as num).toDouble(),
  totalAmount: (json['totalAmount'] as num).toDouble(),
  paidAmount: (json['paidAmount'] as num).toDouble(),
  dueDate: DateTime.parse(json['dueDate'] as String),
  status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
  paidDate: json['paidDate'] == null
      ? null
      : DateTime.parse(json['paidDate'] as String),
  paymentMode: json['paymentMode'] as String?,
  notes: json['notes'] as String?,
  pdfPath: json['pdfPath'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  dynamicCharges:
      (json['dynamicCharges'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ) ??
      const {},
  dynamicDeductions:
      (json['dynamicDeductions'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ) ??
      const {},
  electricityUnits: (json['electricityUnits'] as num?)?.toDouble(),
  waterUnits: (json['waterUnits'] as num?)?.toDouble(),
  previousElectricityReading: (json['previousElectricityReading'] as num?)
      ?.toDouble(),
  currentElectricityReading: (json['currentElectricityReading'] as num?)
      ?.toDouble(),
  previousWaterReading: (json['previousWaterReading'] as num?)?.toDouble(),
  currentWaterReading: (json['currentWaterReading'] as num?)?.toDouble(),
);

Map<String, dynamic> _$BillModelToJson(BillModel instance) => <String, dynamic>{
  'id': instance.id,
  'billNumber': instance.billNumber,
  'tenantId': instance.tenantId,
  'propertyId': instance.propertyId,
  'month': instance.month,
  'year': instance.year,
  'dateSystem': _$DateSystemEnumMap[instance.dateSystem]!,
  'rentAmount': instance.rentAmount,
  'electricityCharges': instance.electricityCharges,
  'waterCharges': instance.waterCharges,
  'internetCharges': instance.internetCharges,
  'otherCharges': instance.otherCharges,
  'otherChargesDescription': instance.otherChargesDescription,
  'discount': instance.discount,
  'totalAmount': instance.totalAmount,
  'paidAmount': instance.paidAmount,
  'dueDate': instance.dueDate.toIso8601String(),
  'status': _$PaymentStatusEnumMap[instance.status]!,
  'paidDate': instance.paidDate?.toIso8601String(),
  'paymentMode': instance.paymentMode,
  'notes': instance.notes,
  'pdfPath': instance.pdfPath,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'dynamicCharges': instance.dynamicCharges,
  'dynamicDeductions': instance.dynamicDeductions,
  'electricityUnits': instance.electricityUnits,
  'waterUnits': instance.waterUnits,
  'previousElectricityReading': instance.previousElectricityReading,
  'currentElectricityReading': instance.currentElectricityReading,
  'previousWaterReading': instance.previousWaterReading,
  'currentWaterReading': instance.currentWaterReading,
};

const _$DateSystemEnumMap = {DateSystem.ad: 'ad', DateSystem.bs: 'bs'};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.paid: 'paid',
  PaymentStatus.overdue: 'overdue',
  PaymentStatus.partiallyPaid: 'partiallyPaid',
};
