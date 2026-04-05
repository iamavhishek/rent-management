// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bill_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BillModel {

@HiveField(0) String get id;@HiveField(1) String get billNumber;@HiveField(2) String get tenantId;@HiveField(3) String get propertyId;@HiveField(4) int get month;@HiveField(5) int get year;@HiveField(6) double get rentAmount;@HiveField(7) double get electricityCharges;@HiveField(8) double get waterCharges;@HiveField(10) double get internetCharges;@HiveField(14) double get otherCharges;@HiveField(15) String get otherChargesDescription;@HiveField(16) double get discount;@HiveField(17) double get totalAmount;@HiveField(18) double get paidAmount;@HiveField(19) DateTime get dueDate;@HiveField(20) PaymentStatus get status;@HiveField(26) DateTime get createdAt;@HiveField(27) DateTime get updatedAt;@HiveField(21) DateTime? get paidDate;@HiveField(22) String? get paymentMode;@HiveField(24) String? get notes;@HiveField(25) String? get pdfPath;@HiveField(28) Map<String, double> get dynamicCharges;@HiveField(29) Map<String, double> get dynamicDeductions;@HiveField(31) double? get electricityUnits;@HiveField(32) double? get waterUnits;@HiveField(33) double? get previousElectricityReading;@HiveField(34) double? get currentElectricityReading;@HiveField(35) double? get previousWaterReading;@HiveField(36) double? get currentWaterReading;
/// Create a copy of BillModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BillModelCopyWith<BillModel> get copyWith => _$BillModelCopyWithImpl<BillModel>(this as BillModel, _$identity);

  /// Serializes this BillModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BillModel&&(identical(other.id, id) || other.id == id)&&(identical(other.billNumber, billNumber) || other.billNumber == billNumber)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.propertyId, propertyId) || other.propertyId == propertyId)&&(identical(other.month, month) || other.month == month)&&(identical(other.year, year) || other.year == year)&&(identical(other.rentAmount, rentAmount) || other.rentAmount == rentAmount)&&(identical(other.electricityCharges, electricityCharges) || other.electricityCharges == electricityCharges)&&(identical(other.waterCharges, waterCharges) || other.waterCharges == waterCharges)&&(identical(other.internetCharges, internetCharges) || other.internetCharges == internetCharges)&&(identical(other.otherCharges, otherCharges) || other.otherCharges == otherCharges)&&(identical(other.otherChargesDescription, otherChargesDescription) || other.otherChargesDescription == otherChargesDescription)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.paidDate, paidDate) || other.paidDate == paidDate)&&(identical(other.paymentMode, paymentMode) || other.paymentMode == paymentMode)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.pdfPath, pdfPath) || other.pdfPath == pdfPath)&&const DeepCollectionEquality().equals(other.dynamicCharges, dynamicCharges)&&const DeepCollectionEquality().equals(other.dynamicDeductions, dynamicDeductions)&&(identical(other.electricityUnits, electricityUnits) || other.electricityUnits == electricityUnits)&&(identical(other.waterUnits, waterUnits) || other.waterUnits == waterUnits)&&(identical(other.previousElectricityReading, previousElectricityReading) || other.previousElectricityReading == previousElectricityReading)&&(identical(other.currentElectricityReading, currentElectricityReading) || other.currentElectricityReading == currentElectricityReading)&&(identical(other.previousWaterReading, previousWaterReading) || other.previousWaterReading == previousWaterReading)&&(identical(other.currentWaterReading, currentWaterReading) || other.currentWaterReading == currentWaterReading));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,billNumber,tenantId,propertyId,month,year,rentAmount,electricityCharges,waterCharges,internetCharges,otherCharges,otherChargesDescription,discount,totalAmount,paidAmount,dueDate,status,createdAt,updatedAt,paidDate,paymentMode,notes,pdfPath,const DeepCollectionEquality().hash(dynamicCharges),const DeepCollectionEquality().hash(dynamicDeductions),electricityUnits,waterUnits,previousElectricityReading,currentElectricityReading,previousWaterReading,currentWaterReading]);

