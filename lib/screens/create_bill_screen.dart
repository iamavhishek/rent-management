import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:rent_bill_maker/bloc/bill/bill_bloc.dart';
import 'package:rent_bill_maker/bloc/property/property_bloc.dart';
import 'package:rent_bill_maker/bloc/tenant/tenant_bloc.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/models/property/property_model.dart';
import 'package:rent_bill_maker/models/tenant/tenant_model.dart';
import 'package:rent_bill_maker/utils/constants.dart';
import 'package:rent_bill_maker/utils/l10n.dart';

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
  final BillModel? bill;
  const CreateBillScreen({super.key, this.bill});

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
  late TextEditingController _elecUnitsController;
  late TextEditingController _waterUnitsController;
  late TextEditingController _elecPrevController;
  late TextEditingController _elecCurrController;
  late TextEditingController _waterPrevController;
  late TextEditingController _waterCurrController;

  bool _useElecUnits = false;
  bool _useWaterUnits = false;

  final List<DynamicField> _dynamicCharges = [];
  final List<DynamicField> _dynamicDeductions = [];

  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  bool _isBS = false;

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
    _elecUnitsController = TextEditingController()
      ..addListener(() => setState(() {}));
    _waterUnitsController = TextEditingController()
      ..addListener(() => setState(() {}));
    _elecPrevController = TextEditingController()
      ..addListener(() => setState(() {}));
    _elecCurrController = TextEditingController()
      ..addListener(() => _calculateUnits(true));
    _waterPrevController = TextEditingController()
      ..addListener(() => setState(() {}));
    _waterCurrController = TextEditingController()
      ..addListener(() => _calculateUnits(false));

    if (widget.bill != null) {
      _selectedTenantId = widget.bill!.tenantId;
      _selectedMonth = widget.bill!.month;
      _selectedYear = widget.bill!.year;
      _dueDate = widget.bill!.dueDate;
      _isBS = widget.bill!.dateSystem == DateSystem.bs;
      _rentController.text = widget.bill!.rentAmount.toStringAsFixed(0);
      _electricityController.text = widget.bill!.electricityCharges
          .toStringAsFixed(0);
      _waterController.text = widget.bill!.waterCharges.toStringAsFixed(0);
      _discountController.text = widget.bill!.discount.toStringAsFixed(0);
      _elecUnitsController.text =
          widget.bill!.electricityUnits?.toStringAsFixed(1) ?? '0';
      _waterUnitsController.text =
          widget.bill!.waterUnits?.toStringAsFixed(1) ?? '0';
      _elecPrevController.text =
          widget.bill!.previousElectricityReading?.toStringAsFixed(1) ?? '0';
      _elecCurrController.text =
          widget.bill!.currentElectricityReading?.toStringAsFixed(1) ?? '0';
      _waterPrevController.text =
          widget.bill!.previousWaterReading?.toStringAsFixed(1) ?? '0';
      _waterCurrController.text =
          widget.bill!.currentWaterReading?.toStringAsFixed(1) ?? '0';

      _useElecUnits = widget.bill!.electricityUnits != null;
      _useWaterUnits = widget.bill!.waterUnits != null;

      widget.bill!.dynamicCharges.forEach((name, amount) {
        _dynamicCharges.add(
          DynamicField(
            TextEditingController(text: name),
            TextEditingController(text: amount.toStringAsFixed(0))
              ..addListener(() => setState(() {})),
          ),
        );
      });

      widget.bill!.dynamicDeductions.forEach((name, amount) {
        _dynamicDeductions.add(
          DynamicField(
            TextEditingController(text: name),
            TextEditingController(text: amount.toStringAsFixed(0))
              ..addListener(() => setState(() {})),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _rentController.dispose();
    _electricityController.dispose();
    _waterController.dispose();
    _discountController.dispose();
    _elecUnitsController.dispose();
    _waterUnitsController.dispose();
    _elecPrevController.dispose();
    _elecCurrController.dispose();
    _waterPrevController.dispose();
    _waterCurrController.dispose();
    for (var field in _dynamicCharges) {
      field.dispose();
    }
    for (var field in _dynamicDeductions) {
      field.dispose();
    }
    super.dispose();
  }

  void _calculateUnits(bool isElectricity) {
    if (isElectricity) {
      final prev = double.tryParse(_elecPrevController.text) ?? 0;
      final curr = double.tryParse(_elecCurrController.text) ?? 0;
      if (curr >= prev) {
        _elecUnitsController.text = (curr - prev).toStringAsFixed(1);
      }
    } else {
      final prev = double.tryParse(_waterPrevController.text) ?? 0;
      final curr = double.tryParse(_waterCurrController.text) ?? 0;
      if (curr >= prev) {
        _waterUnitsController.text = (curr - prev).toStringAsFixed(1);
      }
    }
    setState(() {});
  }

  double get _total {
    final rent = double.tryParse(_rentController.text) ?? 0;
    final electricity = _useElecUnits
        ? (double.tryParse(_elecUnitsController.text) ?? 0) *
              (_selectedTenant?.electricityRate ?? 0)
        : (double.tryParse(_electricityController.text) ?? 0);
    final water = _useWaterUnits
        ? (double.tryParse(_waterUnitsController.text) ?? 0) *
              (_selectedTenant?.waterRate ?? 0)
        : (double.tryParse(_waterController.text) ?? 0);
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
    final field = DynamicField(
      TextEditingController(),
      TextEditingController()..addListener(() => setState(() {})),
    );
    setState(() => _dynamicCharges.add(field));
  }

  void _addDeduction() {
    final field = DynamicField(
      TextEditingController(),
      TextEditingController()..addListener(() => setState(() {})),
    );
    setState(() => _dynamicDeductions.add(field));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

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
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                children: [
                  // Tenant Selection
                  _formCard(
                    title: l10n.get('select_tenant'),
                    icon: Icons.person_search_outlined,
                    children: [
                      BlocBuilder<TenantBloc, TenantState>(
                        builder: (context, state) {
                          if (state is TenantLoaded) {
                            if (state.tenants.isEmpty) {
                              return _InfoBox(
                                icon: Icons.info_outline,
                                text: l10n.get('add_tenant_first'),
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
                                  child: Text(tenant.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value == null) return;
                                final tenant = state.tenants.firstWhere(
                                  (t) => t.id == value,
                                );

                                final billBox = Hive.box<BillModel>(
                                  Constants.billsBox,
                                );
                                final lastBill =
                                    billBox.values
                                        .where((b) => b.tenantId == tenant.id)
                                        .toList()
                                      ..sort(
                                        (a, b) =>
                                            b.createdAt.compareTo(a.createdAt),
                                      );

                                double prevElec =
                                    tenant.initialElectricityReading;
                                double prevWater = tenant.initialWaterReading;

                                if (lastBill.isNotEmpty) {
                                  prevElec =
                                      lastBill
                                          .first
                                          .currentElectricityReading ??
                                      prevElec;
                                  prevWater =
                                      lastBill.first.currentWaterReading ??
                                      prevWater;
                                }

                                final propertyState = context
                                    .read<PropertyBloc>()
                                    .state;
                                PropertyModel? property;
                                if (propertyState is PropertyLoaded) {
                                  property = propertyState.properties
                                      .firstWhere(
                                        (p) => p.id == tenant.propertyId,
                                      );
                                }
                                setState(() {
                                  _selectedTenantId = value;
                                  _selectedTenant = tenant;
                                  _property = property;
                                  _elecPrevController.text = prevElec
                                      .toStringAsFixed(1);
                                  _waterPrevController.text = prevWater
                                      .toStringAsFixed(1);
                                  if (property != null) {
                                    _rentController.text = property.monthlyRent
                                        .toStringAsFixed(0);
                                  }
                                });
                              },
                              validator: (v) =>
                                  v == null ? l10n.get('required') : null,
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
                            color: const Color(
                              0xFF2563EB,
                            ).withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(
                                0xFF2563EB,
                              ).withValues(alpha: 0.1),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.home_work,
                                size: 18,
                                color: Color(0xFF2563EB),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '${_property!.name} ${_property!.unitNumber.isNotEmpty ? "- ${_property!.unitNumber}" : ""} • ${_property!.address}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF64748B),
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
                    // Bill Period
                    _formCard(
                      title: l10n.get('bill_period'),
                      icon: Icons.calendar_month_outlined,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _isBS ? l10n.get('using_bs') : l10n.get('using_ad'),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.color,
                              ),
                            ),
                            Switch.adaptive(
                              value: _isBS,
                              activeTrackColor: const Color(0xFF2563EB),
                              onChanged: (val) {
                                setState(() {
                                  _isBS = val;
                                  if (_isBS) {
                                    _selectedYear = NepaliDateTime.now().year;
                                    _selectedMonth = NepaliDateTime.now().month;
                                  } else {
                                    _selectedYear = DateTime.now().year;
                                    _selectedMonth = DateTime.now().month;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<int>(
                                key: ValueKey('month_$_isBS'),
                                initialValue: _selectedMonth,
                                decoration: InputDecoration(
                                  labelText: l10n.get('month'),
                                ),
                                items: List.generate(12, (i) {
                                  return DropdownMenuItem(
                                    value: i + 1,
                                    child: Text(
                                      l10n.getMonthName(i + 1, isBS: _isBS),
                                    ),
                                  );
                                }),
                                onChanged: (v) =>
                                    setState(() => _selectedMonth = v!),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonFormField<int>(
                                key: ValueKey('year_$_isBS'),
                                initialValue: _selectedYear,
                                decoration: InputDecoration(
                                  labelText: l10n.get('year'),
                                ),
                                items: List.generate(5, (i) {
                                  final currentYear = _isBS
                                      ? NepaliDateTime.now().year
                                      : DateTime.now().year;
                                  final year = currentYear - 2 + i;
                                  return DropdownMenuItem(
                                    value: year,
                                    child: Text(year.toString()),
                                  );
                                }),
                                onChanged: (v) =>
                                    setState(() => _selectedYear = v!),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        InkWell(
                          onTap: () async {
                            if (_isBS) {
                              final date = await showNepaliDatePicker(
                                context: context,
                                initialDate: _dueDate.toNepaliDateTime(),
                                firstDate: NepaliDateTime.now(),
                                lastDate: NepaliDateTime.now().add(
                                  const Duration(days: 365),
                                ),
                              );
                              if (date != null) {
                                setState(() => _dueDate = date.toDateTime());
                              }
                            } else {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _dueDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 365),
                                ),
                              );
                              if (date != null) {
                                setState(() => _dueDate = date);
                              }
                            }
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: l10n.get('due_date'),
                              prefixIcon: const Icon(
                                Icons.calendar_today,
                                size: 20,
                              ),
                              enabled: false,
                            ),
                            child: Text(
                              _isBS
                                  ? NepaliDateFormat(
                                      'dd MMM yyyy',
                                    ).format(_dueDate.toNepaliDateTime())
                                  : DateFormat('dd MMM yyyy').format(_dueDate),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Charges
                    _formCard(
                      title: l10n.get('amounts'),
                      icon: Icons.receipt_long_outlined,
                      children: [
                        _chargeField(
                          l10n.get('rent_label'),
                          _rentController,
                          Icons.home,
                        ),
                        const SizedBox(height: 16),
                        _utilityField(
                          label: l10n.get('electricity_label'),
                          amountController: _electricityController,
                          unitsController: _elecUnitsController,
                          prevReadingController: _elecPrevController,
                          currReadingController: _elecCurrController,
                          icon: Icons.bolt,
                          useUnits: _useElecUnits,
                          onToggle: (v) => setState(() => _useElecUnits = v),
                          rate: _selectedTenant?.electricityRate ?? 0,
                        ),
                        const SizedBox(height: 16),
                        _utilityField(
                          label: l10n.get('water_label'),
                          amountController: _waterController,
                          unitsController: _waterUnitsController,
                          prevReadingController: _waterPrevController,
                          currReadingController: _waterCurrController,
                          icon: Icons.water_drop,
                          useUnits: _useWaterUnits,
                          onToggle: (v) => setState(() => _useWaterUnits = v),
                          rate: _selectedTenant?.waterRate ?? 0,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _DynamicCard(
                      title: l10n.get('other_label'),
                      icon: Icons.add_circle_outline,
                      iconColor: const Color(0xFF2563EB),
                      items: _dynamicCharges,
                      onAdd: _addCharge,
                      onRemove: (idx) {
                        _dynamicCharges[idx].dispose();
                        setState(() => _dynamicCharges.removeAt(idx));
                      },
                    ),
                    const SizedBox(height: 16),
                    _DynamicCard(
                      title: l10n.get('discount_label'),
                      icon: Icons.remove_circle_outline,
                      iconColor: const Color(0xFFDC2626),
                      items: _dynamicDeductions,
                      onAdd: _addDeduction,
                      onRemove: (idx) {
                        _dynamicDeductions[idx].dispose();
                        setState(() => _dynamicDeductions.removeAt(idx));
                      },
                    ),
                    const SizedBox(height: 16),
                    _formCard(
                      title: l10n.get('discount_label'),
                      icon: Icons.discount_outlined,
                      children: [
                        _chargeField(
                          l10n.get('discount_label'),
                          _discountController,
                          Icons.discount,
                          color: const Color(0xFF16A34A),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 72),
                ],
              ),
            ),

            // Bottom: Total and Save
            if (_property != null)
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
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
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          Text(
                            '${l10n.get('currency')}${_total.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _createBill,
                          child: Text(l10n.get('save_bill')),
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

  Widget _formCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: const Color(0xFF2563EB)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...children,
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

  Widget _utilityField({
    required String label,
    required TextEditingController amountController,
    required TextEditingController unitsController,
    required TextEditingController prevReadingController,
    required TextEditingController currReadingController,
    required IconData icon,
    required bool useUnits,
    required Function(bool) onToggle,
    required double rate,
  }) {
    final l10n = L10n.of(context);
    if (rate <= 0) {
      return _chargeField(label, amountController, icon);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
              ),
            ),
            Row(
              children: [
                Text(
                  useUnits ? l10n.get('using_units') : l10n.get('using_amount'),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(width: 4),
                Transform.scale(
                  scale: 0.7,
                  child: Switch.adaptive(
                    value: useUnits,
                    onChanged: onToggle,
                    activeTrackColor: const Color(0xFF2563EB),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),
        if (useUnits)
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: prevReadingController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: l10n.get('prev_reading'),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: currReadingController,
                      decoration: InputDecoration(
                        labelText: l10n.get('curr_reading'),
                        hintText: l10n.get('initial_reading_hint'),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: unitsController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: l10n.get('units_consumed'),
                  prefixIcon: Icon(
                    icon,
                    size: 20,
                    color: const Color(0xFF2563EB),
                  ),
                  suffixText: ' x ${rate.toStringAsFixed(0)}',
                  helperText:
                      'Total: ${l10n.get('currency')}${((double.tryParse(unitsController.text) ?? 0) * rate).toStringAsFixed(0)}',
                  helperStyle: const TextStyle(
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          )
        else
          TextFormField(
            controller: amountController,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(icon, size: 20),
            ),
            keyboardType: TextInputType.number,
          ),
      ],
    );
  }

  void _createBill() {
    if (_formKey.currentState!.validate() &&
        _selectedTenant != null &&
        _property != null) {
      Map<String, double> dynamicChargesMap = {};
      for (var field in _dynamicCharges) {
        dynamicChargesMap[field.name.text.trim()] =
            double.tryParse(field.amount.text) ?? 0;
      }

      Map<String, double> dynamicDeductionsMap = {};
      for (var field in _dynamicDeductions) {
        dynamicDeductionsMap[field.name.text.trim()] =
            double.tryParse(field.amount.text) ?? 0;
      }

      int storageMonth = _selectedMonth;
      int storageYear = _selectedYear;

      if (_isBS) {
        final adDate = NepaliDateTime(
          _selectedYear,
          _selectedMonth,
          1,
        ).toDateTime();
        storageMonth = adDate.month;
        storageYear = adDate.year;
      }

      final elecCharges = _useElecUnits
          ? (double.tryParse(_elecUnitsController.text) ?? 0) *
                (_selectedTenant?.electricityRate ?? 0)
          : (double.tryParse(_electricityController.text) ?? 0);
      final waterCharges = _useWaterUnits
          ? (double.tryParse(_waterUnitsController.text) ?? 0) *
                (_selectedTenant?.waterRate ?? 0)
          : (double.tryParse(_waterController.text) ?? 0);

      final newBill =
          widget.bill?.copyWith(
            tenantId: _selectedTenantId!,
            propertyId: _property!.id,
            month: storageMonth,
            year: storageYear,
            dateSystem: _isBS ? DateSystem.bs : DateSystem.ad,
            rentAmount: double.tryParse(_rentController.text) ?? 0,
            electricityCharges: elecCharges,
            waterCharges: waterCharges,
            electricityUnits: _useElecUnits
                ? double.tryParse(_elecUnitsController.text)
                : null,
            waterUnits: _useWaterUnits
                ? double.tryParse(_waterUnitsController.text)
                : null,
            previousElectricityReading: _useElecUnits
                ? double.tryParse(_elecPrevController.text)
                : null,
            currentElectricityReading: _useElecUnits
                ? double.tryParse(_elecCurrController.text)
                : null,
            previousWaterReading: _useWaterUnits
                ? double.tryParse(_waterPrevController.text)
                : null,
            currentWaterReading: _useWaterUnits
                ? double.tryParse(_waterCurrController.text)
                : null,
            discount: double.tryParse(_discountController.text) ?? 0,
            dynamicCharges: dynamicChargesMap,
            dynamicDeductions: dynamicDeductionsMap,
            totalAmount: _total,
            dueDate: _dueDate,
          ) ??
          BillModel.create(
            tenantId: _selectedTenantId!,
            propertyId: _property!.id,
            month: storageMonth,
            year: storageYear,
            dateSystem: _isBS ? DateSystem.bs : DateSystem.ad,
            rentAmount: double.tryParse(_rentController.text) ?? 0,
            electricityCharges: elecCharges,
            waterCharges: waterCharges,
            electricityUnits: _useElecUnits
                ? double.tryParse(_elecUnitsController.text)
                : null,
            waterUnits: _useWaterUnits
                ? double.tryParse(_waterUnitsController.text)
                : null,
            previousElectricityReading: _useElecUnits
                ? double.tryParse(_elecPrevController.text)
                : null,
            currentElectricityReading: _useElecUnits
                ? double.tryParse(_elecCurrController.text)
                : null,
            previousWaterReading: _useWaterUnits
                ? double.tryParse(_waterPrevController.text)
                : null,
            currentWaterReading: _useWaterUnits
                ? double.tryParse(_waterCurrController.text)
                : null,
            dueDate: _dueDate,
            dynamicCharges: dynamicChargesMap,
            dynamicDeductions: dynamicDeductionsMap,
            discount: double.tryParse(_discountController.text) ?? 0,
          );

      if (widget.bill == null) {
        context.read<BillBloc>().add(AddBill(newBill));
      } else {
        context.read<BillBloc>().add(UpdateBill(newBill));
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10n.of(context).get('bill_created'))),
      );
      Navigator.pop(context, true);
    } else if (_selectedTenantId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${L10n.of(context).get('select_tenant')} ${L10n.of(context).get('required')}',
          ),
        ),
      );
    }
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoBox({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}

class _DynamicCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<DynamicField> items;
  final VoidCallback onAdd;
  final Function(int) onRemove;

  const _DynamicCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.items,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
                    Icon(icon, size: 18, color: iconColor),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: onAdd,
                  icon: Icon(Icons.add, color: iconColor),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            if (items.isNotEmpty) const SizedBox(height: 14),
            ...List.generate(items.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: items[index].name,
                        decoration: InputDecoration(labelText: 'Name'),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: items[index].amount,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Amount'),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                        size: 20,
                      ),
                      onPressed: () => onRemove(index),
                    ),
                  ],
                ),
              );
            }),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'No entries. Tap + to add.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade400,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
