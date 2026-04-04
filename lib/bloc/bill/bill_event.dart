part of 'bill_bloc.dart';

abstract class BillEvent extends Equatable {
  const BillEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class LoadBills extends BillEvent {}

class AddBill extends BillEvent {
  const AddBill(this.bill);
  final BillModel bill;

  @override
  List<Object?> get props => <Object?>[bill];
}

class UpdateBill extends BillEvent {
  const UpdateBill(this.bill);
  final BillModel bill;

  @override
  List<Object?> get props => <Object?>[bill];
}

class DeleteBill extends BillEvent {
  const DeleteBill(this.id);
  final String id;

  @override
  List<Object?> get props => <Object?>[id];
}

class GetBillById extends BillEvent {
  const GetBillById(this.id);
  final String id;

  @override
  List<Object?> get props => <Object?>[id];
}

class GetBillsByTenant extends BillEvent {
  const GetBillsByTenant(this.tenantId);
  final String tenantId;

  @override
  List<Object?> get props => <Object?>[tenantId];
}

class GetBillsByProperty extends BillEvent {
  const GetBillsByProperty(this.propertyId);
  final String propertyId;

  @override
  List<Object?> get props => <Object?>[propertyId];
}

class GetBillsByDateRange extends BillEvent {
  const GetBillsByDateRange(this.startDate, this.endDate);
  final DateTime startDate;
  final DateTime endDate;

  @override
  List<Object?> get props => <Object?>[startDate, endDate];
}

class MarkBillAsPaid extends BillEvent {
  const MarkBillAsPaid({required this.billId, required this.paymentMode});
  final String billId;
  final String paymentMode;

  @override
  List<Object?> get props => <Object?>[billId, paymentMode];
}

class GetOverdueBills extends BillEvent {}

class GetPendingBills extends BillEvent {}

class MarkBillAsUnpaid extends BillEvent {
  const MarkBillAsUnpaid(this.billId);
  final String billId;

  @override
  List<Object?> get props => <Object?>[billId];
}
