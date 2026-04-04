import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:rent_bill_maker/models/property/property_model.dart';
import 'package:rent_bill_maker/utils/constants.dart';

class PropertyRepository {
  final Box<PropertyModel> _box = Hive.box<PropertyModel>(
    Constants.propertiesBox,
  );

  Future<List<PropertyModel>> getAll() async => _box.values.toList();

  Future<PropertyModel?> getById(String id) async => _box.get(id);

  Future<void> add(PropertyModel property) async =>
      _box.put(property.id, property);

  Future<void> update(PropertyModel property) async =>
      _box.put(property.id, property);

  Future<void> delete(String id) async => _box.delete(id);
}
