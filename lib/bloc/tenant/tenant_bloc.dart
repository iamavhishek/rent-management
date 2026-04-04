import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_bill_maker/models/tenant/tenant_model.dart';
import 'package:rent_bill_maker/repositories/tenant_repository.dart';

part 'tenant_event.dart';
part 'tenant_state.dart';

class TenantBloc extends Bloc<TenantEvent, TenantState> {
  TenantBloc({required TenantRepository tenantRepository})
    : _tenantRepository = tenantRepository,
      super(TenantInitial()) {
    on<LoadTenants>(_onLoadTenants);
    on<AddTenant>(_onAddTenant);
    on<UpdateTenant>(_onUpdateTenant);
    on<DeleteTenant>(_onDeleteTenant);
    on<GetTenantById>(_onGetTenantById);
    on<GetTenantsByProperty>(_onGetTenantsByProperty);
  }
  final TenantRepository _tenantRepository;

  Future<void> _onLoadTenants(
    LoadTenants event,
    Emitter<TenantState> emit,
  ) async {
    emit(TenantLoading());
    try {
      final List<TenantModel> tenants = await _tenantRepository.getAll();
      emit(TenantLoaded(tenants: tenants));
    } catch (e) {
      emit(TenantError(message: 'Failed to load tenants: $e'));
    }
  }

  Future<void> _onAddTenant(AddTenant event, Emitter<TenantState> emit) async {
    emit(TenantLoading());
    try {
      await _tenantRepository.add(event.tenant);
      final List<TenantModel> tenants = await _tenantRepository.getAll();
      emit(TenantLoaded(tenants: tenants));
    } catch (e) {
      emit(TenantError(message: 'Failed to add tenant: $e'));
    }
  }

  Future<void> _onUpdateTenant(
    UpdateTenant event,
    Emitter<TenantState> emit,
  ) async {
    emit(TenantLoading());
    try {
      await _tenantRepository.update(event.tenant);
      final List<TenantModel> tenants = await _tenantRepository.getAll();
      emit(TenantLoaded(tenants: tenants));
    } catch (e) {
      emit(TenantError(message: 'Failed to update tenant: $e'));
    }
  }

  Future<void> _onDeleteTenant(
    DeleteTenant event,
    Emitter<TenantState> emit,
  ) async {
    emit(TenantLoading());
    try {
      await _tenantRepository.delete(event.id);
      final List<TenantModel> tenants = await _tenantRepository.getAll();
      emit(TenantLoaded(tenants: tenants));
    } catch (e) {
      emit(TenantError(message: 'Failed to delete tenant: $e'));
    }
  }

  Future<void> _onGetTenantById(
    GetTenantById event,
    Emitter<TenantState> emit,
  ) async {
    emit(TenantLoading());
    try {
      final TenantModel? tenant = await _tenantRepository.getById(event.id);
      if (tenant != null) {
        emit(TenantLoaded(tenants: <TenantModel>[tenant]));
      } else {
        emit(const TenantError(message: 'Tenant not found'));
      }
    } catch (e) {
      emit(TenantError(message: 'Failed to get tenant: $e'));
    }
  }

  Future<void> _onGetTenantsByProperty(
    GetTenantsByProperty event,
    Emitter<TenantState> emit,
  ) async {
    emit(TenantLoading());
    try {
      final List<TenantModel> tenants = await _tenantRepository.getByPropertyId(
        event.propertyId,
      );
      emit(TenantLoaded(tenants: tenants));
    } catch (e) {
      emit(TenantError(message: 'Failed to get tenants: $e'));
    }
  }
}
