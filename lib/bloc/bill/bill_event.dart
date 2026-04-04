part of 'bill_bloc.dart';

abstract class BillEvent extends Equatable {
  const BillEvent();

  @override
  List<Object?> get props => [];
}

class LoadBills extends BillEvent {}

class AddBill extends BillEvent {
  final BillModel bill;
  const AddBill(this.bill);

  @override
  List<Object?> get props => [bill];
}

class UpdateBill extends BillEvent {
  final BillModel bill;
  const UpdateBill(this.bill);

  @override
  List<Object?> get props => [bill];
}

class DeleteBill extends BillEvent {
  final String id;
  const DeleteBill(this.id);

  @override
  List<Object?> get props => [id];
}

class GetBillById extends BillEvent {
  final String id;
  const GetBillById(this.id);

  @override
  List<Object?> get props => [id];
}

class GetBillsByTenant extends BillEvent {
  final String tenantId;
  const GetBillsByTenant(this.tenantId);

  @override
  List<Object?> get props => [tenantId];
}

class GetBillsByProperty extends BillEvent {
  final String propertyId;
  const GetBillsByProperty(this.propertyId);

  @override
  List<Object?> get props => [propertyId];
}

class GetBillsByDateRange extends BillEvent {
  final DateTime startDate;
  final DateTime endDate;
  const GetBillsByDateRange(this.startDate, this.endDate);

  @override
  List<Object?> get props => [startDate, endDate];
}

class MarkBillAsPaid extends BillEvent {
  final String billId;
  final String paymentMode;
  const MarkBillAsPaid({
    required this.billId,
    required this.paymentMode,
  });

  @override
  List<Object?> get props => [billId, paymentMode];
}

class GetOverdueBills extends BillEvent {}

class GetPendingBills extends BillEvent {}