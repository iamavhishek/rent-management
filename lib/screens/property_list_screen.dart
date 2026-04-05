import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rent_bill_maker/bloc/property/property_bloc.dart';
import 'package:rent_bill_maker/bloc/tenant/tenant_bloc.dart';
import 'package:rent_bill_maker/models/property/property_model.dart';
import 'package:rent_bill_maker/models/tenant/tenant_model.dart';
import 'package:rent_bill_maker/utils/l10n.dart';

class PropertyListScreen extends StatelessWidget {
  const PropertyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final L10n l10n = L10n.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.get('properties'))),
      body: BlocBuilder<PropertyBloc, PropertyState>(
        builder: (BuildContext context, PropertyState state) {
          if (state is PropertyLoaded) {
            if (state.properties.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.home_work_outlined,
                        size: 64,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.get('add_room_first'),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => _addProperty(context),
                        icon: const Icon(Icons.add, size: 20),
                        label: Text(l10n.get('add_property')),
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              itemCount: state.properties.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 10),
              itemBuilder: (BuildContext context, int index) {
                final PropertyModel property = state.properties[index];
                return Card(
                  child: InkWell(
                    onTap: () => _editProperty(context, property),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.home,
                              color: Color(0xFFF59E0B),
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(
                                        '${property.name}${property.unitNumber.isNotEmpty ? " - ${property.unitNumber}" : ""}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    BlocBuilder<TenantBloc, TenantState>(
                                      builder: (_, TenantState tenantState) {
                                        final List<TenantModel> activeTenants =
                                            _activeTenantsFor(
                                              tenantState,
                                              property.id,
                                            );
                                        final bool isOccupied =
                                            activeTenants.isNotEmpty;
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isOccupied
                                                ? const Color(0xFFFEE2E2)
                                                : const Color(0xFFD1FAE5),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            isOccupied
                                                ? l10n.get('occupied')
                                                : l10n.get('vacant'),
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: isOccupied
                                                  ? const Color(0xFFDC2626)
                                                  : const Color(0xFF059669),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  property.address,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF64748B),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                BlocBuilder<TenantBloc, TenantState>(
                                  builder: (_, TenantState tenantState) {
                                    final List<TenantModel> activeTenants =
                                        _activeTenantsFor(
                                          tenantState,
                                          property.id,
                                        );
                                    if (activeTenants.isNotEmpty) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const SizedBox(height: 4),
                                          Row(
                                            children: <Widget>[
                                              const Icon(
                                                Icons.person_outline,
                                                size: 12,
                                                color: Color(0xFF2563EB),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                activeTenants.first.name,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFF2563EB),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                                BlocBuilder<TenantBloc, TenantState>(
                                  builder: (_, TenantState tenantState) {
                                    final List<TenantModel> activeTenants =
                                        _activeTenantsFor(
                                          tenantState,
                                          property.id,
                                        );
                                    if (activeTenants.isNotEmpty) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const SizedBox(height: 6),
                                          Row(
                                            children: <Widget>[
                                              const Icon(
                                                Icons.payments_outlined,
                                                size: 12,
                                                color: Color(0xFF059669),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${l10n.get('currency')}${activeTenants.first.monthlyRent.toStringAsFixed(0)} / month',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF059669),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: const Color(
                                0xFFDC2626,
                              ).withValues(alpha: 0.7),
                              size: 20,
                            ),
                            tooltip: l10n.get('delete'),
                            onPressed: () => _confirmDelete(context, property),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: BlocBuilder<PropertyBloc, PropertyState>(
        builder: (BuildContext context, PropertyState state) {
          if (state is PropertyLoaded && state.properties.isNotEmpty) {
            return FloatingActionButton(
              onPressed: () => _addProperty(context),
              child: const Icon(Icons.add),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Future<void> _addProperty(BuildContext context) async {
    await context.push<void>('/properties/add');
    if (context.mounted) {
      context.read<PropertyBloc>().add(LoadProperties());
    }
  }

  Future<void> _editProperty(
    BuildContext context,
    PropertyModel property,
  ) async {
    await context.push<void>('/properties/add', extra: property);
    if (context.mounted) {
      context.read<PropertyBloc>().add(LoadProperties());
    }
  }

  static List<TenantModel> _activeTenantsFor(
    TenantState tenantState,
    String propertyId,
  ) {
    if (tenantState is! TenantLoaded) return <TenantModel>[];
    return tenantState.tenants
        .where(
          (TenantModel t) => t.isActive && t.propertyId == propertyId,
        )
        .toList();
  }

  void _confirmDelete(BuildContext context, PropertyModel property) {
    final L10n l10n = L10n.of(context);
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.get('delete_confirm')),
        content: Text('${l10n.get('delete_property_msg')} "${property.name}"?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.get('cancel')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<PropertyBloc>().add(DeleteProperty(property.id));
            },
            child: Text(l10n.get('delete')),
          ),
        ],
      ),
    );
  }
}
