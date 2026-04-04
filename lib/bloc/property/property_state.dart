part of 'property_bloc.dart';

abstract class PropertyState extends Equatable {
  const PropertyState();

  @override
  List<Object?> get props => <Object?>[];
}

class PropertyInitial extends PropertyState {}

class PropertyLoading extends PropertyState {}

class PropertyLoaded extends PropertyState {
  const PropertyLoaded({required this.properties});
  final List<PropertyModel> properties;

  @override
  List<Object?> get props => <Object?>[properties];
}

class PropertyError extends PropertyState {
  const PropertyError({required this.message});
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
