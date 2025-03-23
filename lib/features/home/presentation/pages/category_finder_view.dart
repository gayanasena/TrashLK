import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasteapp/features/home/presentation/cubit/category_finder/category_finder_cubit.dart';
import 'package:wasteapp/features/home/presentation/widgets/search_bar.dart';

class CategoryFinderView extends StatefulWidget {
  const CategoryFinderView({super.key});

  @override
  State<CategoryFinderView> createState() => _CategoryFinderViewState();
}

class _CategoryFinderViewState extends State<CategoryFinderView> {
  @override
  void initState() {
    context.read<CategoryFinderCubit>().emitInitial();

    super.initState();
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Waste Bin Finder')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomSearchBar(
              controller: _searchController,
              availableFilters: [],
              onFiltersChanged: (list) {},
              onChanged: (p0) {
                context.read<CategoryFinderCubit>().searchWaste(
                  _searchController.text,
                );
              },
              placeholderText: "Enter waste item",
            ),
            SizedBox(height: 20),
            BlocBuilder<CategoryFinderCubit, CategoryFinderState>(
              builder: (context, state) {
                if (state is WasteFound) {
                  return Container(
                    padding: EdgeInsets.all(
                      16.0,
                    ), // Added padding for better spacing
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize:
                          MainAxisSize
                              .min, // Wraps content without taking extra space
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Category: ${state.category}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: state.color,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              'BIN',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );                } else if (state is WasteNotFound) {
                  return Text(
                    'Waste item not found',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  );
                } else if (state is CategoryFinderInitial) {
                  return Container();
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
