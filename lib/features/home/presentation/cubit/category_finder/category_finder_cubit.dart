import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:wasteapp/features/home/data/dataLists/waste_types.dart';

part 'category_finder_state.dart';

class CategoryFinderCubit extends Cubit<CategoryFinderState> {
  CategoryFinderCubit() : super(CategoryFinderInitial());

  final Map<String, Map<String, dynamic>> wasteData = DataLists.wasteData;

  void emitInitial() {
    emit(CategoryFinderInitial());
  }

  void searchWaste(String query) {
    query = query.trim().toLowerCase();
    if (wasteData.containsKey(query)) {
      emit(
        WasteFound(
          category: wasteData[query]!['category'],
          color: wasteData[query]!['color'],
        ),
      );
    } else {
      emit(WasteNotFound());
    }
  }
}
