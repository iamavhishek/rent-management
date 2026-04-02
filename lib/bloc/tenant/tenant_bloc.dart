import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:rent_bill_maker/models/tenant/tenant_model.dart';
import 'package:rent_bill_maker/utils/constants.dart';

part 'tenant_event.dart';
part 'tenant_state.dart';

class TenantBloc extends Bloc<TenantEvent, TenantState> {
  late Box<TenantModel> tenantBox;

  TenantBloc() : super(TenantInitial()) {
    tenantBox = Hive.box<TenantModel>(Constants.tenantsBox);

    on<LoadTenants>(_onLoadTenants);
    on<AddTenant>(_onAddTenant);
    on<UpdateTenant>(_onUpdateTenant);
    on<DeleteTenant>(_onDeleteTenant);
    on<GetTenantById>(_onGetTenantById);
    on<GetTenantsByProperty>(_onGetTenantsByProperty);
  }

  Future<void> _onLoadTenants(
    LoadTenants event,
    Emitter<TenantState> emit,
  ) async {
    emit(TenantLoading());
    try {
      final tenants = tenantBox.values.toList();
      emit(TenantLoaded(tenants: tenants));
    } catch (e) {
      emit(TenantError(message: 'Failed to load tenants: $e'));
    }
  }

  Future<void> _onAddTenant(AddTenant event, Emitter<TenantState> emit) async {
    emit(TenantLoading());
    try {
      await tenantBox.put(event.tenant.id, event.tenant);
      final tenants = tenantBox.values.toList();
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
      await tenantBox.put(event.tenant.id, event.tenant);
      final tenants = tenantBox.values.toList();
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
      await tenantBox.delete(event.id);
      final tenants = tenantBox.values.toList();
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
      final tenant = tenantBox.get(event.id);
      if (tenant != null) {
        emit(TenantLoaded(tenants: [tenant]));
      } else {
        emit(TenantError(message: 'Tenant not found'));
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
      final tenants = tenantBox.values
          .where((tenant) => tenant.propertyId == event.propertyId)
          .toList();
      emit(TenantLoaded(tenants: tenants));
    } catch (e) {
      emit(TenantError(message: 'Failed to get tenants: $e'));
    }
  }
}
