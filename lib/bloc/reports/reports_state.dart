part of 'reports_cubit.dart';

abstract class ReportsState {}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class ReportsLoaded extends ReportsState {
  ReportsLoaded({required this.monthlyReport, required this.yearlyReport});
  final Map<String, dynamic> monthlyReport;
  final Map<String, dynamic> yearlyReport;
}

class ReportsError extends ReportsState {
  ReportsError(this.message);
  final String message;
}
