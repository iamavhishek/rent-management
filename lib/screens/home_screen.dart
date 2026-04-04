import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rent_bill_maker/bloc/bill/bill_bloc.dart';
import 'package:rent_bill_maker/bloc/property/property_bloc.dart';
import 'package:rent_bill_maker/bloc/tenant/tenant_bloc.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/screens/create_bill_screen.dart';
import 'package:rent_bill_maker/screens/history_screen.dart';
import 'package:rent_bill_maker/screens/reports_screen.dart';
import 'package:rent_bill_maker/screens/settings_screen.dart';
import 'package:rent_bill_maker/utils/l10n.dart';
import 'package:rent_bill_maker/utils/theme.dart';
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
      floatingActionButton: [0, 1].contains(_currentIndex)
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateBillScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          if (_currentIndex == index && context.mounted && _currentIndex == 0) {
            // Refresh dashboard on re-tap
          }
          setState(() => _currentIndex = index);
        },
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined, size: 24),
            selectedIcon: const Icon(Icons.dashboard, size: 24),
            label: l10n.get('dashboard'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined, size: 24),
            selectedIcon: const Icon(Icons.receipt_long, size: 24),
            label: l10n.get('bills'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.analytics_outlined, size: 24),
            selectedIcon: const Icon(Icons.analytics, size: 24),
            label: l10n.get('reports'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined, size: 24),
            selectedIcon: const Icon(Icons.settings, size: 24),
            label: l10n.get('settings'),
          ),
        ],
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
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.get('greeting'),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            // Stats
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
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

                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.3,
                      children: [
                        _StatTile(
                          icon: Icons.home_work_outlined,
                          label: l10n.get('properties'),
                          value: '$propCount',
                          color: AppTheme.primary,
                          iconBg: 0xFFE0E7FF,
                        ),
                        _StatTile(
                          icon: Icons.people_alt_outlined,
                          label: l10n.get('tenants'),
                          value: '$tenantCount',
                          color: AppTheme.accent,
                          iconBg: 0xFFD1FAE5,
                        ),
                        _StatTile(
                          icon: Icons.schedule_outlined,
                          label: l10n.get('pending_amount'),
                          value:
                              '${l10n.get('currency')}${pendingAmt.toStringAsFixed(0)}',
                          color: AppTheme.warning,
                          iconBg: 0xFFFEF3C7,
                        ),
                        _StatTile(
                          icon: Icons.warning_amber_outlined,
                          label: l10n.get('overdue_amount'),
                          value:
                              '${l10n.get('currency')}${overdueAmt.toStringAsFixed(0)}',
                          color: AppTheme.danger,
                          iconBg: 0xFFFEE2E2,
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
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.get('recent_bills'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(
                      onPressed: () {
                        // Could navigate to history
                      },
                      child: Text(
                        l10n.get('view_all'),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              l10n.get('no_bills_yet'),
                              style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.get('add_bill_hint'),
                              style: const TextStyle(
                                color: Color(0xFF64748B),
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
                    sliver: SliverList.separated(
                      itemCount: recentBills.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final bill = recentBills[index];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BillCard(bill: bill),
                        );
                      },
                    ),
                  );
                }
                if (state is BillError) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 48),
                          const SizedBox(height: 16),
                          Text(state.message, textAlign: TextAlign.center),
                          TextButton(
                            onPressed: () => context.read<BillBloc>().add(LoadBills()),
                            child: const Text('पुन: प्रयास गर्नुहोस्'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              },
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
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
  final int iconBg;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.iconBg = 0xFFE0E7FF,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(iconBg)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Color(iconBg),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
