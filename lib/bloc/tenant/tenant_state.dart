part of 'tenant_bloc.dart';

abstract class TenantState extends Equatable {
  const TenantState();

  @override
  List<Object?> get props => <Object?>[];
}

class TenantInitial extends TenantState {}

class TenantLoading extends TenantState {}

class TenantLoaded extends TenantState {
  const TenantLoaded({required this.tenants});
  final List<TenantModel> tenants;

  @override
  List<Object?> get props => <Object?>[tenants];
}

class TenantError extends TenantState {
  const TenantError({required this.message});
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
