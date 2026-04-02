part of 'bill_bloc.dart';

abstract class BillState extends Equatable {
  const BillState();

  @override
  List<Object?> get props => [];
}

class BillInitial extends BillState {}

class BillLoading extends BillState {}

class BillLoaded extends BillState {
  final List<BillModel> bills;
  const BillLoaded({required this.bills});

  @override
  List<Object?> get props => [bills];
}

class BillError extends BillState {
  final String message;
  const BillError({required this.message});

  @override
  List<Object?> get props => [message];
}