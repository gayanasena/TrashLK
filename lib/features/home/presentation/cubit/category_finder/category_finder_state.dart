part of 'category_finder_cubit.dart';

sealed class CategoryFinderState extends Equatable {
  const CategoryFinderState();

  @override
  List<Object> get props => [];
}

final class CategoryFinderInitial extends CategoryFinderState {}

class WasteFound extends CategoryFinderState {
  final String category;
  final Color color;

  const WasteFound({required this.category, required this.color});
}

class WasteNotFound extends CategoryFinderState {}
