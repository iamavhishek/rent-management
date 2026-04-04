import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:rent_bill_maker/bloc/bill/bill_bloc.dart';
import 'package:rent_bill_maker/bloc/settings/settings_cubit.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/utils/l10n.dart';
import 'package:rent_bill_maker/widgets/bill_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _filter = 'All';
  final TextEditingController _searchController = TextEditingController();
  final List<String> _filters = <String>['All', 'Paid', 'Pending', 'Overdue'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final L10n l10n = L10n.of(context);
    final bool isBS = context.watch<SettingsCubit>().state == DateSystem.bs;
    return SafeArea(
      child: Column(
        children: <Widget>[
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.get('bill_history'),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: l10n.get('search_bill'),
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((String filter) {
                      final bool selected = _filter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          labelPadding: EdgeInsets.zero,
                          label: Text(
                            filter == 'All'
                                ? l10n.get('filter_all')
                                : filter == 'Paid'
                                ? l10n.get('filter_paid')
                                : filter == 'Pending'
                                ? l10n.get('filter_pending')
                                : l10n.get('filter_overdue'),
                            style: TextStyle(
                              fontSize: 13,
                              color: selected
                                  ? Colors.white
                                  : Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.color,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          selected: selected,
                          onSelected: (_) => setState(() => _filter = filter),
                          showCheckmark: false,
                          selectedColor: Theme.of(context).primaryColor,
                          checkmarkColor: Colors.white,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Bill list
          Expanded(
            child: BlocBuilder<BillBloc, BillState>(
              builder: (BuildContext context, BillState state) {
                if (state is BillLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BillLoaded) {
                  List<BillModel> bills = state.bills;

                  // No longer filtering by DateSystem - showing all bills together
                  // bills = bills.where((bill) => bill.dateSystem == (isBS ? DateSystem.bs : DateSystem.ad)).toList();

                  // Apply status filter
                  if (_filter != 'All') {
                    bills = bills.where((BillModel bill) {
                      switch (_filter) {
                        case 'Paid':
                          return bill.status == PaymentStatus.paid;
                        case 'Pending':
                          return bill.status == PaymentStatus.pending ||
                              bill.status == PaymentStatus.partiallyPaid;
                        case 'Overdue':
                          return bill.isOverdue;
                        default:
                          return true;
                      }
                    }).toList();
                  }

                  // Apply search
                  if (_searchController.text.isNotEmpty) {
                    final String query = _searchController.text.toLowerCase();
                    bills = bills.where((BillModel bill) {
                      final String monthName = l10n
                          .getMonthName(bill.month, isBS: isBS)
                          .toLowerCase();
                      return bill.billNumber.toLowerCase().contains(query) ||
                          monthName.contains(query);
                    }).toList();
                  }

                  if (bills.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 48,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.get('no_bill_found'),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Sort all bills by their creation date for a unified timeline
                  bills.sort((BillModel a, BillModel b) => b.createdAt.compareTo(a.createdAt));

                  final Map<String, List<BillModel>> groupedBills = <String, List<BillModel>>{};
                  final List<String> groupOrder = <String>[];

                  for (BillModel bill in bills) {
                    // Consistently group by Billing Period (Month the rent is for)
                    // This matches the "Billed" portion of reports and is more intuitive for rent history.
                    int displayYear;
                    int displayMonth;

                    if (isBS) {
                      final NepaliDateTime bsDate = DateTime(
                        bill.year,
                        bill.month,
                        15,
                      ).toNepaliDateTime();
                      displayYear = bsDate.year;
                      displayMonth = bsDate.month;
                    } else {
                      displayYear = bill.year;
                      displayMonth = bill.month;
                    }

                    final String key = '$displayYear-$displayMonth';
                    if (!groupedBills.containsKey(key)) {
                      groupedBills[key] = <BillModel>[];
                      groupOrder.add(key);
                    }
                    groupedBills[key]!.add(bill);
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: groupOrder.length,
                    itemBuilder: (BuildContext context, int groupIndex) {
                      final String groupKey = groupOrder[groupIndex];
                      final List<String> keyParts = groupKey.split('-');
                      final int year = int.parse(keyParts[0]);
                      final int month = int.parse(keyParts[1]);
                      final List<BillModel> billsInGroup = groupedBills[groupKey]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 4,
                            ),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  '${l10n.getMonthName(month, isBS: isBS)} $year',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF64748B),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...billsInGroup.map((BillModel bill) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: BillCard(bill: bill),
                              ),
                            )),
                        ],
                      );
                    },
                  );
                }
                return Center(child: Text(l10n.get('no_bill_found')));
              },
            ),
          ),
        ],
      ),
    );
  }
}
