part of 'tenant_bloc.dart';

abstract class TenantEvent extends Equatable {
  const TenantEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class LoadTenants extends TenantEvent {}

class AddTenant extends TenantEvent {
  const AddTenant(this.tenant);
  final TenantModel tenant;

  @override
  List<Object?> get props => <Object?>[tenant];
}

class UpdateTenant extends TenantEvent {
  const UpdateTenant(this.tenant);
  final TenantModel tenant;

  @override
  List<Object?> get props => <Object?>[tenant];
}

class DeleteTenant extends TenantEvent {
  const DeleteTenant(this.id);
  final String id;

  @override
  List<Object?> get props => <Object?>[id];
}

class GetTenantById extends TenantEvent {
  const GetTenantById(this.id);
  final String id;

  @override
  List<Object?> get props => <Object?>[id];
}

class GetTenantsByProperty extends TenantEvent {
  const GetTenantsByProperty(this.propertyId);
  final String propertyId;

  @override
  List<Object?> get props => <Object?>[propertyId];
}
