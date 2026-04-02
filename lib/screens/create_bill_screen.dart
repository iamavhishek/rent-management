import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rent_bill_maker/bloc/bill/bill_bloc.dart';
import 'package:rent_bill_maker/bloc/property/property_bloc.dart';
import 'package:rent_bill_maker/bloc/tenant/tenant_bloc.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/models/property/property_model.dart';
import 'package:rent_bill_maker/models/tenant/tenant_model.dart';
import 'package:rent_bill_maker/utils/constants.dart';
import 'package:rent_bill_maker/utils/l10n.dart';
import 'package:rent_bill_maker/utils/theme.dart';

class DynamicField {
  final TextEditingController name;
  final TextEditingController amount;
  DynamicField(this.name, this.amount);

  void dispose() {
    name.dispose();
    amount.dispose();
  }
}

class CreateBillScreen extends StatefulWidget {
  const CreateBillScreen({super.key});

  @override
  State<CreateBillScreen> createState() => _CreateBillScreenState();
}

class _CreateBillScreenState extends State<CreateBillScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedTenantId;
  TenantModel? _selectedTenant;
  PropertyModel? _property;

  late TextEditingController _rentController;
  late TextEditingController _electricityController;
  late TextEditingController _waterController;
  late TextEditingController _discountController;

  final List<DynamicField> _dynamicCharges = [];
  final List<DynamicField> _dynamicDeductions = [];

  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _rentController = TextEditingController()
      ..addListener(() => setState(() {}));
    _electricityController = TextEditingController()
      ..addListener(() => setState(() {}));
    _waterController = TextEditingController()
      ..addListener(() => setState(() {}));
    _discountController = TextEditingController()
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _rentController.dispose();
    _electricityController.dispose();
    _waterController.dispose();
    _discountController.dispose();
    for (var field in _dynamicCharges) {
      field.dispose();
    }
    for (var field in _dynamicDeductions) {
      field.dispose();
    }
    super.dispose();
  }

  double get _total {
    final rent = double.tryParse(_rentController.text) ?? 0;
    final electricity = double.tryParse(_electricityController.text) ?? 0;
    final water = double.tryParse(_waterController.text) ?? 0;
    final discount = double.tryParse(_discountController.text) ?? 0;

    double extra = 0;
    for (var field in _dynamicCharges) {
      extra += double.tryParse(field.amount.text) ?? 0;
    }

    double deductions = 0;
    for (var field in _dynamicDeductions) {
      deductions += double.tryParse(field.amount.text) ?? 0;
    }

    return rent + electricity + water + extra - deductions - discount;
  }

  void _addCharge() {
    final field = DynamicField(TextEditingController(), TextEditingController()..addListener(() => setState(() {})));
    setState(() => _dynamicCharges.add(field));
  }

  void _addDeduction() {
    final field = DynamicField(TextEditingController(), TextEditingController()..addListener(() => setState(() {})));
    setState(() => _dynamicDeductions.add(field));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.get('create_rent_bill')),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // --- Tenant Selection Card ---
                  _buildFormCard(
                    isDark: isDark,
                    title: l10n.get('select_tenant'),
                    icon: Icons.person_search_outlined,
                    children: [
                      BlocBuilder<TenantBloc, TenantState>(
                        builder: (context, state) {
                          if (state is TenantLoaded) {
                            if (state.tenants.isEmpty) {
                              return Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.orange.withValues(alpha: 0.5)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.info_outline, color: Colors.orange, size: 20),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        l10n.get('add_tenant_first'),
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return DropdownButtonFormField<String>(
                              initialValue: _selectedTenantId,
                              decoration: InputDecoration(
                                labelText: l10n.get('select_tenant_label'),
                                prefixIcon: const Icon(Icons.person, size: 20),
                              ),
                              items: state.tenants.map((tenant) {
                                return DropdownMenuItem(
                                  value: tenant.id,
                                  child: Text(
                                    tenant.name,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value == null) return;
                                final tenant = state.tenants.firstWhere((t) => t.id == value);
                                final propertyState = context.read<PropertyBloc>().state;
                                PropertyModel? property;
                                if (propertyState is PropertyLoaded) {
                                  property = propertyState.properties.firstWhere((p) => p.id == tenant.propertyId);
                                }
                                setState(() {
                                  _selectedTenantId = value;
                                  _selectedTenant = tenant;
                                  _property = property;
                                  if (property != null) {
                                    _rentController.text = property.monthlyRent.toStringAsFixed(0);
                                  }
                                });
                              },
                              validator: (v) => v == null ? l10n.get('required') : null,
                            );
                          }
                          return const LinearProgressIndicator();
                        },
                      ),
                      if (_property != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.1)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.home_work, size: 20, color: theme.colorScheme.primary),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '${_property!.name} ${_property!.unitNumber.isNotEmpty ? "- ${_property!.unitNumber}" : ""} • ${_property!.address}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (_property != null) ...[
                    // --- Bill Period Card ---
                    _buildFormCard(
                      isDark: isDark,
                      title: l10n.get('bill_period'),
                      icon: Icons.calendar_month_outlined,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<int>(
                                initialValue: _selectedMonth,
                                decoration: InputDecoration(labelText: l10n.get('month')),
                                items: List.generate(12, (i) {
                                  return DropdownMenuItem(
                                    value: i + 1,
                                    child: Text(
                                      DateFormat('MMMM').format(DateTime(2000, i + 1)),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  );
                                }),
                                onChanged: (v) => setState(() => _selectedMonth = v!),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonFormField<int>(
                                initialValue: _selectedYear,
                                decoration: InputDecoration(labelText: l10n.get('year')),
                                items: List.generate(5, (i) {
                                  final year = DateTime.now().year - 2 + i;
                                  return DropdownMenuItem(
                                    value: year,
                                    child: Text(
                                      year.toString(),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  );
                                }),
                                onChanged: (v) => setState(() => _selectedYear = v!),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _dueDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (date != null) setState(() => _dueDate = date);
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: l10n.get('due_date'),
                              prefixIcon: const Icon(Icons.calendar_today, size: 20),
                              enabled: false,
                            ),
                            child: Text(
                              DateFormat('dd MMM yyyy').format(_dueDate),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // --- Static Charges Card ---
                    _buildFormCard(
                      isDark: isDark,
                      title: l10n.get('amounts'),
                      icon: Icons.receipt_long_outlined,
                      children: [
                        _chargeField(l10n.get('rent_label'), _rentController, Icons.home),
                        const SizedBox(height: 12),
                        _chargeField(l10n.get('electricity_label'), _electricityController, Icons.bolt),
                        const SizedBox(height: 12),
                        _chargeField(l10n.get('water_label'), _waterController, Icons.water_drop),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // --- Dynamic Additional Charges ---
                    _buildDynamicCard(
                      isDark: isDark,
                      title: 'Additional Charges (Internet, Waste, etc.)', 
                      icon: Icons.add_circle_outline,
                      iconColor: Colors.blue,
                      items: _dynamicCharges,
                      onAdd: _addCharge,
                      onRemove: (idx) {
                        _dynamicCharges[idx].dispose();
                        setState(() => _dynamicCharges.removeAt(idx));
                      },
                      hintName: 'e.g. Internet',
                    ),
                    const SizedBox(height: 16),

                    // --- Dynamic Deductions ---
                    _buildDynamicCard(
                      isDark: isDark,
                      title: 'Deductions (Repairs, Adjustments)', 
                      icon: Icons.remove_circle_outline,
                      iconColor: Colors.deepOrange,
                      items: _dynamicDeductions,
                      onAdd: _addDeduction,
                      onRemove: (idx) {
                        _dynamicDeductions[idx].dispose();
                        setState(() => _dynamicDeductions.removeAt(idx));
                      },
                      hintName: 'e.g. Fixed Tap',
                    ),
                    const SizedBox(height: 16),

                     // --- Discount ---
                    _buildFormCard(
                      isDark: isDark,
                      title: l10n.get('discount_label'),
                      icon: Icons.discount_outlined,
                      children: [
                        _chargeField(
                          l10n.get('discount_label'), 
                          _discountController, 
                          Icons.discount, 
                          color: Colors.green
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 48), // Padding for scrolling past FAB-like area
                ],
              ),
            ),

            // Fixed Bottom Area: Total and Save Button
            if (_property != null)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade900 : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      offset: const Offset(0, -4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.get('total_amount'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${Constants.currency}${_total.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _createBill,
                          child: Text(
                            l10n.get('save_bill'),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard({
    required bool isDark,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: AppTheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicCard({
    required bool isDark,
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<DynamicField> items,
    required VoidCallback onAdd,
    required Function(int) onRemove,
    required String hintName,
  }) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 20, color: iconColor),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: onAdd,
                  icon: Icon(Icons.add, color: iconColor),
                  tooltip: 'Add',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                )
              ],
            ),
            if (items.isNotEmpty) const SizedBox(height: 16),
            ...List.generate(items.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: items[index].name,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          hintText: hintName,
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: items[index].amount,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          hintText: '0',
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => onRemove(index),
                    ),
                  ],
                ),
              );
            }),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'No entries added.',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _chargeField(
    String label,
    TextEditingController controller,
    IconData icon, {
    Color? color,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: color),
      ),
      keyboardType: TextInputType.number,
    );
  }

  void _createBill() {
    if (_formKey.currentState!.validate() &&
        _selectedTenant != null &&
        _property != null) {
      
      Map<String, double> dynamicChargesMap = {};
      for (var field in _dynamicCharges) {
        dynamicChargesMap[field.name.text.trim()] = double.tryParse(field.amount.text) ?? 0;
      }

      Map<String, double> dynamicDeductionsMap = {};
      for (var field in _dynamicDeductions) {
        dynamicDeductionsMap[field.name.text.trim()] = double.tryParse(field.amount.text) ?? 0;
      }

      final bill = BillModel.create(
        tenantId: _selectedTenant!.id,
        propertyId: _property!.id,
        month: _selectedMonth,
        year: _selectedYear,
        rentAmount: double.tryParse(_rentController.text) ?? 0,
        electricityCharges: double.tryParse(_electricityController.text) ?? 0,
        waterCharges: double.tryParse(_waterController.text) ?? 0,
        internetCharges: 0, 
        otherCharges: 0,
        otherChargesDescription: '',
        discount: double.tryParse(_discountController.text) ?? 0,
        dynamicCharges: dynamicChargesMap,
        dynamicDeductions: dynamicDeductionsMap,
        dueDate: _dueDate,
      );

      context.read<BillBloc>().add(AddBill(bill));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10n.of(context).get('bill_created'))),
      );
      Navigator.pop(context, true);
    } else if (_selectedTenant == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10n.of(context).get('select_tenant') + ' ' + L10n.of(context).get('required'))),
      );
    }
  }
}
