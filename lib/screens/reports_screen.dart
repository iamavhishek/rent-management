import 'package:flutter/material.dart';
import 'package:rent_bill_maker/services/report_service.dart';
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
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            Text(
              l10n.get('report_title'),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),

            // Month/Year selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
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
                        items: List.generate(12, (i) {
                          return DropdownMenuItem(
                            value: i + 1,
                            child: Text(
                              l10n.getMonthName(i + 1),
                            ),
                          );
                        }),
                        onChanged: (v) async {
                          setState(() => _selectedMonth = v!);
                          await _loadReports();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<int>(
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
                        items: List.generate(5, (i) {
                          final year = DateTime.now().year - 2 + i;
                          return DropdownMenuItem(
                            value: year,
                            child: Text(year.toString()),
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
              ),
            ),

            const SizedBox(height: 20),

            // Monthly report
            if (_monthlyReport != null) ...[
              _CardWithTitle(
                title:
                    '${l10n.get('monthly_report')} - ${l10n.getMonthName(_selectedMonth)} $_selectedYear',
                child: Column(
                  children: [
                    _statRow(
                      l10n.get('total_bills'),
                      '${_monthlyReport!['totalBills']}',
                    ),
                    _statRow(
                      l10n.get('collected_rent'),
                      '${l10n.get('currency')}${(_monthlyReport!['totalRentCollected'] as double).toStringAsFixed(0)}',
                      valueColor: const Color(0xFF16A34A),
                    ),
                    _statRow(
                      l10n.get('pending_amount'),
                      '${l10n.get('currency')}${(_monthlyReport!['totalPending'] as double).toStringAsFixed(0)}',
                      valueColor: const Color(0xFFF59E0B),
                    ),
                    _statRow(
                      l10n.get('overdue_amount'),
                      '${l10n.get('currency')}${(_monthlyReport!['totalOverdue'] as double).toStringAsFixed(0)}',
                      valueColor: const Color(0xFFDC2626),
                    ),
                    const Divider(height: 20),
                    _statRow(
                      l10n.get('status_paid'),
                      '${_monthlyReport!['paidCount']}',
                      valueColor: const Color(0xFF16A34A),
                    ),
                    _statRow(
                      l10n.get('status_pending'),
                      '${_monthlyReport!['pendingCount']}',
                    ),
                    _statRow(
                      l10n.get('collection_rate'),
                      '${(_monthlyReport!['collectionRate'] as double).toStringAsFixed(0)}%',
                      valueColor: const Color(0xFF2563EB),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 12),

            // Yearly report
            if (_yearlyReport != null) ...[
              _CardWithTitle(
                title: '${l10n.get('yearly_report')} - $_selectedYear',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _statRow(
                      l10n.get('total_collection'),
                      '${l10n.get('currency')}${(_yearlyReport!['totalYearlyCollection'] as double).toStringAsFixed(0)}',
                      valueColor: const Color(0xFF16A34A),
                    ),
                    _statRow(
                      l10n.get('total_bills'),
                      '${_yearlyReport!['totalBills']}',
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
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.getMonthName(month),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              Text(
                                '$count ${count == 1 ? l10n.get('bill_unit') : l10n.get('bills_unit')}',
                                style: const TextStyle(fontSize: 13),
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
        ),
      ),
    );
  }

  Widget _statRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
            ),
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
}

class _CardWithTitle extends StatelessWidget {
  final String title;
  final Widget child;
  const _CardWithTitle({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
