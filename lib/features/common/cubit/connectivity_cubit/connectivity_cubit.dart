import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasteapp/utils/globals.dart' as globals;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

part 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final Connectivity connectivity;
  late StreamSubscription connStreamSubscription;

  ConnectivityCubit({required this.connectivity})
      : super(ConnectivityInitial(isConnected: globals.isConnected)) {
    connStreamSubscription =
        connectivity.onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi)) {
        globals.isConnected = true;
        emit(const ConnectivityInitial(isConnected: true));
      } else {
        globals.isConnected = false;
        emit(const ConnectivityInitial(isConnected: false));
      }
    });
  }
}
