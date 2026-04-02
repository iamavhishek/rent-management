import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:rent_bill_maker/models/property/property_model.dart';
import 'package:rent_bill_maker/utils/constants.dart';

part 'property_event.dart';
part 'property_state.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  late Box<PropertyModel> propertyBox;

  PropertyBloc() : super(PropertyInitial()) {
    propertyBox = Hive.box<PropertyModel>(Constants.propertiesBox);

    on<LoadProperties>(_onLoadProperties);
    on<AddProperty>(_onAddProperty);
    on<UpdateProperty>(_onUpdateProperty);
    on<DeleteProperty>(_onDeleteProperty);
    on<GetPropertyById>(_onGetPropertyById);
  }

  Future<void> _onLoadProperties(
    LoadProperties event,
    Emitter<PropertyState> emit,
  ) async {
    emit(PropertyLoading());
    try {
      final properties = propertyBox.values.toList();
      emit(PropertyLoaded(properties: properties));
    } catch (e) {
      emit(PropertyError(message: 'Failed to load properties: $e'));
    }
  }

  Future<void> _onAddProperty(
    AddProperty event,
    Emitter<PropertyState> emit,
  ) async {
    emit(PropertyLoading());
    try {
      await propertyBox.put(event.property.id, event.property);
      final properties = propertyBox.values.toList();
      emit(PropertyLoaded(properties: properties));
    } catch (e) {
      emit(PropertyError(message: 'Failed to add property: $e'));
    }
  }

  Future<void> _onUpdateProperty(
    UpdateProperty event,
    Emitter<PropertyState> emit,
  ) async {
    emit(PropertyLoading());
    try {
      await propertyBox.put(event.property.id, event.property);
      final properties = propertyBox.values.toList();
      emit(PropertyLoaded(properties: properties));
    } catch (e) {
      emit(PropertyError(message: 'Failed to update property: $e'));
    }
  }

  Future<void> _onDeleteProperty(
    DeleteProperty event,
    Emitter<PropertyState> emit,
  ) async {
    emit(PropertyLoading());
    try {
      await propertyBox.delete(event.id);
      final properties = propertyBox.values.toList();
      emit(PropertyLoaded(properties: properties));
    } catch (e) {
      emit(PropertyError(message: 'Failed to delete property: $e'));
    }
  }

  Future<void> _onGetPropertyById(
    GetPropertyById event,
    Emitter<PropertyState> emit,
  ) async {
    emit(PropertyLoading());
    try {
      final property = propertyBox.get(event.id);
      if (property != null) {
        emit(PropertyLoaded(properties: [property]));
      } else {
        emit(PropertyError(message: 'Property not found'));
      }
    } catch (e) {
      emit(PropertyError(message: 'Failed to get property: $e'));
    }
  }
}
