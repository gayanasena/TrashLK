import 'package:flutter/material.dart';
import 'package:wasteapp/core/resources/colors.dart';
import 'package:wasteapp/core/resources/dimens.dart';
import 'package:wasteapp/core/resources/text_styles.dart';
import 'package:wasteapp/features/home/data/Services/firebase_services.dart';
import 'package:wasteapp/features/home/data/model/detail_model.dart';
import 'package:wasteapp/features/home/presentation/widgets/search_bar.dart';
import 'package:wasteapp/routes/routes.dart';
import 'package:wasteapp/routes/routes_extension.dart';

class ItemGridView extends StatefulWidget {
  final String gridType;

  const ItemGridView({super.key, required this.gridType});

  @override
  ItemGridViewState createState() => ItemGridViewState();
}

class ItemGridViewState extends State<ItemGridView> {
  late FirebaseServices firebaseServices;
  late TextEditingController searchBarTextEditingController;
  List<CommonDetailModel> lisDetailModel = [];
  List<CommonDetailModel> filteredList = [];
  List<String?> availableFilters = [];
  String currentSearchStr = "";
  List<String> lisCurrentSelectedFilters = [];

  @override
  void initState() {
    searchBarTextEditingController = TextEditingController();
    firebaseServices = FirebaseServices();
    getListData();
    super.initState();
  }

  void getListData() async {
    String collectionName = "";
    if (widget.gridType == 'Travel Destinations') {
      collectionName = 'destinations';
    } else {
      collectionName = widget.gridType.toLowerCase();
    }
    lisDetailModel = await firebaseServices.fetchAllData(
      collectionName: collectionName,
    );

    if (lisDetailModel.isNotEmpty) {
      setState(() {
        filteredList = lisDetailModel; // Initially, display all items.

        // Extract unique categories for filters
        availableFilters =
            lisDetailModel.map((item) => item.category).toSet().toList();
      });
    }
  }

  // Filter function based on search text and category filter
  void filterSearchResults(String query, {List<String>? selectedFilters}) {
    List<CommonDetailModel> tempList = [];

    // Check if there is a query or selected filters
    if (query.isNotEmpty ||
        (selectedFilters != null && selectedFilters.isNotEmpty)) {
      tempList =
          lisDetailModel.where((item) {
            final matchesSearch = item.title.toLowerCase().contains(
              query.toLowerCase(),
            );
            final matchesCategory =
                selectedFilters == null ||
                selectedFilters.isEmpty ||
                selectedFilters.contains(item.category);

            return matchesSearch && matchesCategory;
          }).toList();
    } else {
      // If no filters or search query, return the full list
      tempList = lisDetailModel;
    }

    setState(() {
      filteredList = tempList;
    });
  }

  @override
  void dispose() {
    searchBarTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: const [
          // GestureDetector(
          //   child: const Text("Upload"),
          //   onTap: () {
          //     List<DetailModel> model = [];

          //     firebaseServices.uploadItemList(model, 'destinations');
          //   },
          // )
        ],
        title: Text(widget.gridType, style: TextStyles(context).appBarText),
        elevation: 0,
      ),
      body: Container(
        color: ApplicationColors(context).appBackground,
        child: Padding(
          padding: const EdgeInsets.all(Dimens.defaultPadding),
          child: Column(
            children: [
              const SizedBox(height: 8.0),
              CustomSearchBar(
                controller: searchBarTextEditingController,
                onChanged: (searchString) {
                  currentSearchStr = searchString;
                  filterSearchResults(
                    searchString,
                    selectedFilters: lisCurrentSelectedFilters,
                  );
                },
                availableFilters: availableFilters,
                onFiltersChanged: (selectedFilters) {
                  filterSearchResults(
                    currentSearchStr,
                    selectedFilters: selectedFilters,
                  );
                },
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final item = filteredList[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      color: Colors.white,
                      elevation: 4,
                      child: InkWell(
                        onTap: () {
                          context.toNamed(
                            ScreenRoutes.toItemDetailScreen,
                            args: item,
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12.0),
                                topRight: Radius.circular(12.0),
                              ),
                              child: Image.network(
                                item.imageUrls?.first ?? "",
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    item.description ?? "",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.grey.shade800,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