@override
String toString() {
  return 'BillModel(id: $id, billNumber: $billNumber, tenantId: $tenantId, propertyId: $propertyId, month: $month, year: $year, rentAmount: $rentAmount, electricityCharges: $electricityCharges, waterCharges: $waterCharges, internetCharges: $internetCharges, otherCharges: $otherCharges, otherChargesDescription: $otherChargesDescription, discount: $discount, totalAmount: $totalAmount, paidAmount: $paidAmount, dueDate: $dueDate, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, paidDate: $paidDate, paymentMode: $paymentMode, notes: $notes, pdfPath: $pdfPath, dynamicCharges: $dynamicCharges, dynamicDeductions: $dynamicDeductions, electricityUnits: $electricityUnits, waterUnits: $waterUnits, previousElectricityReading: $previousElectricityReading, currentElectricityReading: $currentElectricityReading, previousWaterReading: $previousWaterReading, currentWaterReading: $currentWaterReading)';
}


}

/// @nodoc
abstract mixin class $BillModelCopyWith<$Res>  {
  factory $BillModelCopyWith(BillModel value, $Res Function(BillModel) _then) = _$BillModelCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String id,@HiveField(1) String billNumber,@HiveField(2) String tenantId,@HiveField(3) String propertyId,@HiveField(4) int month,@HiveField(5) int year,@HiveField(6) double rentAmount,@HiveField(7) double electricityCharges,@HiveField(8) double waterCharges,@HiveField(10) double internetCharges,@HiveField(14) double otherCharges,@HiveField(15) String otherChargesDescription,@HiveField(16) double discount,@HiveField(17) double totalAmount,@HiveField(18) double paidAmount,@HiveField(19) DateTime dueDate,@HiveField(20) PaymentStatus status,@HiveField(26) DateTime createdAt,@HiveField(27) DateTime updatedAt,@HiveField(21) DateTime? paidDate,@HiveField(22) String? paymentMode,@HiveField(24) String? notes,@HiveField(25) String? pdfPath,@HiveField(28) Map<String, double> dynamicCharges,@HiveField(29) Map<String, double> dynamicDeductions,@HiveField(31) double? electricityUnits,@HiveField(32) double? waterUnits,@HiveField(33) double? previousElectricityReading,@HiveField(34) double? currentElectricityReading,@HiveField(35) double? previousWaterReading,@HiveField(36) double? currentWaterReading
});




}
/// @nodoc
class _$BillModelCopyWithImpl<$Res>
    implements $BillModelCopyWith<$Res> {
  _$BillModelCopyWithImpl(this._self, this._then);

  final BillModel _self;
  final $Res Function(BillModel) _then;

/// Create a copy of BillModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? billNumber = null,Object? tenantId = null,Object? propertyId = null,Object? month = null,Object? year = null,Object? rentAmount = null,Object? electricityCharges = null,Object? waterCharges = null,Object? internetCharges = null,Object? otherCharges = null,Object? otherChargesDescription = null,Object? discount = null,Object? totalAmount = null,Object? paidAmount = null,Object? dueDate = null,Object? status = null,Object? createdAt = null,Object? updatedAt = null,Object? paidDate = freezed,Object? paymentMode = freezed,Object? notes = freezed,Object? pdfPath = freezed,Object? dynamicCharges = null,Object? dynamicDeductions = null,Object? electricityUnits = freezed,Object? waterUnits = freezed,Object? previousElectricityReading = freezed,Object? currentElectricityReading = freezed,Object? previousWaterReading = freezed,Object? currentWaterReading = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,billNumber: null == billNumber ? _self.billNumber : billNumber // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,propertyId: null == propertyId ? _self.propertyId : propertyId // ignore: cast_nullable_to_non_nullable
as String,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,rentAmount: null == rentAmount ? _self.rentAmount : rentAmount // ignore: cast_nullable_to_non_nullable
as double,electricityCharges: null == electricityCharges ? _self.electricityCharges : electricityCharges // ignore: cast_nullable_to_non_nullable
as double,waterCharges: null == waterCharges ? _self.waterCharges : waterCharges // ignore: cast_nullable_to_non_nullable
as double,internetCharges: null == internetCharges ? _self.internetCharges : internetCharges // ignore: cast_nullable_to_non_nullable
as double,otherCharges: null == otherCharges ? _self.otherCharges : otherCharges // ignore: cast_nullable_to_non_nullable
as double,otherChargesDescription: null == otherChargesDescription ? _self.otherChargesDescription : otherChargesDescription // ignore: cast_nullable_to_non_nullable
as String,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,paidAmount: null == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as double,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,paidDate: freezed == paidDate ? _self.paidDate : paidDate // ignore: cast_nullable_to_non_nullable
as DateTime?,paymentMode: freezed == paymentMode ? _self.paymentMode : paymentMode // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,pdfPath: freezed == pdfPath ? _self.pdfPath : pdfPath // ignore: cast_nullable_to_non_nullable
as String?,dynamicCharges: null == dynamicCharges ? _self.dynamicCharges : dynamicCharges // ignore: cast_nullable_to_non_nullable
as Map<String, double>,dynamicDeductions: null == dynamicDeductions ? _self.dynamicDeductions : dynamicDeductions // ignore: cast_nullable_to_non_nullable
as Map<String, double>,electricityUnits: freezed == electricityUnits ? _self.electricityUnits : electricityUnits // ignore: cast_nullable_to_non_nullable
as double?,waterUnits: freezed == waterUnits ? _self.waterUnits : waterUnits // ignore: cast_nullable_to_non_nullable
as double?,previousElectricityReading: freezed == previousElectricityReading ? _self.previousElectricityReading : previousElectricityReading // ignore: cast_nullable_to_non_nullable
as double?,currentElectricityReading: freezed == currentElectricityReading ? _self.currentElectricityReading : currentElectricityReading // ignore: cast_nullable_to_non_nullable
as double?,previousWaterReading: freezed == previousWaterReading ? _self.previousWaterReading : previousWaterReading // ignore: cast_nullable_to_non_nullable
as double?,currentWaterReading: freezed == currentWaterReading ? _self.currentWaterReading : currentWaterReading // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [BillModel].
extension BillModelPatterns on BillModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BillModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BillModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BillModel value)  $default,){
final _that = this;
switch (_that) {
case _BillModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BillModel value)?  $default,){
final _that = this;
switch (_that) {
case _BillModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  String id, @HiveField(1)  String billNumber, @HiveField(2)  String tenantId, @HiveField(3)  String propertyId, @HiveField(4)  int month, @HiveField(5)  int year, @HiveField(6)  double rentAmount, @HiveField(7)  double electricityCharges, @HiveField(8)  double waterCharges, @HiveField(10)  double internetCharges, @HiveField(14)  double otherCharges, @HiveField(15)  String otherChargesDescription, @HiveField(16)  double discount, @HiveField(17)  double totalAmount, @HiveField(18)  double paidAmount, @HiveField(19)  DateTime dueDate, @HiveField(20)  PaymentStatus status, @HiveField(26)  DateTime createdAt, @HiveField(27)  DateTime updatedAt, @HiveField(21)  DateTime? paidDate, @HiveField(22)  String? paymentMode, @HiveField(24)  String? notes, @HiveField(25)  String? pdfPath, @HiveField(28)  Map<String, double> dynamicCharges, @HiveField(29)  Map<String, double> dynamicDeductions, @HiveField(31)  double? electricityUnits, @HiveField(32)  double? waterUnits, @HiveField(33)  double? previousElectricityReading, @HiveField(34)  double? currentElectricityReading, @HiveField(35)  double? previousWaterReading, @HiveField(36)  double? currentWaterReading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BillModel() when $default != null:
return $default(_that.id,_that.billNumber,_that.tenantId,_that.propertyId,_that.month,_that.year,_that.rentAmount,_that.electricityCharges,_that.waterCharges,_that.internetCharges,_that.otherCharges,_that.otherChargesDescription,_that.discount,_that.totalAmount,_that.paidAmount,_that.dueDate,_that.status,_that.createdAt,_that.updatedAt,_that.paidDate,_that.paymentMode,_that.notes,_that.pdfPath,_that.dynamicCharges,_that.dynamicDeductions,_that.electricityUnits,_that.waterUnits,_that.previousElectricityReading,_that.currentElectricityReading,_that.previousWaterReading,_that.currentWaterReading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  String id, @HiveField(1)  String billNumber, @HiveField(2)  String tenantId, @HiveField(3)  String propertyId, @HiveField(4)  int month, @HiveField(5)  int year, @HiveField(6)  double rentAmount, @HiveField(7)  double electricityCharges, @HiveField(8)  double waterCharges, @HiveField(10)  double internetCharges, @HiveField(14)  double otherCharges, @HiveField(15)  String otherChargesDescription, @HiveField(16)  double discount, @HiveField(17)  double totalAmount, @HiveField(18)  double paidAmount, @HiveField(19)  DateTime dueDate, @HiveField(20)  PaymentStatus status, @HiveField(26)  DateTime createdAt, @HiveField(27)  DateTime updatedAt, @HiveField(21)  DateTime? paidDate, @HiveField(22)  String? paymentMode, @HiveField(24)  String? notes, @HiveField(25)  String? pdfPath, @HiveField(28)  Map<String, double> dynamicCharges, @HiveField(29)  Map<String, double> dynamicDeductions, @HiveField(31)  double? electricityUnits, @HiveField(32)  double? waterUnits, @HiveField(33)  double? previousElectricityReading, @HiveField(34)  double? currentElectricityReading, @HiveField(35)  double? previousWaterReading, @HiveField(36)  double? currentWaterReading)  $default,) {final _that = this;
switch (_that) {
case _BillModel():
return $default(_that.id,_that.billNumber,_that.tenantId,_that.propertyId,_that.month,_that.year,_that.rentAmount,_that.electricityCharges,_that.waterCharges,_that.internetCharges,_that.otherCharges,_that.otherChargesDescription,_that.discount,_that.totalAmount,_that.paidAmount,_that.dueDate,_that.status,_that.createdAt,_that.updatedAt,_that.paidDate,_that.paymentMode,_that.notes,_that.pdfPath,_that.dynamicCharges,_that.dynamicDeductions,_that.electricityUnits,_that.waterUnits,_that.previousElectricityReading,_that.currentElectricityReading,_that.previousWaterReading,_that.currentWaterReading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  String id, @HiveField(1)  String billNumber, @HiveField(2)  String tenantId, @HiveField(3)  String propertyId, @HiveField(4)  int month, @HiveField(5)  int year, @HiveField(6)  double rentAmount, @HiveField(7)  double electricityCharges, @HiveField(8)  double waterCharges, @HiveField(10)  double internetCharges, @HiveField(14)  double otherCharges, @HiveField(15)  String otherChargesDescription, @HiveField(16)  double discount, @HiveField(17)  double totalAmount, @HiveField(18)  double paidAmount, @HiveField(19)  DateTime dueDate, @HiveField(20)  PaymentStatus status, @HiveField(26)  DateTime createdAt, @HiveField(27)  DateTime updatedAt, @HiveField(21)  DateTime? paidDate, @HiveField(22)  String? paymentMode, @HiveField(24)  String? notes, @HiveField(25)  String? pdfPath, @HiveField(28)  Map<String, double> dynamicCharges, @HiveField(29)  Map<String, double> dynamicDeductions, @HiveField(31)  double? electricityUnits, @HiveField(32)  double? waterUnits, @HiveField(33)  double? previousElectricityReading, @HiveField(34)  double? currentElectricityReading, @HiveField(35)  double? previousWaterReading, @HiveField(36)  double? currentWaterReading)?  $default,) {final _that = this;
switch (_that) {
case _BillModel() when $default != null:
return $default(_that.id,_that.billNumber,_that.tenantId,_that.propertyId,_that.month,_that.year,_that.rentAmount,_that.electricityCharges,_that.waterCharges,_that.internetCharges,_that.otherCharges,_that.otherChargesDescription,_that.discount,_that.totalAmount,_that.paidAmount,_that.dueDate,_that.status,_that.createdAt,_that.updatedAt,_that.paidDate,_that.paymentMode,_that.notes,_that.pdfPath,_that.dynamicCharges,_that.dynamicDeductions,_that.electricityUnits,_that.waterUnits,_that.previousElectricityReading,_that.currentElectricityReading,_that.previousWaterReading,_that.currentWaterReading);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BillModel extends BillModel {
  const _BillModel({@HiveField(0) required this.id, @HiveField(1) required this.billNumber, @HiveField(2) required this.tenantId, @HiveField(3) required this.propertyId, @HiveField(4) required this.month, @HiveField(5) required this.year, @HiveField(6) required this.rentAmount, @HiveField(7) required this.electricityCharges, @HiveField(8) required this.waterCharges, @HiveField(10) required this.internetCharges, @HiveField(14) required this.otherCharges, @HiveField(15) required this.otherChargesDescription, @HiveField(16) required this.discount, @HiveField(17) required this.totalAmount, @HiveField(18) required this.paidAmount, @HiveField(19) required this.dueDate, @HiveField(20) required this.status, @HiveField(26) required this.createdAt, @HiveField(27) required this.updatedAt, @HiveField(21) this.paidDate, @HiveField(22) this.paymentMode, @HiveField(24) this.notes, @HiveField(25) this.pdfPath, @HiveField(28) final  Map<String, double> dynamicCharges = const <String, double>{}, @HiveField(29) final  Map<String, double> dynamicDeductions = const <String, double>{}, @HiveField(31) this.electricityUnits, @HiveField(32) this.waterUnits, @HiveField(33) this.previousElectricityReading, @HiveField(34) this.currentElectricityReading, @HiveField(35) this.previousWaterReading, @HiveField(36) this.currentWaterReading}): _dynamicCharges = dynamicCharges,_dynamicDeductions = dynamicDeductions,super._();
  factory _BillModel.fromJson(Map<String, dynamic> json) => _$BillModelFromJson(json);

@override@HiveField(0) final  String id;
@override@HiveField(1) final  String billNumber;
@override@HiveField(2) final  String tenantId;
@override@HiveField(3) final  String propertyId;
@override@HiveField(4) final  int month;
@override@HiveField(5) final  int year;
@override@HiveField(6) final  double rentAmount;
@override@HiveField(7) final  double electricityCharges;
@override@HiveField(8) final  double waterCharges;
@override@HiveField(10) final  double internetCharges;
@override@HiveField(14) final  double otherCharges;
@override@HiveField(15) final  String otherChargesDescription;
@override@HiveField(16) final  double discount;
@override@HiveField(17) final  double totalAmount;
@override@HiveField(18) final  double paidAmount;
@override@HiveField(19) final  DateTime dueDate;
@override@HiveField(20) final  PaymentStatus status;
@override@HiveField(26) final  DateTime createdAt;
@override@HiveField(27) final  DateTime updatedAt;
@override@HiveField(21) final  DateTime? paidDate;
@override@HiveField(22) final  String? paymentMode;
@override@HiveField(24) final  String? notes;
@override@HiveField(25) final  String? pdfPath;
 final  Map<String, double> _dynamicCharges;
@override@JsonKey()@HiveField(28) Map<String, double> get dynamicCharges {
  if (_dynamicCharges is EqualUnmodifiableMapView) return _dynamicCharges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_dynamicCharges);
}

 final  Map<String, double> _dynamicDeductions;
@override@JsonKey()@HiveField(29) Map<String, double> get dynamicDeductions {
  if (_dynamicDeductions is EqualUnmodifiableMapView) return _dynamicDeductions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_dynamicDeductions);
}

@override@HiveField(31) final  double? electricityUnits;
@override@HiveField(32) final  double? waterUnits;
@override@HiveField(33) final  double? previousElectricityReading;
@override@HiveField(34) final  double? currentElectricityReading;
@override@HiveField(35) final  double? previousWaterReading;
@override@HiveField(36) final  double? currentWaterReading;

/// Create a copy of BillModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BillModelCopyWith<_BillModel> get copyWith => __$BillModelCopyWithImpl<_BillModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BillModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BillModel&&(identical(other.id, id) || other.id == id)&&(identical(other.billNumber, billNumber) || other.billNumber == billNumber)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.propertyId, propertyId) || other.propertyId == propertyId)&&(identical(other.month, month) || other.month == month)&&(identical(other.year, year) || other.year == year)&&(identical(other.rentAmount, rentAmount) || other.rentAmount == rentAmount)&&(identical(other.electricityCharges, electricityCharges) || other.electricityCharges == electricityCharges)&&(identical(other.waterCharges, waterCharges) || other.waterCharges == waterCharges)&&(identical(other.internetCharges, internetCharges) || other.internetCharges == internetCharges)&&(identical(other.otherCharges, otherCharges) || other.otherCharges == otherCharges)&&(identical(other.otherChargesDescription, otherChargesDescription) || other.otherChargesDescription == otherChargesDescription)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.paidDate, paidDate) || other.paidDate == paidDate)&&(identical(other.paymentMode, paymentMode) || other.paymentMode == paymentMode)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.pdfPath, pdfPath) || other.pdfPath == pdfPath)&&const DeepCollectionEquality().equals(other._dynamicCharges, _dynamicCharges)&&const DeepCollectionEquality().equals(other._dynamicDeductions, _dynamicDeductions)&&(identical(other.electricityUnits, electricityUnits) || other.electricityUnits == electricityUnits)&&(identical(other.waterUnits, waterUnits) || other.waterUnits == waterUnits)&&(identical(other.previousElectricityReading, previousElectricityReading) || other.previousElectricityReading == previousElectricityReading)&&(identical(other.currentElectricityReading, currentElectricityReading) || other.currentElectricityReading == currentElectricityReading)&&(identical(other.previousWaterReading, previousWaterReading) || other.previousWaterReading == previousWaterReading)&&(identical(other.currentWaterReading, currentWaterReading) || other.currentWaterReading == currentWaterReading));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,billNumber,tenantId,propertyId,month,year,rentAmount,electricityCharges,waterCharges,internetCharges,otherCharges,otherChargesDescription,discount,totalAmount,paidAmount,dueDate,status,createdAt,updatedAt,paidDate,paymentMode,notes,pdfPath,const DeepCollectionEquality().hash(_dynamicCharges),const DeepCollectionEquality().hash(_dynamicDeductions),electricityUnits,waterUnits,previousElectricityReading,currentElectricityReading,previousWaterReading,currentWaterReading]);

@override
String toString() {
  return 'BillModel(id: $id, billNumber: $billNumber, tenantId: $tenantId, propertyId: $propertyId, month: $month, year: $year, rentAmount: $rentAmount, electricityCharges: $electricityCharges, waterCharges: $waterCharges, internetCharges: $internetCharges, otherCharges: $otherCharges, otherChargesDescription: $otherChargesDescription, discount: $discount, totalAmount: $totalAmount, paidAmount: $paidAmount, dueDate: $dueDate, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, paidDate: $paidDate, paymentMode: $paymentMode, notes: $notes, pdfPath: $pdfPath, dynamicCharges: $dynamicCharges, dynamicDeductions: $dynamicDeductions, electricityUnits: $electricityUnits, waterUnits: $waterUnits, previousElectricityReading: $previousElectricityReading, currentElectricityReading: $currentElectricityReading, previousWaterReading: $previousWaterReading, currentWaterReading: $currentWaterReading)';
}


}

/// @nodoc
abstract mixin class _$BillModelCopyWith<$Res> implements $BillModelCopyWith<$Res> {
  factory _$BillModelCopyWith(_BillModel value, $Res Function(_BillModel) _then) = __$BillModelCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) String id,@HiveField(1) String billNumber,@HiveField(2) String tenantId,@HiveField(3) String propertyId,@HiveField(4) int month,@HiveField(5) int year,@HiveField(6) double rentAmount,@HiveField(7) double electricityCharges,@HiveField(8) double waterCharges,@HiveField(10) double internetCharges,@HiveField(14) double otherCharges,@HiveField(15) String otherChargesDescription,@HiveField(16) double discount,@HiveField(17) double totalAmount,@HiveField(18) double paidAmount,@HiveField(19) DateTime dueDate,@HiveField(20) PaymentStatus status,@HiveField(26) DateTime createdAt,@HiveField(27) DateTime updatedAt,@HiveField(21) DateTime? paidDate,@HiveField(22) String? paymentMode,@HiveField(24) String? notes,@HiveField(25) String? pdfPath,@HiveField(28) Map<String, double> dynamicCharges,@HiveField(29) Map<String, double> dynamicDeductions,@HiveField(31) double? electricityUnits,@HiveField(32) double? waterUnits,@HiveField(33) double? previousElectricityReading,@HiveField(34) double? currentElectricityReading,@HiveField(35) double? previousWaterReading,@HiveField(36) double? currentWaterReading
});




}
/// @nodoc
class __$BillModelCopyWithImpl<$Res>
    implements _$BillModelCopyWith<$Res> {
  __$BillModelCopyWithImpl(this._self, this._then);

  final _BillModel _self;
  final $Res Function(_BillModel) _then;

/// Create a copy of BillModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? billNumber = null,Object? tenantId = null,Object? propertyId = null,Object? month = null,Object? year = null,Object? rentAmount = null,Object? electricityCharges = null,Object? waterCharges = null,Object? internetCharges = null,Object? otherCharges = null,Object? otherChargesDescription = null,Object? discount = null,Object? totalAmount = null,Object? paidAmount = null,Object? dueDate = null,Object? status = null,Object? createdAt = null,Object? updatedAt = null,Object? paidDate = freezed,Object? paymentMode = freezed,Object? notes = freezed,Object? pdfPath = freezed,Object? dynamicCharges = null,Object? dynamicDeductions = null,Object? electricityUnits = freezed,Object? waterUnits = freezed,Object? previousElectricityReading = freezed,Object? currentElectricityReading = freezed,Object? previousWaterReading = freezed,Object? currentWaterReading = freezed,}) {
  return _then(_BillModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,billNumber: null == billNumber ? _self.billNumber : billNumber // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,propertyId: null == propertyId ? _self.propertyId : propertyId // ignore: cast_nullable_to_non_nullable
as String,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,rentAmount: null == rentAmount ? _self.rentAmount : rentAmount // ignore: cast_nullable_to_non_nullable
as double,electricityCharges: null == electricityCharges ? _self.electricityCharges : electricityCharges // ignore: cast_nullable_to_non_nullable
as double,waterCharges: null == waterCharges ? _self.waterCharges : waterCharges // ignore: cast_nullable_to_non_nullable
as double,internetCharges: null == internetCharges ? _self.internetCharges : internetCharges // ignore: cast_nullable_to_non_nullable
as double,otherCharges: null == otherCharges ? _self.otherCharges : otherCharges // ignore: cast_nullable_to_non_nullable
as double,otherChargesDescription: null == otherChargesDescription ? _self.otherChargesDescription : otherChargesDescription // ignore: cast_nullable_to_non_nullable
as String,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,paidAmount: null == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as double,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,paidDate: freezed == paidDate ? _self.paidDate : paidDate // ignore: cast_nullable_to_non_nullable
as DateTime?,paymentMode: freezed == paymentMode ? _self.paymentMode : paymentMode // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,pdfPath: freezed == pdfPath ? _self.pdfPath : pdfPath // ignore: cast_nullable_to_non_nullable
as String?,dynamicCharges: null == dynamicCharges ? _self._dynamicCharges : dynamicCharges // ignore: cast_nullable_to_non_nullable
as Map<String, double>,dynamicDeductions: null == dynamicDeductions ? _self._dynamicDeductions : dynamicDeductions // ignore: cast_nullable_to_non_nullable
as Map<String, double>,electricityUnits: freezed == electricityUnits ? _self.electricityUnits : electricityUnits // ignore: cast_nullable_to_non_nullable
as double?,waterUnits: freezed == waterUnits ? _self.waterUnits : waterUnits // ignore: cast_nullable_to_non_nullable
as double?,previousElectricityReading: freezed == previousElectricityReading ? _self.previousElectricityReading : previousElectricityReading // ignore: cast_nullable_to_non_nullable
as double?,currentElectricityReading: freezed == currentElectricityReading ? _self.currentElectricityReading : currentElectricityReading // ignore: cast_nullable_to_non_nullable
as double?,previousWaterReading: freezed == previousWaterReading ? _self.previousWaterReading : previousWaterReading // ignore: cast_nullable_to_non_nullable
as double?,currentWaterReading: freezed == currentWaterReading ? _self.currentWaterReading : currentWaterReading // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
