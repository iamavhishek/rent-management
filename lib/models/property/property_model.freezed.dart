// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'property_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PropertyModel {

@HiveField(0) String get id;@HiveField(1) String get name;@HiveField(2) String get address;@HiveField(3) String get unitNumber;@HiveField(4) double get monthlyRent;@HiveField(5) double get securityDeposit;@HiveField(6) String get ownerName;@HiveField(7) String get ownerPhone;@HiveField(13) DateTime get createdAt;@HiveField(14) DateTime get updatedAt;@HiveField(15) bool get isActive;
/// Create a copy of PropertyModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PropertyModelCopyWith<PropertyModel> get copyWith => _$PropertyModelCopyWithImpl<PropertyModel>(this as PropertyModel, _$identity);

  /// Serializes this PropertyModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PropertyModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.unitNumber, unitNumber) || other.unitNumber == unitNumber)&&(identical(other.monthlyRent, monthlyRent) || other.monthlyRent == monthlyRent)&&(identical(other.securityDeposit, securityDeposit) || other.securityDeposit == securityDeposit)&&(identical(other.ownerName, ownerName) || other.ownerName == ownerName)&&(identical(other.ownerPhone, ownerPhone) || other.ownerPhone == ownerPhone)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address,unitNumber,monthlyRent,securityDeposit,ownerName,ownerPhone,createdAt,updatedAt,isActive);

