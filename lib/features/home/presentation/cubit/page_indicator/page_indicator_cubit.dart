import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'page_indicator_state.dart';

class PageIndicatorCubit extends Cubit<PageIndicatorState> {
  PageIndicatorCubit() : super(const PageIndicatorInitial(pageIndex: 0));

  void setPageIndex({required int index}) {
    int pageIndex = index;

    emit(PageIndicatorInitial(pageIndex: pageIndex));
  }
}
