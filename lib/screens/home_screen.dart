import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rent_bill_maker/bloc/bill/bill_bloc.dart';
import 'package:rent_bill_maker/bloc/property/property_bloc.dart';
import 'package:rent_bill_maker/bloc/tenant/tenant_bloc.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/screens/history_screen.dart';
import 'package:rent_bill_maker/screens/reports_screen.dart';
import 'package:rent_bill_maker/screens/settings_screen.dart';
import 'package:rent_bill_maker/utils/l10n.dart';
import 'package:rent_bill_maker/utils/responsive.dart';
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
    final L10n l10n = L10n.of(context);
    final List<Widget> screens = <Widget>[
      const DashboardScreen(),
      const HistoryScreen(),
      const ReportsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool useRail =
              constraints.maxWidth >= ResponsiveBreakpoints.navRail;

          if (useRail) {
            return Row(
              children: <Widget>[
                NavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (int index) =>
                      setState(() => _currentIndex = index),
                  labelType: NavigationRailLabelType.all,
                  destinations: <NavigationRailDestination>[
                    NavigationRailDestination(
                      icon: const Icon(Icons.dashboard_outlined, size: 24),
                      selectedIcon: const Icon(Icons.dashboard, size: 24),
                      label: Text(l10n.get('dashboard')),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.receipt_long_outlined, size: 24),
                      selectedIcon: const Icon(Icons.receipt_long, size: 24),
                      label: Text(l10n.get('bills')),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.analytics_outlined, size: 24),
                      selectedIcon: const Icon(Icons.analytics, size: 24),
                      label: Text(l10n.get('reports')),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.settings_outlined, size: 24),
                      selectedIcon: const Icon(Icons.settings, size: 24),
                      label: Text(l10n.get('settings')),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: IndexedStack(index: _currentIndex, children: screens),
                ),
              ],
            );
          }

          return IndexedStack(index: _currentIndex, children: screens);
        },
      ),
      floatingActionButton: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (!<int>[0, 1].contains(_currentIndex)) {
            return const SizedBox.shrink();
          }
          return FloatingActionButton(
            onPressed: () {
              context.push('/bill/create');
            },
            child: const Icon(Icons.add),
          );
        },
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth >= ResponsiveBreakpoints.navRail) {
            return const SizedBox.shrink();
          }
          return NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (int index) {
              if (_currentIndex == index && context.mounted && _currentIndex == 0) {
                // Refresh dashboard on re-tap
              }
              setState(() => _currentIndex = index);
            },
            height: 68,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: <Widget>[
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
          );
        },
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final L10n l10n = L10n.of(context);
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<PropertyBloc>().add(LoadProperties());
          context.read<TenantBloc>().add(LoadTenants());
          context.read<BillBloc>().add(LoadBills());
        },
        child: CenteredContent(
          child: CustomScrollView(
            slivers: <Widget>[
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
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
                  builder: (BuildContext context, BillState state) {
                    int propCount = 0;
                    int tenantCount = 0;
                    double pendingAmt = 0;
                    double overdueAmt = 0;

                    final PropertyState propState = context
                        .watch<PropertyBloc>()
                        .state;
                    final TenantState tenantState = context
                        .watch<TenantBloc>()
                        .state;

                    if (propState is PropertyLoaded) {
                      propCount = propState.properties.length;
                    }
                    if (tenantState is TenantLoaded) {
                      tenantCount = tenantState.tenants.length;
                    }
                    if (state is BillLoaded) {
                      for (final BillModel b in state.bills) {
                        if (b.status == PaymentStatus.pending ||
                            b.status == PaymentStatus.partiallyPaid) {
                          pendingAmt += b.outstandingAmount;
                        }
                        if (b.isOverdue) {
                          overdueAmt += b.outstandingAmount;
                        }
                      }
                    }

                    final int columns = adaptiveGridCount(context);
                    final double tileHeight = columns > 3 ? 95.0 : 110.0;
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: columns,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: columns > 3 ? 1.1 : 1.3,
                      children: <Widget>[
                        _StatTile(
                          icon: Icons.home_work_outlined,
                          label: l10n.get('properties'),
                          value: '$propCount',
                          color: AppTheme.primary,
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
                  children: <Widget>[
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
              builder: (BuildContext context, BillState state) {
                if (state is BillLoaded) {
                  if (state.bills.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
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

                  final List<BillModel> recentBills = state.bills
                      .take(5)
                      .toList();
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList.separated(
                      itemCount: recentBills.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (BuildContext context, int index) {
                        final BillModel bill = recentBills[index];
                        return CenteredContent(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: BillCard(bill: bill),
                          ),
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
                        children: <Widget>[
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(state.message, textAlign: TextAlign.center),
                          TextButton(
                            onPressed: () =>
                                context.read<BillBloc>().add(LoadBills()),
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
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.iconBg = 0xFFE0E7FF,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final int iconBg;

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.sizeOf(context).width;
    final bool wide = w >= ResponsiveBreakpoints.tablet;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double iconSize = constraints.maxWidth > 100 ? 18 : 14;
        final double iconBox = constraints.maxWidth > 100 ? 36 : 30;
        final double valueSize = constraints.maxWidth > 100 ? 18 : 13;
        final double labelSize = constraints.maxWidth > 100 ? 11 : 9;
        final double pad = constraints.maxWidth > 100 ? 12 : 8;
        final double radius = constraints.maxWidth > 100 ? 16 : 12;

        return Container(
          padding: EdgeInsets.all(pad),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Color(iconBg)),
            boxShadow: <BoxShadow>[
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
            children: <Widget>[
              Container(
                width: iconBox,
                height: iconBox,
                decoration: BoxDecoration(
                  color: Color(iconBg),
                  borderRadius: BorderRadius.circular(radius * 0.6),
                ),
                child: Icon(icon, color: color, size: iconSize),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: valueSize,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: labelSize,
                  color: const Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}
