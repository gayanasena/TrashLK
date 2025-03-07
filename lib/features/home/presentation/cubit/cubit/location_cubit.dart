import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasteapp/core/services/location/location_services.dart';
import 'package:wasteapp/features/home/data/model/wether_model.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final LocationServices locationServices = LocationServices();

  LocationCubit() : super(const LocationInitial());

}
