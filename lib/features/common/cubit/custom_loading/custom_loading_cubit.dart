import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'custom_loading_state.dart';

class CustomLoadingCubit extends Cubit<CustomLoadingInitial> {
  CustomLoadingCubit() : super(const CustomLoadingInitial(isLoading: false));

  void showLoading({bool? isAddNew}) {
    emit(const CustomLoadingInitial(isLoading: true));
  }

  void hideLoading() {
    emit(const CustomLoadingInitial(isLoading: false));
  }
}
