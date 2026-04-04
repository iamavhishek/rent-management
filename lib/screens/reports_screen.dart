import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:rent_bill_maker/bloc/reports/reports_cubit.dart';
import 'package:rent_bill_maker/bloc/settings/settings_cubit.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/utils/l10n.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late int _selectedYear;
  late int _selectedMonth;

  @override
  void initState() {
    super.initState();
    final bool isBS = context.read<SettingsCubit>().state == DateSystem.bs;
    if (isBS) {
      final NepaliDateTime now = NepaliDateTime.now();
      _selectedYear = now.year;
      _selectedMonth = now.month;
    } else {
      final DateTime now = DateTime.now();
      _selectedYear = now.year;
      _selectedMonth = now.month;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReports();
    });
  }

  void _loadReports() {
    if (!mounted) return;
    final DateSystem dateSystem = context.read<SettingsCubit>().state;
    context.read<ReportsCubit>().loadReports(
      _selectedMonth,
      _selectedYear,
      dateSystem,
    );
  }

  @override
  Widget build(BuildContext context) => BlocListener<SettingsCubit, DateSystem>(
    listener: (BuildContext context, DateSystem state) {
      final bool isBS = state == DateSystem.bs;
      if (isBS && _selectedYear < 2050) {
        final NepaliDateTime bsDate = DateTime(
          _selectedYear,
          _selectedMonth,
          15,
        ).toNepaliDateTime();
        _selectedYear = bsDate.year;
        _selectedMonth = bsDate.month;
      } else if (!isBS && _selectedYear > 2050) {
        final DateTime adDate = NepaliDateTime(
          _selectedYear,
          _selectedMonth,
          15,
        ).toDateTime();
        _selectedYear = adDate.year;
        _selectedMonth = adDate.month;
      }
      _loadReports();
    },
    child: BlocBuilder<SettingsCubit, DateSystem>(
      builder: (BuildContext context, DateSystem dateSystem) {
        final bool isBS = dateSystem == DateSystem.bs;
        final L10n l10n = L10n.of(context);
        return SafeArea(
          child: RefreshIndicator(
            onRefresh: () async => _loadReports(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              children: <Widget>[
                Text(
                  l10n.get('report_title'),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            key: ValueKey<String>('month_$isBS'),
                            initialValue: _selectedMonth,
                            decoration: InputDecoration(
                              labelText: l10n.get('month'),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: List<DropdownMenuItem<int>>.generate(12, (
                              int i,
                            ) {
                              final int month = i + 1;
                              return DropdownMenuItem<int>(
                                value: month,
                                child: Text(
                                  l10n.getMonthName(month, isBS: isBS),
                                ),
                              );
                            }),
                            onChanged: (int? v) {
                              if (v != null) {
                                setState(() => _selectedMonth = v);
                                _loadReports();
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            key: ValueKey<String>('year_$isBS'),
                            initialValue: _selectedYear,
                            decoration: InputDecoration(
                              labelText: l10n.get('year'),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: (() {
                              final List<int> years = List<int>.generate(5, (
                                int i,
                              ) {
                                final int currentYear = isBS
                                    ? NepaliDateTime.now().year
                                    : DateTime.now().year;
                                return currentYear - 2 + i;
                              });
                              if (!years.contains(_selectedYear)) {
                                years.add(_selectedYear);
                              }
                              final List<int> uniqueYears =
                                  years.toSet().toList()..sort();
                              return uniqueYears
                                  .map(
                                    (int year) => DropdownMenuItem<int>(
                                      value: year,
                                      child: Text(year.toString()),
                                    ),
                                  )
                                  .toList();
                            })(),
                            onChanged: (int? v) {
                              if (v != null) {
                                setState(() => _selectedYear = v);
                                _loadReports();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                BlocBuilder<ReportsCubit, ReportsState>(
                  builder: (BuildContext context, ReportsState state) {
                    if (state is! ReportsLoaded) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final Map<String, dynamic> monthlyReport =
                        state.monthlyReport;
                    final Map<String, dynamic> yearlyReport =
                        state.yearlyReport;
                    return Column(
                      children: <Widget>[
                        if (monthlyReport.isNotEmpty) ...<Widget>[
                          _CardWithTitle(
                            title:
                                '${l10n.get('monthly_report')} - ${l10n.getMonthName(_selectedMonth, isBS: isBS)} $_selectedYear',
                            child: Column(
                              children: <Widget>[
                                _statRow(
                                  l10n.get('total_bills'),
                                  '${monthlyReport['totalBills']}',
                                ),
                                _statRow(
                                  l10n.get('collected_rent'),
                                  '${l10n.get('currency')}${(monthlyReport['totalRentCollected'] as double).toStringAsFixed(0)}',
                                  valueColor: const Color(0xFF16A34A),
                                ),
                                _statRow(
                                  l10n.get('pending_amount'),
                                  '${l10n.get('currency')}${(monthlyReport['totalPending'] as double).toStringAsFixed(0)}',
                                  valueColor: const Color(0xFFF59E0B),
                                ),
                                _statRow(
                                  l10n.get('overdue_amount'),
                                  '${l10n.get('currency')}${(monthlyReport['totalOverdue'] as double).toStringAsFixed(0)}',
                                  valueColor: const Color(0xFFDC2626),
                                ),
                                const Divider(height: 20),
                                _statRow(
                                  l10n.get('status_paid'),
                                  '${monthlyReport['paidCount']}',
                                  valueColor: const Color(0xFF16A34A),
                                ),
                                _statRow(
                                  l10n.get('status_pending'),
                                  '${monthlyReport['pendingCount']}',
                                ),
                                _statRow(
                                  l10n.get('collection_rate'),
                                  '${(monthlyReport['collectionRate'] as double).toStringAsFixed(0)}%',
                                  valueColor: const Color(0xFF2563EB),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        if (yearlyReport.isNotEmpty) ...<Widget>[
                          _CardWithTitle(
                            title:
                                '${l10n.get('yearly_report')} - $_selectedYear',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _statRow(
                                  l10n.get('total_collection'),
                                  '${l10n.get('currency')}${(yearlyReport['totalYearlyCollection'] as double).toStringAsFixed(0)}',
                                  valueColor: const Color(0xFF16A34A),
                                ),
                                _statRow(
                                  l10n.get('total_bills'),
                                  '${yearlyReport['totalBills']}',
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  l10n.get('monthly_details'),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...List<Widget>.generate(12, (int index) {
                                  final int month = index + 1;
                                  final Map<int, double> monthlyCollection =
                                      yearlyReport['monthlyCollection']
                                          as Map<int, double>;
                                  final Map<int, int> monthlyBills =
                                      yearlyReport['monthlyBills']
                                          as Map<int, int>;
                                  final double amount =
                                      monthlyCollection[month] ?? 0.0;
                                  final int count = monthlyBills[month] ?? 0;
                                  if (amount > 0 || count > 0) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            l10n.getMonthName(
                                              month,
                                              isBS: isBS,
                                            ),
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Color(0xFF64748B),
                                            ),
                                          ),
                                          Text(
                                            '$count ${count == 1 ? l10n.get('bill_unit') : l10n.get('bills_unit')}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                          Text(
                                            '${l10n.get('currency')}${amount.toStringAsFixed(0)}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                }),
                              ],
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    ),
  );

  Widget _statRow(String label, String value, {Color? valueColor}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    ),
  );
}

class _CardWithTitle extends StatelessWidget {
  const _CardWithTitle({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    ),
  );
}
