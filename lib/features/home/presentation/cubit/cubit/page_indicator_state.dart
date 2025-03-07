part of 'page_indicator_cubit.dart';

sealed class PageIndicatorState extends Equatable {
  const PageIndicatorState();

  @override
  List<Object> get props => [];
}

final class PageIndicatorInitial extends PageIndicatorState {
  final int pageIndex;

  const PageIndicatorInitial({required this.pageIndex});

  @override
  List<Object> get props => [pageIndex];
}
