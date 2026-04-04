import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:rent_bill_maker/bloc/settings/settings_cubit.dart';
import 'package:rent_bill_maker/bloc/tenant/tenant_bloc.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/models/tenant/tenant_model.dart';
import 'package:rent_bill_maker/screens/add_edit_tenant_screen.dart';
import 'package:rent_bill_maker/utils/l10n.dart';

class TenantListScreen extends StatelessWidget {
  const TenantListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final L10n l10n = L10n.of(context);
    final bool isBS = context.watch<SettingsCubit>().state == DateSystem.bs;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.get('tenants'))),
      body: BlocBuilder<TenantBloc, TenantState>(
        builder: (BuildContext context, TenantState state) {
          if (state is TenantLoaded) {
            if (state.tenants.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.people_outline,
                      size: 64,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.get('add_tenant_first'),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => _addTenant(context),
                      icon: const Icon(Icons.add, size: 20),
                      label: Text(l10n.get('add_tenant')),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 44),
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              itemCount: state.tenants.length,
              separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
              itemBuilder: (BuildContext context, int index) {
                final TenantModel tenant = state.tenants[index];
                return Card(
                  child: InkWell(
                    onTap: () => _editTenant(context, tenant),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: tenant.isActive
                                  ? const Color(0xFFD1FAE5)
                                  : const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                tenant.name.isNotEmpty
                                    ? tenant.name[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: tenant.isActive
                                      ? const Color(0xFF059669)
                                      : const Color(0xFFDC2626),
                                  fontSize: 16,
                                ),
                              ),
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
                                        tenant.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: tenant.isActive
                                            ? const Color(0xFFD1FAE5)
                                            : const Color(0xFFFEE2E2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        tenant.isActive
                                            ? l10n.get('currently_active')
                                            : l10n.get('moved_out'),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: tenant.isActive
                                              ? const Color(0xFF059669)
                                              : const Color(0xFFDC2626),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  tenant.phone,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                if (!tenant.isActive &&
                                    tenant.leftDate != null) ...<Widget>[
                                  const SizedBox(height: 3),
                                  Row(
                                    children: <Widget>[
                                      const Icon(
                                        Icons.event_busy,
                                        size: 13,
                                        color: Color(0xFFDC2626),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${l10n.get('left_date')}: ${isBS ? NepaliDateFormat('dd MMM yyyy').format(tenant.leftDate!.toNepaliDateTime()) : DateFormat('dd MMM yyyy').format(tenant.leftDate!)}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFFDC2626),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
                            onPressed: () => _confirmDelete(context, tenant),
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
      floatingActionButton: BlocBuilder<TenantBloc, TenantState>(
        builder: (BuildContext context, TenantState state) {
          if (state is TenantLoaded && state.tenants.isNotEmpty) {
            return FloatingActionButton(
              onPressed: () => _addTenant(context),
              child: const Icon(Icons.add),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Future<void> _addTenant(BuildContext context) async {
    final bool? result = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(builder: (_) => const AddEditTenantScreen()),
    );
    if (result == true && context.mounted) {
      context.read<TenantBloc>().add(LoadTenants());
    }
  }

  Future<void> _editTenant(BuildContext context, TenantModel tenant) async {
    final bool? result = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (_) => AddEditTenantScreen(tenant: tenant),
      ),
    );
    if (result == true && context.mounted) {
      context.read<TenantBloc>().add(LoadTenants());
    }
  }

  void _confirmDelete(BuildContext context, TenantModel tenant) {
    final L10n l10n = L10n.of(context);
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.get('delete_confirm')),
        content: Text('${l10n.get('delete_tenant_msg')} "${tenant.name}"?'),
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
              context.read<TenantBloc>().add(DeleteTenant(tenant.id));
            },
            child: Text(l10n.get('delete')),
          ),
        ],
      ),
    );
  }
}
