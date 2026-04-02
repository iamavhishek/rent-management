part of 'tenant_bloc.dart';

abstract class TenantState extends Equatable {
  const TenantState();

  @override
  List<Object?> get props => [];
}

class TenantInitial extends TenantState {}

class TenantLoading extends TenantState {}

class TenantLoaded extends TenantState {
  final List<TenantModel> tenants;
  const TenantLoaded({required this.tenants});

  @override
  List<Object?> get props => [tenants];
}

class TenantError extends TenantState {
  final String message;
  const TenantError({required this.message});

  @override
  List<Object?> get props => [message];
}