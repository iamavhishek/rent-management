import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_bill_maker/models/property/property_model.dart';
import 'package:rent_bill_maker/repositories/property_repository.dart';

part 'property_event.dart';
part 'property_state.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  PropertyBloc({required PropertyRepository propertyRepository})
    : _propertyRepository = propertyRepository,
      super(PropertyInitial()) {
    on<LoadProperties>(_onLoadProperties);
    on<AddProperty>(_onAddProperty);
    on<UpdateProperty>(_onUpdateProperty);
    on<DeleteProperty>(_onDeleteProperty);
    on<GetPropertyById>(_onGetPropertyById);
  }
  final PropertyRepository _propertyRepository;

  Future<void> _onLoadProperties(
    LoadProperties event,
    Emitter<PropertyState> emit,
  ) async {
    emit(PropertyLoading());
    try {
      final List<PropertyModel> properties = await _propertyRepository.getAll();
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
      await _propertyRepository.add(event.property);
      final List<PropertyModel> properties = await _propertyRepository.getAll();
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
      await _propertyRepository.update(event.property);
      final List<PropertyModel> properties = await _propertyRepository.getAll();
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
      await _propertyRepository.delete(event.id);
      final List<PropertyModel> properties = await _propertyRepository.getAll();
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
      final PropertyModel? property = await _propertyRepository.getById(
        event.id,
      );
      if (property != null) {
        emit(PropertyLoaded(properties: <PropertyModel>[property]));
      } else {
        emit(const PropertyError(message: 'Property not found'));
      }
    } catch (e) {
      emit(PropertyError(message: 'Failed to get property: $e'));
    }
  }
}