@override
String toString() {
  return 'PropertyModel(id: $id, name: $name, address: $address, unitNumber: $unitNumber, monthlyRent: $monthlyRent, securityDeposit: $securityDeposit, ownerName: $ownerName, ownerPhone: $ownerPhone, createdAt: $createdAt, updatedAt: $updatedAt, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $PropertyModelCopyWith<$Res>  {
  factory $PropertyModelCopyWith(PropertyModel value, $Res Function(PropertyModel) _then) = _$PropertyModelCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String id,@HiveField(1) String name,@HiveField(2) String address,@HiveField(3) String unitNumber,@HiveField(4) double monthlyRent,@HiveField(5) double securityDeposit,@HiveField(6) String ownerName,@HiveField(7) String ownerPhone,@HiveField(13) DateTime createdAt,@HiveField(14) DateTime updatedAt,@HiveField(15) bool isActive
});




}
/// @nodoc
class _$PropertyModelCopyWithImpl<$Res>
    implements $PropertyModelCopyWith<$Res> {
  _$PropertyModelCopyWithImpl(this._self, this._then);

  final PropertyModel _self;
  final $Res Function(PropertyModel) _then;

/// Create a copy of PropertyModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? address = null,Object? unitNumber = null,Object? monthlyRent = null,Object? securityDeposit = null,Object? ownerName = null,Object? ownerPhone = null,Object? createdAt = null,Object? updatedAt = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,unitNumber: null == unitNumber ? _self.unitNumber : unitNumber // ignore: cast_nullable_to_non_nullable
as String,monthlyRent: null == monthlyRent ? _self.monthlyRent : monthlyRent // ignore: cast_nullable_to_non_nullable
as double,securityDeposit: null == securityDeposit ? _self.securityDeposit : securityDeposit // ignore: cast_nullable_to_non_nullable
as double,ownerName: null == ownerName ? _self.ownerName : ownerName // ignore: cast_nullable_to_non_nullable
as String,ownerPhone: null == ownerPhone ? _self.ownerPhone : ownerPhone // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PropertyModel].
extension PropertyModelPatterns on PropertyModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PropertyModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PropertyModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PropertyModel value)  $default,){
final _that = this;
switch (_that) {
case _PropertyModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PropertyModel value)?  $default,){
final _that = this;
switch (_that) {
case _PropertyModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  String id, @HiveField(1)  String name, @HiveField(2)  String address, @HiveField(3)  String unitNumber, @HiveField(4)  double monthlyRent, @HiveField(5)  double securityDeposit, @HiveField(6)  String ownerName, @HiveField(7)  String ownerPhone, @HiveField(13)  DateTime createdAt, @HiveField(14)  DateTime updatedAt, @HiveField(15)  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PropertyModel() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.unitNumber,_that.monthlyRent,_that.securityDeposit,_that.ownerName,_that.ownerPhone,_that.createdAt,_that.updatedAt,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  String id, @HiveField(1)  String name, @HiveField(2)  String address, @HiveField(3)  String unitNumber, @HiveField(4)  double monthlyRent, @HiveField(5)  double securityDeposit, @HiveField(6)  String ownerName, @HiveField(7)  String ownerPhone, @HiveField(13)  DateTime createdAt, @HiveField(14)  DateTime updatedAt, @HiveField(15)  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _PropertyModel():
return $default(_that.id,_that.name,_that.address,_that.unitNumber,_that.monthlyRent,_that.securityDeposit,_that.ownerName,_that.ownerPhone,_that.createdAt,_that.updatedAt,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  String id, @HiveField(1)  String name, @HiveField(2)  String address, @HiveField(3)  String unitNumber, @HiveField(4)  double monthlyRent, @HiveField(5)  double securityDeposit, @HiveField(6)  String ownerName, @HiveField(7)  String ownerPhone, @HiveField(13)  DateTime createdAt, @HiveField(14)  DateTime updatedAt, @HiveField(15)  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _PropertyModel() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.unitNumber,_that.monthlyRent,_that.securityDeposit,_that.ownerName,_that.ownerPhone,_that.createdAt,_that.updatedAt,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PropertyModel extends PropertyModel {
  const _PropertyModel({@HiveField(0) required this.id, @HiveField(1) required this.name, @HiveField(2) required this.address, @HiveField(3) required this.unitNumber, @HiveField(4) required this.monthlyRent, @HiveField(5) required this.securityDeposit, @HiveField(6) required this.ownerName, @HiveField(7) required this.ownerPhone, @HiveField(13) required this.createdAt, @HiveField(14) required this.updatedAt, @HiveField(15) required this.isActive}): super._();
  factory _PropertyModel.fromJson(Map<String, dynamic> json) => _$PropertyModelFromJson(json);

@override@HiveField(0) final  String id;
@override@HiveField(1) final  String name;
@override@HiveField(2) final  String address;
@override@HiveField(3) final  String unitNumber;
@override@HiveField(4) final  double monthlyRent;
@override@HiveField(5) final  double securityDeposit;
@override@HiveField(6) final  String ownerName;
@override@HiveField(7) final  String ownerPhone;
@override@HiveField(13) final  DateTime createdAt;
@override@HiveField(14) final  DateTime updatedAt;
@override@HiveField(15) final  bool isActive;

/// Create a copy of PropertyModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PropertyModelCopyWith<_PropertyModel> get copyWith => __$PropertyModelCopyWithImpl<_PropertyModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PropertyModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PropertyModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.unitNumber, unitNumber) || other.unitNumber == unitNumber)&&(identical(other.monthlyRent, monthlyRent) || other.monthlyRent == monthlyRent)&&(identical(other.securityDeposit, securityDeposit) || other.securityDeposit == securityDeposit)&&(identical(other.ownerName, ownerName) || other.ownerName == ownerName)&&(identical(other.ownerPhone, ownerPhone) || other.ownerPhone == ownerPhone)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address,unitNumber,monthlyRent,securityDeposit,ownerName,ownerPhone,createdAt,updatedAt,isActive);

@override
String toString() {
  return 'PropertyModel(id: $id, name: $name, address: $address, unitNumber: $unitNumber, monthlyRent: $monthlyRent, securityDeposit: $securityDeposit, ownerName: $ownerName, ownerPhone: $ownerPhone, createdAt: $createdAt, updatedAt: $updatedAt, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$PropertyModelCopyWith<$Res> implements $PropertyModelCopyWith<$Res> {
  factory _$PropertyModelCopyWith(_PropertyModel value, $Res Function(_PropertyModel) _then) = __$PropertyModelCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) String id,@HiveField(1) String name,@HiveField(2) String address,@HiveField(3) String unitNumber,@HiveField(4) double monthlyRent,@HiveField(5) double securityDeposit,@HiveField(6) String ownerName,@HiveField(7) String ownerPhone,@HiveField(13) DateTime createdAt,@HiveField(14) DateTime updatedAt,@HiveField(15) bool isActive
});




}
/// @nodoc
class __$PropertyModelCopyWithImpl<$Res>
    implements _$PropertyModelCopyWith<$Res> {
  __$PropertyModelCopyWithImpl(this._self, this._then);

  final _PropertyModel _self;
  final $Res Function(_PropertyModel) _then;

/// Create a copy of PropertyModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? address = null,Object? unitNumber = null,Object? monthlyRent = null,Object? securityDeposit = null,Object? ownerName = null,Object? ownerPhone = null,Object? createdAt = null,Object? updatedAt = null,Object? isActive = null,}) {
  return _then(_PropertyModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,unitNumber: null == unitNumber ? _self.unitNumber : unitNumber // ignore: cast_nullable_to_non_nullable
as String,monthlyRent: null == monthlyRent ? _self.monthlyRent : monthlyRent // ignore: cast_nullable_to_non_nullable
as double,securityDeposit: null == securityDeposit ? _self.securityDeposit : securityDeposit // ignore: cast_nullable_to_non_nullable
as double,ownerName: null == ownerName ? _self.ownerName : ownerName // ignore: cast_nullable_to_non_nullable
as String,ownerPhone: null == ownerPhone ? _self.ownerPhone : ownerPhone // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
