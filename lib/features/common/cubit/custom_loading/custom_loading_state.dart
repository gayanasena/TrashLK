part of 'custom_loading_cubit.dart';

sealed class CustomLoadingState extends Equatable {
  const CustomLoadingState();

  @override
  List<Object> get props => [];
}

final class CustomLoadingInitial extends CustomLoadingState {
  final bool isLoading;

  const CustomLoadingInitial({required this.isLoading});

  @override
  List<Object> get props => [isLoading];
}
