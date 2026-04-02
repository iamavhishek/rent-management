import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_bill_maker/bloc/property/property_bloc.dart';
import 'package:rent_bill_maker/models/property/property_model.dart';
import 'package:rent_bill_maker/screens/add_edit_property_screen.dart';
import 'package:rent_bill_maker/utils/constants.dart';
import 'package:rent_bill_maker/utils/l10n.dart';
import 'package:rent_bill_maker/utils/theme.dart';

class PropertyListScreen extends StatelessWidget {
  const PropertyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.get('properties')),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l10n.get('add_property'),
            onPressed: () => _addProperty(context),
          ),
        ],
      ),
      body: BlocBuilder<PropertyBloc, PropertyState>(
        builder: (context, state) {
          if (state is PropertyLoaded) {
            if (state.properties.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home_work_outlined, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(
                      l10n.get('add_room_first'),
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => _addProperty(context),
                      icon: const Icon(Icons.add),
                      label: Text(l10n.get('add_property')),
                    ),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.properties.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final property = state.properties[index];
                return Card(
                  child: InkWell(
                    onTap: () => _editProperty(context, property),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppTheme.warning.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.home, color: AppTheme.warning, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${property.name}${property.unitNumber.isNotEmpty ? " - ${property.unitNumber}" : ""}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  property.address,
                                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${Constants.currency}${property.monthlyRent.toStringAsFixed(0)} / month',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.accent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline, color: AppTheme.danger.withValues(alpha: 0.8)),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addProperty(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addProperty(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddEditPropertyScreen()),
    );
    if (result == true && context.mounted) {
      context.read<PropertyBloc>().add(LoadProperties());
    }
  }

  void _editProperty(BuildContext context, PropertyModel property) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditPropertyScreen(property: property),
      ),
    );
    if (result == true && context.mounted) {
      context.read<PropertyBloc>().add(LoadProperties());
    }
  }

  void _confirmDelete(BuildContext context, PropertyModel property) {
    final l10n = L10n.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.get('delete_confirm')),
        content: Text('${l10n.get('delete_property_msg')} "${property.name}"?'),
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
              context.read<PropertyBloc>().add(DeleteProperty(property.id));
            },
            child: Text(l10n.get('delete')),
          ),
        ],
      ),
    );
  }
}
