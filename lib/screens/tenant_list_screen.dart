import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_bill_maker/bloc/tenant/tenant_bloc.dart';
import 'package:rent_bill_maker/models/tenant/tenant_model.dart';
import 'package:rent_bill_maker/screens/add_edit_tenant_screen.dart';
import 'package:rent_bill_maker/utils/l10n.dart';
import 'package:rent_bill_maker/utils/theme.dart';

class TenantListScreen extends StatelessWidget {
  const TenantListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.get('tenants')),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l10n.get('add_tenant'),
            onPressed: () => _addTenant(context),
          ),
        ],
      ),
      body: BlocBuilder<TenantBloc, TenantState>(
        builder: (context, state) {
          if (state is TenantLoaded) {
            if (state.tenants.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people_outline, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(
                      l10n.get('add_tenant_first'),
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => _addTenant(context),
                      icon: const Icon(Icons.add),
                      label: Text(l10n.get('add_tenant')),
                    ),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.tenants.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final tenant = state.tenants[index];
                return Card(
                  child: InkWell(
                    onTap: () => _editTenant(context, tenant),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: AppTheme.accent.withValues(alpha: 0.1),
                            child: Text(
                              tenant.name.isNotEmpty ? tenant.name[0].toUpperCase() : '?',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppTheme.accent,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tenant.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  tenant.phone,
                                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline, color: AppTheme.danger.withValues(alpha: 0.8)),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTenant(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addTenant(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddEditTenantScreen()),
    );
    if (result == true && context.mounted) {
      context.read<TenantBloc>().add(LoadTenants());
    }
  }

  void _editTenant(BuildContext context, TenantModel tenant) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditTenantScreen(tenant: tenant)),
    );
    if (result == true && context.mounted) {
      context.read<TenantBloc>().add(LoadTenants());
    }
  }

  void _confirmDelete(BuildContext context, TenantModel tenant) {
    final l10n = L10n.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.get('delete_confirm')),
        content: Text('${l10n.get('delete_tenant_msg')} "${tenant.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.get('cancel')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.danger,
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
