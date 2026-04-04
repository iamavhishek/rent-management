// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tenant_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TenantModel {

@HiveField(0) String get id;@HiveField(1) String get name;@HiveField(2) String get phone;@HiveField(4) String get propertyId;@HiveField(5) DateTime get moveInDate;@HiveField(6) DateTime? get leaseEndDate;@HiveField(9) String get citizenshipNumber;@HiveField(10) String? get citizenshipImagePath;@HiveField(11) DateTime get createdAt;@HiveField(12) DateTime get updatedAt;@HiveField(13) bool get isActive;@HiveField(14) double get electricityRate;@HiveField(15) double get waterRate;@HiveField(16) double get initialElectricityReading;@HiveField(17) double get initialWaterReading;@HiveField(18) DateTime? get leftDate;@HiveField(19) double get monthlyRent;
/// Create a copy of TenantModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TenantModelCopyWith<TenantModel> get copyWith => _$TenantModelCopyWithImpl<TenantModel>(this as TenantModel, _$identity);

  /// Serializes this TenantModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TenantModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.propertyId, propertyId) || other.propertyId == propertyId)&&(identical(other.moveInDate, moveInDate) || other.moveInDate == moveInDate)&&(identical(other.leaseEndDate, leaseEndDate) || other.leaseEndDate == leaseEndDate)&&(identical(other.citizenshipNumber, citizenshipNumber) || other.citizenshipNumber == citizenshipNumber)&&(identical(other.citizenshipImagePath, citizenshipImagePath) || other.citizenshipImagePath == citizenshipImagePath)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.electricityRate, electricityRate) || other.electricityRate == electricityRate)&&(identical(other.waterRate, waterRate) || other.waterRate == waterRate)&&(identical(other.initialElectricityReading, initialElectricityReading) || other.initialElectricityReading == initialElectricityReading)&&(identical(other.initialWaterReading, initialWaterReading) || other.initialWaterReading == initialWaterReading)&&(identical(other.leftDate, leftDate) || other.leftDate == leftDate)&&(identical(other.monthlyRent, monthlyRent) || other.monthlyRent == monthlyRent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phone,propertyId,moveInDate,leaseEndDate,citizenshipNumber,citizenshipImagePath,createdAt,updatedAt,isActive,electricityRate,waterRate,initialElectricityReading,initialWaterReading,leftDate,monthlyRent);

@override
String toString() {
  return 'TenantModel(id: $id, name: $name, phone: $phone, propertyId: $propertyId, moveInDate: $moveInDate, leaseEndDate: $leaseEndDate, citizenshipNumber: $citizenshipNumber, citizenshipImagePath: $citizenshipImagePath, createdAt: $createdAt, updatedAt: $updatedAt, isActive: $isActive, electricityRate: $electricityRate, waterRate: $waterRate, initialElectricityReading: $initialElectricityReading, initialWaterReading: $initialWaterReading, leftDate: $leftDate, monthlyRent: $monthlyRent)';
}


}

