part of 'connectivity_cubit.dart';

sealed class ConnectivityState extends Equatable {
  const ConnectivityState();

  @override
  List<Object> get props => [];
}

final class ConnectivityInitial extends ConnectivityState {
  final bool isConnected;

  const ConnectivityInitial({required this.isConnected});

  @override
  List<Object> get props => [isConnected];
}
