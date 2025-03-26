import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wasteapp/core/resources/colors.dart';
import 'package:wasteapp/core/resources/text_styles.dart';
import 'package:wasteapp/features/home/data/Services/firebase_services.dart';
import 'package:wasteapp/features/home/data/model/detail_model.dart';
import 'package:wasteapp/features/home/presentation/widgets/search_bar.dart';
import 'package:wasteapp/routes/routes.dart';
import 'package:wasteapp/routes/routes_extension.dart';
import 'package:wasteapp/utils/constants.dart';

class SchedulesView extends StatefulWidget {
  const SchedulesView({super.key});

  @override
  State<SchedulesView> createState() => _SchedulesViewState();
}

class _SchedulesViewState extends State<SchedulesView> {
  late FlutterSecureStorage secureStorage;
  late TextEditingController searchBarTextEditingController;
  late FirebaseServices firebaseServices;

  bool isGuestMode = false;

  List<CommonDetailModel> lisData = [];
  List<CommonDetailModel> lisFilterd = [];
  List<String> availableFilters = [];
  String currentSearchStr = "";
  List<String> lisCurrentSelectedFilters = [];

  @override
  void initState() {
    firebaseServices = FirebaseServices();
    secureStorage = const FlutterSecureStorage();
    searchBarTextEditingController = TextEditingController();
    super.initState();

    getListData();
  }

  void getListData() async {
    lisData = await firebaseServices.fetchAllData(
      collectionName: DBConstants.schedulesCollection,
    );

    setState(() {
      lisFilterd = List.from(lisData);

      // Extract values for filters, ensuring non-null values
      availableFilters =
          lisData
              .map((item) => item.category)
              .whereType<String>()
              .toSet()
              .toList();
    });
  }

  // Filter function based on search text and category filter
  void filterSearchResults(String query, {List<String>? selectedFilters}) {
    List<CommonDetailModel> tempList = [];

    if (query.isNotEmpty || (selectedFilters?.isNotEmpty ?? false)) {
      tempList =
          lisData.where((item) {
            final matchesSearch = item.title.toLowerCase().contains(
              query.toLowerCase(),
            );
            final matchesCategory =
                selectedFilters == null ||
                selectedFilters.isEmpty ||
                selectedFilters.contains(
                  item.category ?? "",
                ); // Handle null category

            return matchesSearch && matchesCategory;
          }).toList();
    } else {
      tempList = List.from(lisData);
    }

    setState(() {
      lisFilterd = tempList;
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
        title: Text("Schedules", style: TextStyles(context).appBarText),
        elevation: 0,
      ),
      backgroundColor: ApplicationColors(context).appWhiteBackground,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
              placeholderText: 'Search',
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: lisFilterd.length,
                itemBuilder: (context, index) {
                  final item = lisFilterd[index];
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
                                Row(
                                  children: [
                                    Icon(Icons.route),
                                    SizedBox(width: 5.0),
                                    Text(
                                      item.location ?? "",
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey.shade800,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    (item.subLocation != null &&
                                            item.subLocation!.isNotEmpty)
                                        ? Text(
                                          " to ${item.subLocation ?? ""} Route",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.grey.shade800,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                        : Container(),
                                  ],
                                ),
                                (item.notes != null && item.notes!.isNotEmpty)
                                    ? Row(
                                      children: [
                                        Icon(Icons.date_range),
                                        SizedBox(width: 5.0),
                                        Text(
                                          " ${item.notes ?? ""}",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.grey.shade800,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    )
                                    : Container(),
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
    );
  }
}
