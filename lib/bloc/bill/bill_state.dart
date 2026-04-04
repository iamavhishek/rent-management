part of 'bill_bloc.dart';

abstract class BillState extends Equatable {
  const BillState();

  @override
  List<Object?> get props => <Object?>[];
}

class BillInitial extends BillState {}

class BillLoading extends BillState {}

class BillLoaded extends BillState {
  const BillLoaded({required this.bills});
  final List<BillModel> bills;

  @override
  List<Object?> get props => <Object?>[bills];
}

class BillError extends BillState {
  const BillError({required this.message});
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
