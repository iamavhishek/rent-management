import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_bill_maker/bloc/bill/bill_bloc.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/widgets/bill_card.dart';
import 'package:rent_bill_maker/utils/l10n.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _filter = 'All';
  final TextEditingController _searchController = TextEditingController();
  final List<String> _filters = ['All', 'Paid', 'Pending', 'Overdue'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.get('bill_history'),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
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
                  ),
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 34,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    separatorBuilder: (context, _) => const SizedBox(width: 6),
                    itemBuilder: (context, index) {
                      final filter = _filters[index];
                      final selected = _filter == filter;
                      return FilterChip(
                        label: Text(
                          filter == 'All'
                              ? l10n.get('filter_all')
                              : filter == 'Paid'
                                  ? l10n.get('filter_paid')
                                  : filter == 'Pending'
                                      ? l10n.get('filter_pending')
                                      : l10n.get('filter_overdue'),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                        selected: selected,
                        onSelected: (_) => setState(() => _filter = filter),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Bill list
          Expanded(
            child: BlocBuilder<BillBloc, BillState>(
              builder: (context, state) {
                if (state is BillLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BillLoaded) {
                  var bills = state.bills;

                  // Apply filter
                  if (_filter != 'All') {
                    bills = bills.where((bill) {
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
                    bills = bills
                        .where(
                          (bill) => bill.billNumber.toLowerCase().contains(
                            _searchController.text.toLowerCase(),
                          ),
                        )
                        .toList();
                  }

                  if (bills.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 48,
                            color: Theme.of(context).dividerColor,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            l10n.get('no_bill_found'),
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color
                                  ?.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: bills.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: BillCard(bill: bills[index]),
                      );
                    },
                  );
                }
                return const Center(child: Text('कुनै बिल उपलब्ध छैन'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
