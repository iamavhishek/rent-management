import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rent_bill_maker/bloc/bill/bill_bloc.dart';
import 'package:rent_bill_maker/bloc/property/property_bloc.dart';
import 'package:rent_bill_maker/bloc/settings/settings_cubit.dart';
import 'package:rent_bill_maker/bloc/tenant/tenant_bloc.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/models/property/property_model.dart';
import 'package:rent_bill_maker/models/tenant/tenant_model.dart';
import 'package:rent_bill_maker/utils/l10n.dart';

class AddEditTenantScreen extends StatefulWidget {
  const AddEditTenantScreen({super.key, this.tenant});
  final TenantModel? tenant;

  @override
  State<AddEditTenantScreen> createState() => _AddEditTenantScreenState();
}

class _AddEditTenantScreenState extends State<AddEditTenantScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _citizenshipController;
  DateTime? _moveInDate;
  String? _selectedPropertyId;
  String? _citizenshipImagePath;
  late TextEditingController _elecRateController;
  late TextEditingController _waterRateController;
  late TextEditingController _elecInitialController;
  late TextEditingController _waterInitialController;
  late TextEditingController _rentController;
  DateTime? _leftDate;
  bool _isActive = true;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.tenant?.name ?? '');
    _phoneController = TextEditingController(text: widget.tenant?.phone ?? '');
    _citizenshipController = TextEditingController(
      text: widget.tenant?.citizenshipNumber ?? '',
    );
    _moveInDate = widget.tenant?.moveInDate ?? DateTime.now();
    _leftDate = widget.tenant?.leftDate;
    _selectedPropertyId = widget.tenant?.propertyId;
    _citizenshipImagePath = widget.tenant?.citizenshipImagePath;
    _elecRateController = TextEditingController(
      text: widget.tenant?.electricityRate.toStringAsFixed(0) ?? '0',
    );
    _waterRateController = TextEditingController(
      text: widget.tenant?.waterRate.toStringAsFixed(0) ?? '0',
    );
    _elecInitialController = TextEditingController(
      text: widget.tenant?.initialElectricityReading.toStringAsFixed(1) ?? '0',
    );
    _waterInitialController = TextEditingController(
      text: widget.tenant?.initialWaterReading.toStringAsFixed(1) ?? '0',
    );
    _rentController = TextEditingController(
      text: widget.tenant?.monthlyRent.toStringAsFixed(0) ?? '0',
    );
    _isActive = widget.tenant?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _citizenshipController.dispose();
    _elecRateController.dispose();
    _waterRateController.dispose();
    _elecInitialController.dispose();
    _waterInitialController.dispose();
    _rentController.dispose();
    super.dispose();
  }

  Future<void> _pickCitizenshipImage() async {
    final L10n l10n = L10n.of(context);
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded),
                title: Text(l10n.get('camera')),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded),
                title: Text(l10n.get('gallery')),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );

    if (source != null) {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        imageQuality: 80,
      );
      if (image != null) {
        final Directory dir = await getApplicationDocumentsDirectory();
        final String fileName =
            'citizenship_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final File savedFile = await File(
          image.path,
        ).copy('${dir.path}/$fileName');
        setState(() {
          _citizenshipImagePath = savedFile.path;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit = widget.tenant != null;
    final L10n l10n = L10n.of(context);
    final bool isBS = context.watch<SettingsCubit>().state == DateSystem.bs;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? l10n.get('edit_tenant') : l10n.get('new_tenant')),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: <Widget>[
                  _formCard(
                    title: l10n.get('tenant_details'),
                    icon: Icons.person_outline,
                    children: <Widget>[
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: l10n.get('tenant_name'),
                          hintText: l10n.get('full_name_hint'),
                          prefixIcon: const Icon(Icons.person, size: 20),
                        ),
                        validator: (String? v) =>
                            v == null || v.isEmpty ? 'आवश्यक छ' : null,
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: l10n.get('contact_number'),
                          hintText: l10n.get('phone_hint'),
                          prefixIcon: const Icon(Icons.phone, size: 20),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (String? v) => v == null || v.isEmpty
                            ? l10n.get('required')
                            : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _rentController,
                        decoration: InputDecoration(
                          labelText: l10n.get('monthly_rent'),
                          hintText: l10n.get('rent_hint'),
                          prefixIcon: const Icon(Icons.money, size: 20),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (String? v) => v == null || v.isEmpty
                            ? l10n.get('required')
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _formCard(
                    title: l10n.get('room_flat_shop'),
                    icon: Icons.key_outlined,
                    children: <Widget>[
                      BlocBuilder<PropertyBloc, PropertyState>(
                        builder: (BuildContext context, PropertyState state) {
                          if (state is PropertyLoaded) {
                            if (state.properties.isEmpty) {
                              return _InfoBox(
                                icon: Icons.info_outline,
                                text: l10n.get('add_room_first'),
                              );
                            }
                            return DropdownButtonFormField<String>(
                              initialValue: _selectedPropertyId,
                              decoration: InputDecoration(
                                labelText: l10n.get('select_room'),
                                prefixIcon: const Icon(Icons.home, size: 20),
                              ),
                              items: state.properties
                                  .where((PropertyModel property) {
                                    final Set<String> activePropertyIds =
                                        <String>{};
                                    final TenantState tenantState = context
                                        .read<TenantBloc>()
                                        .state;
                                    if (tenantState is TenantLoaded) {
                                      for (final TenantModel t
                                          in tenantState.tenants) {
                                        if (t.isActive) {
                                          activePropertyIds.add(t.propertyId);
                                        }
                                      }
                                    }
                                    return !activePropertyIds.contains(
                                          property.id,
                                        ) ||
                                        property.id ==
                                            widget.tenant?.propertyId;
                                  })
                                  .map(
                                    (
                                      PropertyModel property,
                                    ) => DropdownMenuItem<String>(
                                      value: property.id,
                                      child: Text(
                                        property.unitNumber.isNotEmpty
                                            ? '${property.name} - ${property.unitNumber}'
                                            : property.name,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (String? value) {
                                setState(() => _selectedPropertyId = value);
                                if (!isEdit && value != null) {
                                  _loadPreviousReadingsForProperty(
                                    context,
                                    value,
                                  );
                                }
                              },
                              validator: (String? v) =>
                                  v == null ? l10n.get('required') : null,
                            );
                          }
                          return const LinearProgressIndicator();
                        },
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            l10n.get('active_status'),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                _isActive
                                    ? l10n.get('currently_active')
                                    : l10n.get('moved_out'),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Transform.scale(
                                scale: 0.7,
                                child: Switch.adaptive(
                                  value: _isActive,
                                  onChanged: (bool val) =>
                                      setState(() => _isActive = val),
                                  activeTrackColor: const Color(0xFF059669),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (!_isActive) ...<Widget>[
                        const SizedBox(height: 14),
                        InkWell(
                          onTap: () async {
                            if (isBS) {
                              final NepaliDateTime? date =
                                  await showNepaliDatePicker(
                                    context: context,
                                    initialDate:
                                        _leftDate?.toNepaliDateTime() ??
                                        NepaliDateTime.now(),
                                    firstDate: NepaliDateTime(2000),
                                    lastDate: NepaliDateTime.now().add(
                                      const Duration(days: 365),
                                    ),
                                  );
                              if (date != null) {
                                setState(() => _leftDate = date.toDateTime());
                              }
                            } else {
                              final DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: _leftDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 365),
                                ),
                              );
                              if (date != null) {
                                setState(() => _leftDate = date);
                              }
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: l10n.get('left_date'),
                              prefixIcon: const Icon(
                                Icons.event_busy,
                                size: 20,
                              ),
                              enabled: false,
                            ),
                            child: Text(
                              _leftDate != null
                                  ? (isBS
                                        ? NepaliDateFormat(
                                            'dd MMM yyyy',
                                          ).format(
                                            _leftDate!.toNepaliDateTime(),
                                          )
                                        : DateFormat(
                                            'dd MMM yyyy',
                                          ).format(_leftDate!))
                                  : l10n.get('select_left_date'),
                              style: TextStyle(
                                color: _leftDate == null ? Colors.grey : null,
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 14),
                      Text(
                        l10n.get('move_in_date'),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          if (isBS) {
                            final NepaliDateTime? date =
                                await showNepaliDatePicker(
                                  context: context,
                                  initialDate:
                                      _moveInDate?.toNepaliDateTime() ??
                                      NepaliDateTime.now(),
                                  firstDate: NepaliDateTime(2000),
                                  lastDate: NepaliDateTime.now().add(
                                    const Duration(days: 365),
                                  ),
                                );
                            if (date != null) {
                              setState(() => _moveInDate = date.toDateTime());
                            }
                          } else {
                            final DateTime? date = await showDatePicker(
                              context: context,
                              initialDate: _moveInDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                            );
                            if (date != null) {
                              setState(() => _moveInDate = date);
                            }
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: l10n.get('move_in_date'),
                            prefixIcon: const Icon(
                              Icons.calendar_today,
                              size: 20,
                            ),
                            enabled: false,
                          ),
                          child: Text(
                            _moveInDate != null
                                ? (isBS
                                      ? NepaliDateFormat('dd MMM yyyy').format(
                                          _moveInDate!.toNepaliDateTime(),
                                        )
                                      : DateFormat(
                                          'dd MMM yyyy',
                                        ).format(_moveInDate!))
                                : l10n.get('loading'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _formCard(
                    title: l10n.get('utility_rates'),
                    icon: Icons.bolt_outlined,
                    children: <Widget>[
                      TextFormField(
                        controller: _elecRateController,
                        decoration: InputDecoration(
                          labelText: l10n.get('elec_unit_price'),
                          prefixIcon: const Icon(Icons.bolt, size: 20),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _waterRateController,
                        decoration: InputDecoration(
                          labelText: l10n.get('water_unit_price'),
                          prefixIcon: const Icon(Icons.water_drop, size: 20),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const Divider(height: 32),
                      Text(
                        l10n.get('initial_readings'),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _elecInitialController,
                        decoration: InputDecoration(
                          labelText: l10n.get('initial_reading_electricity'),
                          prefixIcon: const Icon(Icons.bolt, size: 20),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _waterInitialController,
                        decoration: InputDecoration(
                          labelText: l10n.get('initial_reading_water'),
                          prefixIcon: const Icon(Icons.water_drop, size: 20),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _formCard(
                    title: l10n.get('citizenship_proof'),
                    icon: Icons.assignment_ind_outlined,
                    children: <Widget>[
                      TextFormField(
                        controller: _citizenshipController,
                        decoration: InputDecoration(
                          labelText: l10n.get('citizenship_number'),
                          hintText: 'e.g. 12-34-56-789',
                          prefixIcon: const Icon(Icons.badge, size: 20),
                        ),
                      ),
                      const SizedBox(height: 14),
                      InkWell(
                        onTap: _pickCitizenshipImage,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: _citizenshipImagePath != null ? null : 140,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ),
                          ),
                          child: _citizenshipImagePath != null
                              ? Stack(
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        File(_citizenshipImagePath!),
                                        width: double.infinity,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _citizenshipImagePath = null;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withValues(
                                              alpha: 0.6,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.add_a_photo_rounded,
                                      size: 32,
                                      color: Colors.grey.shade300,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      l10n.get('citizenship_photo'),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Fixed Bottom Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    offset: const Offset(0, -4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _saveTenant,
                  child: Text(
                    isEdit ? l10n.get('update_tenant') : l10n.get('add_tenant'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
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
  }) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, size: 18, color: const Color(0xFF059669)),
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

  void _loadPreviousReadingsForProperty(
    BuildContext context,
    String propertyId,
  ) {
    final BillState billState = context.read<BillBloc>().state;
    final List<BillModel> bills = billState is BillLoaded
        ? billState.bills
              .where((BillModel b) => b.propertyId == propertyId)
              .toList()
        : <BillModel>[];
    final List<BillModel> sortedBills = bills
      ..sort(
        (BillModel a, BillModel b) => b.createdAt.compareTo(a.createdAt),
      );

    if (sortedBills.isNotEmpty) {
      final BillModel lastBill = sortedBills.first;
      setState(() {
        if (lastBill.currentElectricityReading != null) {
          _elecInitialController.text = lastBill.currentElectricityReading!
              .toStringAsFixed(1);
        }
        if (lastBill.currentWaterReading != null) {
          _waterInitialController.text = lastBill.currentWaterReading!
              .toStringAsFixed(1);
        }
      });
    }
  }

  void _saveTenant() {
    if (_formKey.currentState!.validate() &&
        _selectedPropertyId != null &&
        _moveInDate != null) {
      final bool isEdit = widget.tenant != null;
      final TenantModel tenant = TenantModel.create(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        propertyId: _selectedPropertyId!,
        moveInDate: _moveInDate!,
        citizenshipNumber: _citizenshipController.text.trim(),
        citizenshipImagePath: _citizenshipImagePath,
        electricityRate: double.tryParse(_elecRateController.text) ?? 0,
        waterRate: double.tryParse(_waterRateController.text) ?? 0,
        initialElectricityReading:
            double.tryParse(_elecInitialController.text) ?? 0,
        initialWaterReading: double.tryParse(_waterInitialController.text) ?? 0,
        monthlyRent: double.tryParse(_rentController.text) ?? 0,
      );

      if (isEdit) {
        final TenantModel updatedTenant = widget.tenant!.copyWith(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          citizenshipNumber: _citizenshipController.text.trim(),
          moveInDate: _moveInDate!,
          propertyId: _selectedPropertyId!,
          citizenshipImagePath: _citizenshipImagePath,
          electricityRate: double.tryParse(_elecRateController.text) ?? 0,
          waterRate: double.tryParse(_waterRateController.text) ?? 0,
          initialElectricityReading:
              double.tryParse(_elecInitialController.text) ?? 0,
          initialWaterReading:
              double.tryParse(_waterInitialController.text) ?? 0,
          isActive: _isActive,
          leftDate: _isActive ? null : _leftDate,
          monthlyRent: double.tryParse(_rentController.text) ?? 0,
        );
        context.read<TenantBloc>().add(UpdateTenant(updatedTenant));
      } else {
        context.read<TenantBloc>().add(AddTenant(tenant));
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.tenant == null
                ? L10n.of(context).get('tenant_added')
                : L10n.of(context).get('tenant_updated'),
          ),
        ),
      );
      Navigator.pop(context);
    } else if (_selectedPropertyId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${L10n.of(context).get('select_room')} ${L10n.of(context).get('required')}',
          ),
        ),
      );
    }
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.orange.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
    ),
    child: Row(
      children: <Widget>[
        Icon(icon, color: Colors.orange, size: 20),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
      ],
    ),
  );
}
