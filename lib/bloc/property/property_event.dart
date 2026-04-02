part of 'property_bloc.dart';

abstract class PropertyEvent extends Equatable {
  const PropertyEvent();

  @override
  List<Object?> get props => [];
}

class LoadProperties extends PropertyEvent {}

class AddProperty extends PropertyEvent {
  final PropertyModel property;
  const AddProperty(this.property);

  @override
  List<Object?> get props => [property];
}

class UpdateProperty extends PropertyEvent {
  final PropertyModel property;
  const UpdateProperty(this.property);

  @override
  List<Object?> get props => [property];
}

class DeleteProperty extends PropertyEvent {
  final String id;
  const DeleteProperty(this.id);

  @override
  List<Object?> get props => [id];
}

class GetPropertyById extends PropertyEvent {
  final String id;
  const GetPropertyById(this.id);

  @override
  List<Object?> get props => [id];
}