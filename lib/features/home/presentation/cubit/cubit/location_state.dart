part of 'location_cubit.dart';

sealed class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

final class LocationInitial extends LocationState {
  const LocationInitial();

  @override
  List<Object> get props => [];
}

final class LocationSuccess extends LocationState {
  final Weather weather;
  const LocationSuccess({required this.weather});

  @override
  List<Object> get props => [weather];
}
