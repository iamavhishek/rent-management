import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/repositories/bill_repository.dart';
import 'package:rent_bill_maker/services/report_service.dart';

part 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit({required BillRepository billRepository})
    : _reportService = ReportService(billRepository: billRepository),
      super(ReportsInitial());
  final ReportService _reportService;

  Future<void> loadReports(
    int month,
    int year,
    DateSystem dateSystem,
  ) async {
    emit(ReportsLoading());
    try {
      final Map<String, dynamic> monthly = await _reportService
          .getMonthlyReport(
            month,
            year,
            dateSystem,
          );
      final Map<String, dynamic> yearly = await _reportService.getYearlyReport(
        year,
        dateSystem,
      );
      emit(
        ReportsLoaded(
          monthlyReport: monthly,
          yearlyReport: yearly,
        ),
      );
    } catch (e) {
      emit(ReportsError('Failed to load reports: $e'));
    }
  }
}
