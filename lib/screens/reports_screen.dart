import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rent_bill_maker/services/report_service.dart';
import 'package:rent_bill_maker/utils/constants.dart';
import 'package:rent_bill_maker/utils/l10n.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final ReportService _reportService = ReportService();
  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;
  Map<String, dynamic>? _monthlyReport;
  Map<String, dynamic>? _yearlyReport;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    final monthly = await _reportService.getMonthlyReport(
      _selectedMonth,
      _selectedYear,
    );
    final yearly = await _reportService.getYearlyReport(_selectedYear);
    setState(() {
      _monthlyReport = monthly;
      _yearlyReport = yearly;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _loadReports,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(l10n.get('report_title'), style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),

            // Month selector
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _selectedMonth,
                    decoration: InputDecoration(labelText: l10n.get('month')),
                    items: List.generate(12, (i) {
                      return DropdownMenuItem(
                        value: i + 1,
                        child: Text(
                          DateFormat('MMM').format(DateTime(2000, i + 1)),
                          style: const TextStyle(fontSize: 13),
                        ),
                      );
                    }),
                    onChanged: (v) async {
                      setState(() => _selectedMonth = v!);
                      await _loadReports();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _selectedYear,
                    decoration: InputDecoration(labelText: l10n.get('year')),
                    items: List.generate(5, (i) {
                      final year = DateTime.now().year - 2 + i;
                      return DropdownMenuItem(
                        value: year,
                        child: Text(
                          year.toString(),
                          style: const TextStyle(fontSize: 13),
                        ),
                      );
                    }),
                    onChanged: (v) async {
                      setState(() => _selectedYear = v!);
                      await _loadReports();
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Monthly report
            if (_monthlyReport != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${l10n.get('monthly_report')} - ${DateFormat('MMMM yyyy').format(DateTime(_selectedYear, _selectedMonth))}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _statRow(
                        l10n.get('total_bills'),
                        '${_monthlyReport!['totalBills']}',
                      ),
                      _statRow(
                        l10n.get('collected_rent'),
                        '${Constants.currency}${(_monthlyReport!['totalRentCollected'] as double).toStringAsFixed(0)}',
                      ),
                      _statRow(
                        l10n.get('pending_amount'),
                        '${Constants.currency}${(_monthlyReport!['totalPending'] as double).toStringAsFixed(0)}',
                        valueColor: Colors.orange,
                      ),
                      _statRow(
                        l10n.get('overdue_amount'),
                        '${Constants.currency}${(_monthlyReport!['totalOverdue'] as double).toStringAsFixed(0)}',
                        valueColor: Colors.red,
                      ),
                      const Divider(height: 16),
                      _statRow(
                        l10n.get('status_paid'),
                        '${_monthlyReport!['paidCount']}',
                        valueColor: Colors.green,
                      ),
                      _statRow(
                        l10n.get('status_pending'),
                        '${_monthlyReport!['pendingCount']}',
                      ),
                      _statRow(
                        l10n.get('collection_rate'),
                        '${(_monthlyReport!['collectionRate'] as double).toStringAsFixed(0)}%',
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Yearly report
            if (_yearlyReport != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${l10n.get('yearly_report')} - $_selectedYear',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _statRow(
                        l10n.get('total_collection'),
                        '${Constants.currency}${(_yearlyReport!['totalYearlyCollection'] as double).toStringAsFixed(0)}',
                      ),
                      _statRow(
                        l10n.get('total_bills'),
                        '${_yearlyReport!['totalBills']}',
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l10n.get('monthly_details'),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ...List.generate(12, (index) {
                        final month = index + 1;
                        final amount =
                            (_yearlyReport!['monthlyCollection'][month] ??
                                    0.0)
                                as double;
                        final count =
                            (_yearlyReport!['monthlyBills'][month] ?? 0) as int;
                        if (amount > 0 || count > 0) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat('MMM').format(
                                    DateTime(2000, month),
                                  ),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  '$count ${count == 1 ? l10n.get('bill_unit') : l10n.get('bills_unit')}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  '${Constants.currency}${amount.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 12,
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
              ),
            ],

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _statRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
