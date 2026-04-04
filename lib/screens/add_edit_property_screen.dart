import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_bill_maker/bloc/property/property_bloc.dart';
import 'package:rent_bill_maker/models/property/property_model.dart';
import 'package:rent_bill_maker/utils/l10n.dart';

class AddEditPropertyScreen extends StatefulWidget {
  final PropertyModel? property;
  const AddEditPropertyScreen({super.key, this.property});

  @override
  State<AddEditPropertyScreen> createState() => _AddEditPropertyScreenState();
}

class _AddEditPropertyScreenState extends State<AddEditPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _unitController;
  late TextEditingController _rentController;
  late TextEditingController _depositController;
  late TextEditingController _ownerNameController;
  late TextEditingController _ownerPhoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.property?.name ?? '');
    _addressController = TextEditingController(
      text: widget.property?.address ?? '',
    );
    _unitController = TextEditingController(
      text: widget.property?.unitNumber ?? '',
    );
    _rentController = TextEditingController(
      text: widget.property?.monthlyRent.toStringAsFixed(0) ?? '',
    );
    _depositController = TextEditingController(
      text: widget.property != null && widget.property!.securityDeposit > 0
          ? widget.property!.securityDeposit.toStringAsFixed(0)
          : '',
    );
    _ownerNameController = TextEditingController(
      text: widget.property?.ownerName ?? '',
    );
    _ownerPhoneController = TextEditingController(
      text: widget.property?.ownerPhone ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _unitController.dispose();
    _rentController.dispose();
    _depositController.dispose();
    _ownerNameController.dispose();
    _ownerPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.property != null;
    final l10n = L10n.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? l10n.get('edit_property') : l10n.get('new_property'),
        ),
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
                  _formCard(
                    title: l10n.get('property_details'),
                    icon: Icons.home_work_outlined,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: l10n.get('property_name'),
                          hintText: l10n.get('property_name_hint'),
                          prefixIcon: const Icon(Icons.home, size: 20),
                        ),
                        validator: (v) => v == null || v.isEmpty
                            ? l10n.get('required')
                            : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: l10n.get('address'),
                          hintText: l10n.get('address_hint'),
                          prefixIcon: const Icon(Icons.location_on, size: 20),
                        ),
                        validator: (v) => v == null || v.isEmpty
                            ? l10n.get('required')
                            : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _unitController,
                        decoration: InputDecoration(
                          labelText: l10n.get('room_number'),
                          hintText: l10n.get('room_number_hint'),
                          prefixIcon: const Icon(
                            Icons.door_front_door,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _formCard(
                    title:
                        '${l10n.get('monthly_rent')} & ${l10n.get('deposit_amount')}',
                    icon: Icons.account_balance_wallet_outlined,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _rentController,
                              decoration: InputDecoration(
                                labelText: l10n.get('monthly_rent'),
                                hintText: l10n.get('rent_hint'),
                                prefixIcon: const Icon(
                                  Icons.payments,
                                  size: 20,
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (v) => v == null || v.isEmpty
                                  ? l10n.get('required')
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: TextFormField(
                              controller: _depositController,
                              decoration: InputDecoration(
                                labelText: l10n.get('deposit_amount'),
                                hintText: l10n.get('deposit_hint'),
                                prefixIcon: const Icon(Icons.savings, size: 20),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _formCard(
                    title: l10n.get('owner_details'),
                    icon: Icons.person_outline,
                    children: [
                      TextFormField(
                        controller: _ownerNameController,
                        decoration: InputDecoration(
                          labelText: l10n.get('owner_name'),
                          hintText: l10n.get('full_name_hint'),
                          prefixIcon: const Icon(Icons.person, size: 20),
                        ),
                        validator: (v) => v == null || v.isEmpty
                            ? l10n.get('required')
                            : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _ownerPhoneController,
                        decoration: InputDecoration(
                          labelText: l10n.get('owner_phone'),
                          hintText: l10n.get('phone_hint'),
                          prefixIcon: const Icon(Icons.phone, size: 20),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (v) => v == null || v.isEmpty
                            ? l10n.get('required')
                            : null,
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
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _saveProperty,
                  child: Text(
                    isEdit
                        ? l10n.get('update_property')
                        : l10n.get('add_property'),
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

  void _saveProperty() {
    final l10n = L10n.of(context);
    if (_formKey.currentState!.validate()) {
      final property =
          widget.property?.copyWith(
            name: _nameController.text.trim(),
            address: _addressController.text.trim(),
            unitNumber: _unitController.text.trim(),
            monthlyRent: double.parse(_rentController.text.trim()),
            securityDeposit:
                double.tryParse(_depositController.text.trim()) ?? 0,
            ownerName: _ownerNameController.text.trim(),
            ownerPhone: _ownerPhoneController.text.trim(),
          ) ??
          PropertyModel.create(
            name: _nameController.text.trim(),
            address: _addressController.text.trim(),
            unitNumber: _unitController.text.trim(),
            monthlyRent: double.parse(_rentController.text.trim()),
            securityDeposit:
                double.tryParse(_depositController.text.trim()) ?? 0,
            ownerName: _ownerNameController.text.trim(),
            ownerPhone: _ownerPhoneController.text.trim(),
          );

      if (widget.property == null) {
        context.read<PropertyBloc>().add(AddProperty(property));
      } else {
        context.read<PropertyBloc>().add(UpdateProperty(property));
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.property == null
                ? l10n.get('property_added')
                : l10n.get('property_updated'),
          ),
        ),
      );
      Navigator.pop(context);
    }
  }
}
