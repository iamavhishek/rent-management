import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/repositories/bill_repository.dart';

part 'bill_event.dart';
part 'bill_state.dart';

class BillBloc extends Bloc<BillEvent, BillState> {
  BillBloc({required BillRepository billRepository})
    : _billRepository = billRepository,
      super(BillInitial()) {
    on<LoadBills>(_onLoadBills);
    on<AddBill>(_onAddBill);
    on<UpdateBill>(_onUpdateBill);
    on<DeleteBill>(_onDeleteBill);
    on<GetBillById>(_onGetBillById);
    on<GetBillsByTenant>(_onGetBillsByTenant);
    on<GetBillsByProperty>(_onGetBillsByProperty);
    on<GetBillsByDateRange>(_onGetBillsByDateRange);
    on<MarkBillAsPaid>(_onMarkBillAsPaid);
    on<MarkBillAsUnpaid>(_onMarkBillAsUnpaid);
    on<GetOverdueBills>(_onGetOverdueBills);
    on<GetPendingBills>(_onGetPendingBills);
  }
  final BillRepository _billRepository;

  Future<void> _onLoadBills(LoadBills event, Emitter<BillState> emit) async {
    emit(BillLoading());
    try {
      final List<BillModel> bills = await _billRepository.getAll();
      emit(BillLoaded(bills: bills));
    } catch (e) {
      emit(BillError(message: 'Failed to load bills: $e'));
    }
  }

  Future<void> _onAddBill(AddBill event, Emitter<BillState> emit) async {
    emit(BillLoading());
    try {
      await _billRepository.add(event.bill);
      final List<BillModel> bills = await _billRepository.getAll();
      emit(BillLoaded(bills: bills));
    } catch (e) {
      emit(BillError(message: 'Failed to add bill: $e'));
    }
  }

  Future<void> _onUpdateBill(UpdateBill event, Emitter<BillState> emit) async {
    emit(BillLoading());
    try {
      await _billRepository.update(event.bill);
      final List<BillModel> bills = await _billRepository.getAll();
      emit(BillLoaded(bills: bills));
    } catch (e) {
      emit(BillError(message: 'Failed to update bill: $e'));
    }
  }

  Future<void> _onDeleteBill(DeleteBill event, Emitter<BillState> emit) async {
    emit(BillLoading());
    try {
      await _billRepository.delete(event.id);
      final List<BillModel> bills = await _billRepository.getAll();
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
      final BillModel? bill = await _billRepository.getById(event.id);
      if (bill != null) {
        emit(BillLoaded(bills: <BillModel>[bill]));
      } else {
        emit(const BillError(message: 'Bill not found'));
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
      final List<BillModel> bills = await _billRepository.getByTenant(
        event.tenantId,
      );
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
      final List<BillModel> bills = await _billRepository.getByProperty(
        event.propertyId,
      );
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
      final List<BillModel> bills = await _billRepository.getByDateRange(
        event.startDate,
        event.endDate,
      );
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
      await _billRepository.markAsPaid(event.billId, event.paymentMode);
      final List<BillModel> bills = await _billRepository.getAll();
      emit(BillLoaded(bills: bills));
    } catch (e) {
      emit(BillError(message: 'Failed to mark bill as paid: $e'));
    }
  }

  Future<void> _onMarkBillAsUnpaid(
    MarkBillAsUnpaid event,
    Emitter<BillState> emit,
  ) async {
    emit(BillLoading());
    try {
      await _billRepository.markAsUnpaid(event.billId);
      final List<BillModel> bills = await _billRepository.getAll();
      emit(BillLoaded(bills: bills));
    } catch (e) {
      emit(BillError(message: 'Failed to mark bill as unpaid: $e'));
    }
  }

  Future<void> _onGetOverdueBills(
    GetOverdueBills event,
    Emitter<BillState> emit,
  ) async {
    emit(BillLoading());
    try {
      final List<BillModel> bills = await _billRepository.getOverdue();
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
      final List<BillModel> bills = await _billRepository.getPending();
      emit(BillLoaded(bills: bills));
    } catch (e) {
      emit(BillError(message: 'Failed to get pending bills: $e'));
    }
  }
}
