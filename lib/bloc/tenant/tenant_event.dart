part of 'tenant_bloc.dart';

abstract class TenantEvent extends Equatable {
  const TenantEvent();

  @override
  List<Object?> get props => [];
}

class LoadTenants extends TenantEvent {}

class AddTenant extends TenantEvent {
  final TenantModel tenant;
  const AddTenant(this.tenant);

  @override
  List<Object?> get props => [tenant];
}

class UpdateTenant extends TenantEvent {
  final TenantModel tenant;
  const UpdateTenant(this.tenant);

  @override
  List<Object?> get props => [tenant];
}

class DeleteTenant extends TenantEvent {
  final String id;
  const DeleteTenant(this.id);

  @override
  List<Object?> get props => [id];
}

class GetTenantById extends TenantEvent {
  final String id;
  const GetTenantById(this.id);

  @override
  List<Object?> get props => [id];
}

class GetTenantsByProperty extends TenantEvent {
  final String propertyId;
  const GetTenantsByProperty(this.propertyId);

  @override
  List<Object?> get props => [propertyId];
}