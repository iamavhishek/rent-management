import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rent_bill_maker/bloc/bill/bill_bloc.dart';
import 'package:rent_bill_maker/bloc/property/property_bloc.dart';
import 'package:rent_bill_maker/bloc/tenant/tenant_bloc.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/screens/add_edit_property_screen.dart';
import 'package:rent_bill_maker/screens/add_edit_tenant_screen.dart';
import 'package:rent_bill_maker/screens/create_bill_screen.dart';
import 'package:rent_bill_maker/screens/history_screen.dart';
import 'package:rent_bill_maker/screens/reports_screen.dart';
import 'package:rent_bill_maker/screens/settings_screen.dart';
import 'package:rent_bill_maker/utils/constants.dart';
import 'package:rent_bill_maker/utils/theme.dart';
import 'package:rent_bill_maker/utils/l10n.dart';
import 'package:rent_bill_maker/widgets/bill_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final screens = [
      const DashboardScreen(),
      const HistoryScreen(),
      const ReportsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: l10n.get('dashboard'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: l10n.get('bills'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.analytics_outlined),
            selectedIcon: const Icon(Icons.analytics),
            label: l10n.get('reports'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.get('settings'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showQuickActions(context),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
    final l10n = L10n.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.get('add_new'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _buildAction(
              context,
              icon: Icons.receipt_long,
              color: AppTheme.primary,
              label: l10n.get('create_bill'),
              subtitle: l10n.get('monthly_rent_bill'),
              onTap: () async {
                Navigator.pop(context);
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateBillScreen()),
                );
                if (result == true && context.mounted) {
                  context.read<BillBloc>().add(LoadBills());
                }
              },
            ),
            const SizedBox(height: 8),
            _buildAction(
              context,
              icon: Icons.person_add_alt_1,
              color: AppTheme.accent,
              label: l10n.get('add_tenant'),
              subtitle: l10n.get('new_tenant'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddEditTenantScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            _buildAction(
              context,
              icon: Icons.home_work,
              color: AppTheme.warning,
              label: l10n.get('add_property'),
              subtitle: l10n.get('room_flat_shop'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddEditPropertyScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAction(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: Theme.of(context).dividerColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<PropertyBloc>().add(LoadProperties());
          context.read<TenantBloc>().add(LoadTenants());
          context.read<BillBloc>().add(LoadBills());
        },
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.get('greeting'),
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Stats
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: BlocBuilder<BillBloc, BillState>(
                  builder: (context, state) {
                    int propCount = 0;
                    int tenantCount = 0;
                    double pendingAmt = 0;
                    double overdueAmt = 0;

                    final propState = context.watch<PropertyBloc>().state;
                    final tenantState = context.watch<TenantBloc>().state;

                    if (propState is PropertyLoaded) {
                      propCount = propState.properties.length;
                    }
                    if (tenantState is TenantLoaded) {
                      tenantCount = tenantState.tenants.length;
                    }
                    if (state is BillLoaded) {
                      for (final b in state.bills) {
                        if (b.status == PaymentStatus.pending ||
                            b.status == PaymentStatus.partiallyPaid) {
                          pendingAmt += b.outstandingAmount;
                        }
                        if (b.isOverdue) {
                          overdueAmt += b.outstandingAmount;
                        }
                      }
                    }

                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _StatTile(
                                icon: Icons.home_work,
                                label: l10n.get('properties'),
                                value: '$propCount',
                                color: AppTheme.primary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _StatTile(
                                icon: Icons.people_alt,
                                label: l10n.get('tenants'),
                                value: '$tenantCount',
                                color: AppTheme.accent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _StatTile(
                                icon: Icons.schedule,
                                label: l10n.get('pending_amount'),
                                value:
                                    '${Constants.currency}${pendingAmt.toStringAsFixed(0)}',
                                color: AppTheme.warning,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _StatTile(
                                icon: Icons.warning_amber,
                                label: l10n.get('overdue_amount'),
                                value:
                                    '${Constants.currency}${overdueAmt.toStringAsFixed(0)}',
                                color: AppTheme.danger,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // Recent Bills Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.get('recent_bills'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(l10n.get('view_all')),
                    ),
                  ],
                ),
              ),
            ),

            // Recent Bills List
            BlocBuilder<BillBloc, BillState>(
              builder: (context, state) {
                if (state is BillLoaded) {
                  if (state.bills.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 56,
                              color: Theme.of(context).dividerColor,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              l10n.get('no_bills_yet'),
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.get('add_bill_hint'),
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.5),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final recentBills = state.bills.take(5).toList();
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: BillCard(bill: recentBills[index]),
                        );
                      }, childCount: recentBills.length),
                    ),
                  );
                }
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              },
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  label,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
