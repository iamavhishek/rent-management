part of 'property_bloc.dart';

abstract class PropertyEvent extends Equatable {
  const PropertyEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class LoadProperties extends PropertyEvent {}

class AddProperty extends PropertyEvent {
  const AddProperty(this.property);
  final PropertyModel property;

  @override
  List<Object?> get props => <Object?>[property];
}

class UpdateProperty extends PropertyEvent {
  const UpdateProperty(this.property);
  final PropertyModel property;

  @override
  List<Object?> get props => <Object?>[property];
}

class DeleteProperty extends PropertyEvent {
  const DeleteProperty(this.id);
  final String id;

  @override
  List<Object?> get props => <Object?>[id];
}

class GetPropertyById extends PropertyEvent {
  const GetPropertyById(this.id);
  final String id;

  @override
  List<Object?> get props => <Object?>[id];
}
