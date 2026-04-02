import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rent_bill_maker/bloc/property/property_bloc.dart';
import 'package:rent_bill_maker/bloc/tenant/tenant_bloc.dart';
import 'package:rent_bill_maker/models/tenant/tenant_model.dart';
import 'package:rent_bill_maker/utils/l10n.dart';
import 'package:rent_bill_maker/utils/theme.dart';

class AddEditTenantScreen extends StatefulWidget {
  final TenantModel? tenant;
  const AddEditTenantScreen({super.key, this.tenant});

  @override
  State<AddEditTenantScreen> createState() => _AddEditTenantScreenState();
}

class _AddEditTenantScreenState extends State<AddEditTenantScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _citizenshipController;
  DateTime? _moveInDate;
  String? _selectedPropertyId;
  String? _citizenshipImagePath;
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
    _selectedPropertyId = widget.tenant?.propertyId;
    _citizenshipImagePath = widget.tenant?.citizenshipImagePath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _citizenshipController.dispose();
    super.dispose();
  }

  Future<void> _pickCitizenshipImage() async {
    final l10n = L10n.of(context);
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(l10n.get('camera')),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
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
        // Save to app directory
        final dir = await getApplicationDocumentsDirectory();
        final fileName =
            'citizenship_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savedFile = await File(image.path).copy('${dir.path}/$fileName');
        setState(() {
          _citizenshipImagePath = savedFile.path;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.tenant != null;
    final l10n = L10n.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? l10n.get('edit_tenant') : l10n.get('new_tenant')),
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
                  // --- Tenant Details Card ---
                  _buildFormCard(
                    isDark: isDark,
                    title: l10n.get('tenant_details'),
                    icon: Icons.person_outline,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: l10n.get('tenant_name'),
                          hintText: l10n.get('full_name_hint'),
                          prefixIcon: const Icon(Icons.person, size: 20),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'आवश्यक छ' : null,
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: l10n.get('contact_number'),
                          hintText: '98XXXXXXXX',
                          prefixIcon: const Icon(Icons.phone, size: 20),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'आवश्यक छ' : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // --- Rental Details Card ---
                  _buildFormCard(
                    isDark: isDark,
                    title: l10n.get('room_flat_shop'),
                    icon: Icons.key_outlined,
                    children: [
                      BlocBuilder<PropertyBloc, PropertyState>(
                        builder: (context, state) {
                          if (state is PropertyLoaded) {
                            if (state.properties.isEmpty) {
                              return Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.orange.withValues(alpha: 0.5),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.info_outline,
                                      color: Colors.orange,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        l10n.get('add_room_first'),
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return DropdownButtonFormField<String>(
                              initialValue: _selectedPropertyId,
                              decoration: InputDecoration(
                                labelText: l10n.get('select_room'),
                                prefixIcon: const Icon(Icons.home, size: 20),
                              ),
                              items: state.properties.map((property) {
                                return DropdownMenuItem(
                                  value: property.id,
                                  child: Text(
                                    property.unitNumber.isNotEmpty
                                        ? '${property.name} - ${property.unitNumber}'
                                        : property.name,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() => _selectedPropertyId = value);
                              },
                              validator: (v) =>
                                  v == null ? l10n.get('required') : null,
                            );
                          }
                          return const LinearProgressIndicator();
                        },
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _moveInDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (date != null) setState(() => _moveInDate = date);
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: l10n.get('due_date'),
                            prefixIcon: const Icon(
                              Icons.calendar_today,
                              size: 20,
                            ),
                            enabled: false, // Ensure touch passes through
                          ),
                          child: Text(
                            _moveInDate != null
                                ? DateFormat('dd MMM yyyy').format(_moveInDate!)
                                : l10n.get('loading'),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // --- Identity & Citizenship Card ---
                  _buildFormCard(
                    isDark: isDark,
                    title: l10n.get('citizenship_proof'),
                    icon: Icons.assignment_ind_outlined,
                    children: [
                      TextFormField(
                        controller: _citizenshipController,
                        decoration: InputDecoration(
                          labelText: l10n.get('citizenship_number'),
                          hintText: 'e.g. 12-34-56-789',
                          prefixIcon: const Icon(Icons.badge, size: 20),
                        ),
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: _pickCitizenshipImage,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: _citizenshipImagePath != null ? null : 120,
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.grey.shade900
                                : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isDark
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade300,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: _citizenshipImagePath != null
                              ? Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
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
                                          setState(
                                            () => _citizenshipImagePath = null,
                                          );
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
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_a_photo,
                                      size: 32,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      l10n.get('citizenship_photo'),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade500,
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
                color: theme.scaffoldBackgroundColor,
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
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _saveTenant,
                  child: Text(
                    isEdit
                        ? "Update Tenant"
                        : l10n.get(
                            'add_tenant',
                          ), // Need a translaton for Update Tenant if not present, but use general text
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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

  Widget _buildFormCard({
    required bool isDark,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: AppTheme.accent),
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

  void _saveTenant() {
    if (_formKey.currentState!.validate() &&
        _selectedPropertyId != null &&
        _moveInDate != null) {
      final tenant =
          widget.tenant?.copyWith(
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            propertyId: _selectedPropertyId!,
            moveInDate: _moveInDate!,
            citizenshipNumber: _citizenshipController.text.trim(),
            citizenshipImagePath: _citizenshipImagePath,
          ) ??
          TenantModel.create(
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            propertyId: _selectedPropertyId!,
            moveInDate: _moveInDate!,
            citizenshipNumber: _citizenshipController.text.trim(),
            citizenshipImagePath: _citizenshipImagePath,
          );

      if (widget.tenant == null) {
        context.read<TenantBloc>().add(AddTenant(tenant));
      } else {
        context.read<TenantBloc>().add(UpdateTenant(tenant));
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
