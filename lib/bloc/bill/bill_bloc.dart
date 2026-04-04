import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/utils/constants.dart';

part 'bill_event.dart';
part 'bill_state.dart';

class BillBloc extends Bloc<BillEvent, BillState> {
  late Box<BillModel> billBox;

  BillBloc() : super(BillInitial()) {
    billBox = Hive.box<BillModel>(Constants.billsBox);

    on<LoadBills>(_onLoadBills);
    on<AddBill>(_onAddBill);
    on<UpdateBill>(_onUpdateBill);
    on<DeleteBill>(_onDeleteBill);
    on<GetBillById>(_onGetBillById);
    on<GetBillsByTenant>(_onGetBillsByTenant);
    on<GetBillsByProperty>(_onGetBillsByProperty);
    on<GetBillsByDateRange>(_onGetBillsByDateRange);
    on<MarkBillAsPaid>(_onMarkBillAsPaid);
    on<GetOverdueBills>(_onGetOverdueBills);
    on<GetPendingBills>(_onGetPendingBills);
  }

  Future<void> _onLoadBills(LoadBills event, Emitter<BillState> emit) async {
    emit(BillLoading());
    try {
      final bills = billBox.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(BillLoaded(bills: bills));
    } catch (e) {
      emit(BillError(message: 'Failed to load bills: $e'));
    }
  }

  Future<void> _onAddBill(AddBill event, Emitter<BillState> emit) async {
    emit(BillLoading());
    try {
      await billBox.put(event.bill.id, event.bill);
      final bills = billBox.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(BillLoaded(bills: bills));
    } catch (e) {
      emit(BillError(message: 'Failed to add bill: $e'));
    }
  }

  Future<void> _onUpdateBill(UpdateBill event, Emitter<BillState> emit) async {
    emit(BillLoading());
    try {
      await billBox.put(event.bill.id, event.bill);
      final bills = billBox.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(BillLoaded(bills: bills));
    } catch (e) {
      emit(BillError(message: 'Failed to update bill: $e'));
    }
  }

  Future<void> _onDeleteBill(DeleteBill event, Emitter<BillState> emit) async {
    emit(BillLoading());
    try {
      await billBox.delete(event.id);
      final bills = billBox.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(BillLoaded(bills: bills));
    } catch (e) {
      emit(BillError(message: 'Failed to delete bill: $e'));
    }
  }

  Future<void> _onGetBillById(
    GetBillById event,
    Emitter<BillState> emit,
  ) async {
    emit(BillLoading());
    try {
      final bill = billBox.get(event.id);
      if (bill != null) {
        emit(BillLoaded(bills: [bill]));
      } else {
        emit(BillError(message: 'Bill not found'));
      }
    } catch (e) {
      emit(BillError(message: 'Failed to get bill: $e'));
    }
  }

  Future<void> _onGetBillsByTenant(
    GetBillsByTenant event,
    Emitter<BillState> emit,
  ) async {
    emit(BillLoading());
    try {
      final bills =
          billBox.values
              .where((bill) => bill.tenantId == event.tenantId)
              .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(BillLoaded(bills: bills));
    } catch (e) {
      emit(BillError(message: 'Failed to get bills: $e'));
    }
  }

  Future<void> _onGetBillsByProperty(
    GetBillsByProperty event,
    Emitter<BillState> emit,
  ) async {
    emit(BillLoading());
    try {
      final bills =
          billBox.values
              .where((bill) => bill.propertyId == event.propertyId)
              .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(BillLoaded(bills: bills));
    } catch (e) {
      emit(BillError(message: 'Failed to get bills: $e'));
    }
  }

  Future<void> _onGetBillsByDateRange(
    GetBillsByDateRange event,
    Emitter<BillState> emit,
  ) async {
    emit(BillLoading());
    try {
      final bills =
          billBox.values
              .where(
                (bill) =>
                    bill.createdAt.isAfter(event.startDate) &&
                    bill.createdAt.isBefore(event.endDate),
              )
              .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(BillLoaded(bills: bills));
    } catch (e) {
      emit(BillError(message: 'Failed to get bills: $e'));
    }
  }

  Future<void> _onMarkBillAsPaid(
    MarkBillAsPaid event,
    Emitter<BillState> emit,
  ) async {
    emit(BillLoading());
    try {
      final bill = billBox.get(event.billId);
      if (bill != null) {
        final updatedBill = bill.copyWith(
          status: PaymentStatus.paid,
          paidAmount: bill.totalAmount,
          paidDate: DateTime.now(),
          paymentMode: event.paymentMode,
        );
        await billBox.put(updatedBill.id, updatedBill);

        final bills = billBox.values.toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        emit(BillLoaded(bills: bills));
      } else {
        emit(BillError(message: 'Bill not found'));
      }
    } catch (e) {
      emit(BillError(message: 'Failed to mark bill as paid: $e'));
    }
  }

  Future<void> _onGetOverdueBills(
    GetOverdueBills event,
    Emitter<BillState> emit,
  ) async {
    emit(BillLoading());
    try {
      final bills =
          billBox.values
              .where(
                (bill) => bill.isOverdue && bill.status != PaymentStatus.paid,
              )
              .toList()
            ..sort((a, b) => b.dueDate.compareTo(a.dueDate));
      emit(BillLoaded(bills: bills));
    } catch (e) {
      emit(BillError(message: 'Failed to get overdue bills: $e'));
    }
  }

  Future<void> _onGetPendingBills(
    GetPendingBills event,
    Emitter<BillState> emit,
  ) async {
    emit(BillLoading());
    try {
      final bills =
          billBox.values
              .where(
                (bill) =>
                    bill.status == PaymentStatus.pending ||
                    bill.status == PaymentStatus.partiallyPaid,
              )
              .toList()
            ..sort((a, b) => b.dueDate.compareTo(a.dueDate));
      emit(BillLoaded(bills: bills));
    } catch (e) {
      emit(BillError(message: 'Failed to get pending bills: $e'));
    }
  }
}