/// @nodoc
abstract mixin class $TenantModelCopyWith<$Res>  {
  factory $TenantModelCopyWith(TenantModel value, $Res Function(TenantModel) _then) = _$TenantModelCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String id,@HiveField(1) String name,@HiveField(2) String phone,@HiveField(4) String propertyId,@HiveField(5) DateTime moveInDate,@HiveField(6) DateTime? leaseEndDate,@HiveField(9) String citizenshipNumber,@HiveField(10) String? citizenshipImagePath,@HiveField(11) DateTime createdAt,@HiveField(12) DateTime updatedAt,@HiveField(13) bool isActive,@HiveField(14) double electricityRate,@HiveField(15) double waterRate,@HiveField(16) double initialElectricityReading,@HiveField(17) double initialWaterReading,@HiveField(18) DateTime? leftDate,@HiveField(19) double monthlyRent
});




}
/// @nodoc
class _$TenantModelCopyWithImpl<$Res>
    implements $TenantModelCopyWith<$Res> {
  _$TenantModelCopyWithImpl(this._self, this._then);

  final TenantModel _self;
  final $Res Function(TenantModel) _then;

/// Create a copy of TenantModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? phone = null,Object? propertyId = null,Object? moveInDate = null,Object? leaseEndDate = freezed,Object? citizenshipNumber = null,Object? citizenshipImagePath = freezed,Object? createdAt = null,Object? updatedAt = null,Object? isActive = null,Object? electricityRate = null,Object? waterRate = null,Object? initialElectricityReading = null,Object? initialWaterReading = null,Object? leftDate = freezed,Object? monthlyRent = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,propertyId: null == propertyId ? _self.propertyId : propertyId // ignore: cast_nullable_to_non_nullable
as String,moveInDate: null == moveInDate ? _self.moveInDate : moveInDate // ignore: cast_nullable_to_non_nullable
as DateTime,leaseEndDate: freezed == leaseEndDate ? _self.leaseEndDate : leaseEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,citizenshipNumber: null == citizenshipNumber ? _self.citizenshipNumber : citizenshipNumber // ignore: cast_nullable_to_non_nullable
as String,citizenshipImagePath: freezed == citizenshipImagePath ? _self.citizenshipImagePath : citizenshipImagePath // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,electricityRate: null == electricityRate ? _self.electricityRate : electricityRate // ignore: cast_nullable_to_non_nullable
as double,waterRate: null == waterRate ? _self.waterRate : waterRate // ignore: cast_nullable_to_non_nullable
as double,initialElectricityReading: null == initialElectricityReading ? _self.initialElectricityReading : initialElectricityReading // ignore: cast_nullable_to_non_nullable
as double,initialWaterReading: null == initialWaterReading ? _self.initialWaterReading : initialWaterReading // ignore: cast_nullable_to_non_nullable
as double,leftDate: freezed == leftDate ? _self.leftDate : leftDate // ignore: cast_nullable_to_non_nullable
as DateTime?,monthlyRent: null == monthlyRent ? _self.monthlyRent : monthlyRent // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [TenantModel].
extension TenantModelPatterns on TenantModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TenantModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TenantModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TenantModel value)  $default,){
final _that = this;
switch (_that) {
case _TenantModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TenantModel value)?  $default,){
final _that = this;
switch (_that) {
case _TenantModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  String id, @HiveField(1)  String name, @HiveField(2)  String phone, @HiveField(4)  String propertyId, @HiveField(5)  DateTime moveInDate, @HiveField(6)  DateTime? leaseEndDate, @HiveField(9)  String citizenshipNumber, @HiveField(10)  String? citizenshipImagePath, @HiveField(11)  DateTime createdAt, @HiveField(12)  DateTime updatedAt, @HiveField(13)  bool isActive, @HiveField(14)  double electricityRate, @HiveField(15)  double waterRate, @HiveField(16)  double initialElectricityReading, @HiveField(17)  double initialWaterReading, @HiveField(18)  DateTime? leftDate, @HiveField(19)  double monthlyRent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TenantModel() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.propertyId,_that.moveInDate,_that.leaseEndDate,_that.citizenshipNumber,_that.citizenshipImagePath,_that.createdAt,_that.updatedAt,_that.isActive,_that.electricityRate,_that.waterRate,_that.initialElectricityReading,_that.initialWaterReading,_that.leftDate,_that.monthlyRent);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  String id, @HiveField(1)  String name, @HiveField(2)  String phone, @HiveField(4)  String propertyId, @HiveField(5)  DateTime moveInDate, @HiveField(6)  DateTime? leaseEndDate, @HiveField(9)  String citizenshipNumber, @HiveField(10)  String? citizenshipImagePath, @HiveField(11)  DateTime createdAt, @HiveField(12)  DateTime updatedAt, @HiveField(13)  bool isActive, @HiveField(14)  double electricityRate, @HiveField(15)  double waterRate, @HiveField(16)  double initialElectricityReading, @HiveField(17)  double initialWaterReading, @HiveField(18)  DateTime? leftDate, @HiveField(19)  double monthlyRent)  $default,) {final _that = this;
switch (_that) {
case _TenantModel():
return $default(_that.id,_that.name,_that.phone,_that.propertyId,_that.moveInDate,_that.leaseEndDate,_that.citizenshipNumber,_that.citizenshipImagePath,_that.createdAt,_that.updatedAt,_that.isActive,_that.electricityRate,_that.waterRate,_that.initialElectricityReading,_that.initialWaterReading,_that.leftDate,_that.monthlyRent);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  String id, @HiveField(1)  String name, @HiveField(2)  String phone, @HiveField(4)  String propertyId, @HiveField(5)  DateTime moveInDate, @HiveField(6)  DateTime? leaseEndDate, @HiveField(9)  String citizenshipNumber, @HiveField(10)  String? citizenshipImagePath, @HiveField(11)  DateTime createdAt, @HiveField(12)  DateTime updatedAt, @HiveField(13)  bool isActive, @HiveField(14)  double electricityRate, @HiveField(15)  double waterRate, @HiveField(16)  double initialElectricityReading, @HiveField(17)  double initialWaterReading, @HiveField(18)  DateTime? leftDate, @HiveField(19)  double monthlyRent)?  $default,) {final _that = this;
switch (_that) {
case _TenantModel() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.propertyId,_that.moveInDate,_that.leaseEndDate,_that.citizenshipNumber,_that.citizenshipImagePath,_that.createdAt,_that.updatedAt,_that.isActive,_that.electricityRate,_that.waterRate,_that.initialElectricityReading,_that.initialWaterReading,_that.leftDate,_that.monthlyRent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TenantModel extends TenantModel {
  const _TenantModel({@HiveField(0) required this.id, @HiveField(1) required this.name, @HiveField(2) required this.phone, @HiveField(4) required this.propertyId, @HiveField(5) required this.moveInDate, @HiveField(6) this.leaseEndDate, @HiveField(9) required this.citizenshipNumber, @HiveField(10) this.citizenshipImagePath, @HiveField(11) required this.createdAt, @HiveField(12) required this.updatedAt, @HiveField(13) required this.isActive, @HiveField(14) this.electricityRate = 0, @HiveField(15) this.waterRate = 0, @HiveField(16) this.initialElectricityReading = 0, @HiveField(17) this.initialWaterReading = 0, @HiveField(18) this.leftDate, @HiveField(19) this.monthlyRent = 0}): super._();
  factory _TenantModel.fromJson(Map<String, dynamic> json) => _$TenantModelFromJson(json);

@override@HiveField(0) final  String id;
@override@HiveField(1) final  String name;
@override@HiveField(2) final  String phone;
@override@HiveField(4) final  String propertyId;
@override@HiveField(5) final  DateTime moveInDate;
@override@HiveField(6) final  DateTime? leaseEndDate;
@override@HiveField(9) final  String citizenshipNumber;
@override@HiveField(10) final  String? citizenshipImagePath;
@override@HiveField(11) final  DateTime createdAt;
@override@HiveField(12) final  DateTime updatedAt;
@override@HiveField(13) final  bool isActive;
@override@JsonKey()@HiveField(14) final  double electricityRate;
@override@JsonKey()@HiveField(15) final  double waterRate;
@override@JsonKey()@HiveField(16) final  double initialElectricityReading;
@override@JsonKey()@HiveField(17) final  double initialWaterReading;
@override@HiveField(18) final  DateTime? leftDate;
@override@JsonKey()@HiveField(19) final  double monthlyRent;

/// Create a copy of TenantModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TenantModelCopyWith<_TenantModel> get copyWith => __$TenantModelCopyWithImpl<_TenantModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TenantModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TenantModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.propertyId, propertyId) || other.propertyId == propertyId)&&(identical(other.moveInDate, moveInDate) || other.moveInDate == moveInDate)&&(identical(other.leaseEndDate, leaseEndDate) || other.leaseEndDate == leaseEndDate)&&(identical(other.citizenshipNumber, citizenshipNumber) || other.citizenshipNumber == citizenshipNumber)&&(identical(other.citizenshipImagePath, citizenshipImagePath) || other.citizenshipImagePath == citizenshipImagePath)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.electricityRate, electricityRate) || other.electricityRate == electricityRate)&&(identical(other.waterRate, waterRate) || other.waterRate == waterRate)&&(identical(other.initialElectricityReading, initialElectricityReading) || other.initialElectricityReading == initialElectricityReading)&&(identical(other.initialWaterReading, initialWaterReading) || other.initialWaterReading == initialWaterReading)&&(identical(other.leftDate, leftDate) || other.leftDate == leftDate)&&(identical(other.monthlyRent, monthlyRent) || other.monthlyRent == monthlyRent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phone,propertyId,moveInDate,leaseEndDate,citizenshipNumber,citizenshipImagePath,createdAt,updatedAt,isActive,electricityRate,waterRate,initialElectricityReading,initialWaterReading,leftDate,monthlyRent);

@override
String toString() {
  return 'TenantModel(id: $id, name: $name, phone: $phone, propertyId: $propertyId, moveInDate: $moveInDate, leaseEndDate: $leaseEndDate, citizenshipNumber: $citizenshipNumber, citizenshipImagePath: $citizenshipImagePath, createdAt: $createdAt, updatedAt: $updatedAt, isActive: $isActive, electricityRate: $electricityRate, waterRate: $waterRate, initialElectricityReading: $initialElectricityReading, initialWaterReading: $initialWaterReading, leftDate: $leftDate, monthlyRent: $monthlyRent)';
}


}

/// @nodoc
abstract mixin class _$TenantModelCopyWith<$Res> implements $TenantModelCopyWith<$Res> {
  factory _$TenantModelCopyWith(_TenantModel value, $Res Function(_TenantModel) _then) = __$TenantModelCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) String id,@HiveField(1) String name,@HiveField(2) String phone,@HiveField(4) String propertyId,@HiveField(5) DateTime moveInDate,@HiveField(6) DateTime? leaseEndDate,@HiveField(9) String citizenshipNumber,@HiveField(10) String? citizenshipImagePath,@HiveField(11) DateTime createdAt,@HiveField(12) DateTime updatedAt,@HiveField(13) bool isActive,@HiveField(14) double electricityRate,@HiveField(15) double waterRate,@HiveField(16) double initialElectricityReading,@HiveField(17) double initialWaterReading,@HiveField(18) DateTime? leftDate,@HiveField(19) double monthlyRent
});




}
/// @nodoc
class __$TenantModelCopyWithImpl<$Res>
    implements _$TenantModelCopyWith<$Res> {
  __$TenantModelCopyWithImpl(this._self, this._then);

  final _TenantModel _self;
  final $Res Function(_TenantModel) _then;

/// Create a copy of TenantModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? phone = null,Object? propertyId = null,Object? moveInDate = null,Object? leaseEndDate = freezed,Object? citizenshipNumber = null,Object? citizenshipImagePath = freezed,Object? createdAt = null,Object? updatedAt = null,Object? isActive = null,Object? electricityRate = null,Object? waterRate = null,Object? initialElectricityReading = null,Object? initialWaterReading = null,Object? leftDate = freezed,Object? monthlyRent = null,}) {
  return _then(_TenantModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,propertyId: null == propertyId ? _self.propertyId : propertyId // ignore: cast_nullable_to_non_nullable
as String,moveInDate: null == moveInDate ? _self.moveInDate : moveInDate // ignore: cast_nullable_to_non_nullable
as DateTime,leaseEndDate: freezed == leaseEndDate ? _self.leaseEndDate : leaseEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,citizenshipNumber: null == citizenshipNumber ? _self.citizenshipNumber : citizenshipNumber // ignore: cast_nullable_to_non_nullable
as String,citizenshipImagePath: freezed == citizenshipImagePath ? _self.citizenshipImagePath : citizenshipImagePath // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,electricityRate: null == electricityRate ? _self.electricityRate : electricityRate // ignore: cast_nullable_to_non_nullable
as double,waterRate: null == waterRate ? _self.waterRate : waterRate // ignore: cast_nullable_to_non_nullable
as double,initialElectricityReading: null == initialElectricityReading ? _self.initialElectricityReading : initialElectricityReading // ignore: cast_nullable_to_non_nullable
as double,initialWaterReading: null == initialWaterReading ? _self.initialWaterReading : initialWaterReading // ignore: cast_nullable_to_non_nullable
as double,leftDate: freezed == leftDate ? _self.leftDate : leftDate // ignore: cast_nullable_to_non_nullable
as DateTime?,monthlyRent: null == monthlyRent ? _self.monthlyRent : monthlyRent // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
