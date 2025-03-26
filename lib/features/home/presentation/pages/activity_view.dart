// ignore_for_file: library_private_types_in_public_api

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

class ActivityView extends StatefulWidget {
  const ActivityView({super.key});

  @override
  ActivityViewState createState() => ActivityViewState();
}

class ActivityViewState extends State<ActivityView> {
  late FlutterSecureStorage secureStorage;
  late TextEditingController searchBarTextEditingController;
  late FirebaseServices firebaseServices;

  bool isGuestMode = false;

  List<CommonDetailModel> lisActivities = [];
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
    lisActivities = [];

    List<CommonDetailModel> fetchedData = await firebaseServices.fetchAllData(
      collectionName: DBConstants.activitiesCollection,
    );

    var uid = await secureStorage.read(key: 'uid');

    if (uid != "") {
      for (CommonDetailModel model in fetchedData) {
        if (model.uId == uid) {
          lisActivities.add(model);
        }
      }
    }

    setState(() {
      lisFilterd = List.from(lisActivities);

      // Extract values for filters, ensuring non-null values
      availableFilters =
          lisActivities
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
          lisActivities.where((item) {
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
      tempList = List.from(lisActivities);
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
        title: Text("Recent Activities", style: TextStyles(context).appBarText),
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
                  return ActivityCardView(item: item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityCardView extends StatelessWidget {
  const ActivityCardView({super.key, required this.item});

  final CommonDetailModel item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Container(
          color: Colors.white,
          width: 350,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row with image and order ID
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 20,
                    backgroundImage: AssetImage('assets/images/service.png'),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item.category}: Ref Id - ${item.id}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${item.notes}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Delivery tag
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 91, 177, 94),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "${item.category}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Location details
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.radio_button_checked, color: Colors.lime),
                      SizedBox(width: 8),
                      Text(
                        '${item.location}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  item.subLocation != ""
                      ? Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 3.0),
                        child: SizedBox(
                          height: 30,
                          child: Text(
                            " | \n | \n |",
                            style: TextStyle(
                              fontSize: 8.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                      : Container(),
                  item.subLocation != ""
                      ? Row(
                        children: [
                          Icon(Icons.radio_button_checked, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            '${item.subLocation}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                      : Container(),
                ],
              ),
              SizedBox(height: 10),
              // Description text
              Text(
                '${item.description}',
                style: TextStyle(color: Colors.blueGrey, fontSize: 15.0),
              ),
              SizedBox(height: 10),
              // View details button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.toNamed(
                      ScreenRoutes.toItemDetailScreen,
                      args: item,
                    );
                  },
                  label: Text(
                    'View Details',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
