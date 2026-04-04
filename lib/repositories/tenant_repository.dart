import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:rent_bill_maker/models/tenant/tenant_model.dart';
import 'package:rent_bill_maker/utils/constants.dart';

class TenantRepository {
  final Box<TenantModel> _box = Hive.box<TenantModel>(Constants.tenantsBox);

  Future<List<TenantModel>> getAll() async => _box.values.toList();

  Future<TenantModel?> getById(String id) async => _box.get(id);

  Future<List<TenantModel>> getByPropertyId(String propertyId) async =>
      _box.values.where((TenantModel t) => t.propertyId == propertyId).toList();

  Future<List<TenantModel>> getActiveOnly() async =>
      _box.values.where((TenantModel t) => t.isActive).toList();

  Future<void> add(TenantModel tenant) async => _box.put(tenant.id, tenant);

  Future<void> update(TenantModel tenant) async => _box.put(tenant.id, tenant);

  Future<void> delete(String id) async => _box.delete(id);
}
