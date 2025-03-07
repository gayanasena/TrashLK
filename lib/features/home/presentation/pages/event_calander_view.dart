// import 'package:flutter/material.dart';
// import 'package:timeline_tile/timeline_tile.dart';
// import 'package:wasteapp/core/resources/colors.dart';
// import 'package:wasteapp/core/resources/text_styles.dart';
// import 'package:wasteapp/features/home/data/Services/firebase_services.dart';
// import 'package:wasteapp/features/home/data/model/detail_model.dart';
// import 'package:wasteapp/features/home/presentation/widgets/search_bar.dart';
// import 'package:wasteapp/routes/routes.dart';
// import 'package:wasteapp/routes/routes_extension.dart';

// class EventCalendarView extends StatefulWidget {
//   const EventCalendarView({super.key});

//   @override
//   EventCalendarViewState createState() => EventCalendarViewState();
// }

// class EventCalendarViewState extends State<EventCalendarView> {
//   final TextEditingController _searchController = TextEditingController();
//   late FirebaseServices firebaseServices;

//   List<DetailModel> lisDetailModel = [];
//   List<DetailModel> filteredEvents = [];
//   final ScrollController _scrollController = ScrollController();
//   String selectedMonth = "";
//   String currentSearchStr = "";
//   List<String> lisCurrentSelectedFilters = [];
//   List<String> lisMonths = [
//     "January",
//     "February",
//     "March",
//     "April",
//     "May",
//     "June",
//     "July",
//     "August",
//     "September",
//     "October",
//     "November",
//     "December",
//   ];

//   @override
//   void initState() {
//     firebaseServices = FirebaseServices();
//     getListData();
//     super.initState();
//   }

//   void getListData() async {
//     String collectionName = "events";

//     lisDetailModel = await firebaseServices.fetchAllData(
//       collectionName: collectionName,
//     );
//     filteredEvents = List.from(lisDetailModel); // Initially show all events
//     setState(() {
//       _scrollToCurrentMonth(); // Scroll to the current month after data is fetched
//     });
//   }

//   int findMonthIndex(String month) {
//     // Find the index of the month in the list, return -1 if not found
//     int monthIndex = lisMonths.indexOf(month);

//     return monthIndex != -1 ? monthIndex + 1 : -1;
//   }

//   void filterSearchResults(String query, {List<String>? selectedFilters}) {
//     List<DetailModel> tempList = [];

//     // Check if there is a query or selected filters
//     if (query.isNotEmpty ||
//         (selectedFilters != null && selectedFilters.isNotEmpty)) {
//       tempList =
//           lisDetailModel.where((item) {
//             final matchesSearch = item.title.toLowerCase().contains(
//               query.toLowerCase(),
//             );
//             final matchesCategory =
//                 selectedFilters == null ||
//                 selectedFilters.isEmpty ||
//                 selectedFilters.contains(item.season);

//             return matchesSearch && matchesCategory;
//           }).toList();
//     } else {
//       // If no filters or search query, return the full list
//       tempList = lisDetailModel;
//     }

//     setState(() {
//       filteredEvents = tempList;
//     });
//   }

//   // Function to scroll to the first event of the current month
//   void _scrollToCurrentMonth() {
//     final currentMonthIndex = DateTime.now().month;

//     // Find the first event index in the current month
//     final int eventIndex = filteredEvents.indexWhere(
//       (event) => findMonthIndex(event.season) == currentMonthIndex,
//     );

//     // Scroll to that position if such an event is found
//     if (eventIndex != -1 && _scrollController.hasClients) {
//       _scrollController.animateTo(
//         eventIndex * 100.0, // Adjust this value based on your item height
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _scrollController.dispose(); // Dispose the scroll controller
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Text("Event Calendar", style: TextStyles(context).appBarText),
//         elevation: 0,
//       ),
//       backgroundColor: ApplicationColors(context).appBackground,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Search Bar
//             CustomSearchBar(
//               controller: _searchController,
//               onChanged: (searchString) {
//                 currentSearchStr = searchString;
//                 filterSearchResults(
//                   searchString,
//                   selectedFilters: lisCurrentSelectedFilters,
//                 );
//               },
//               availableFilters: lisMonths,
//               onFiltersChanged: (selectedFilters) {
//                 filterSearchResults(
//                   currentSearchStr,
//                   selectedFilters: selectedFilters,
//                 );
//               },
//             ),
//             const SizedBox(height: 20),

//             const SizedBox(height: 20),

//             // List of events using map()
//             Expanded(
//               child: ListView.builder(
//                 controller: _scrollController,
//                 itemCount: filteredEvents.length,
//                 itemBuilder: (context, index) {
//                   final event = filteredEvents[index];
//                   bool showMonthTitle =
//                       (index == 0 ||
//                           event.season != filteredEvents[index - 1].season);

//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (showMonthTitle)
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 10),
//                           child: Text(
//                             lisMonths[(findMonthIndex(event.season) - 1)],
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18,
//                             ),
//                           ),
//                         ),
//                       _buildTimelineEvent(detailModel: event),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTimelineEvent({required DetailModel detailModel}) {
//     return TimelineTile(
//       alignment: TimelineAlign.manual,
//       lineXY: 0.2,
//       indicatorStyle: const IndicatorStyle(
//         width: 20,
//         color: Colors.orange,
//         padding: EdgeInsets.all(6),
//       ),
//       endChild: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: GestureDetector(
//           onTap: () {
//             context.toNamed(ScreenRoutes.toItemDetailScreen, args: detailModel);
//           },
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12.0),
//               image: DecorationImage(
//                 image: NetworkImage(detailModel.imageUrls.first),
//                 fit: BoxFit.cover,
//                 colorFilter: ColorFilter.mode(
//                   Colors.black.withOpacity(0.7),
//                   BlendMode.dstATop,
//                 ),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.3),
//                   blurRadius: 5,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             padding: const EdgeInsets.all(12.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   detailModel.season,
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                     color: Colors.grey[800],
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   detailModel.title,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                     color: Colors.black,
//                   ),
//                 ),
//                 const SizedBox(height: 50),
//                 // Text(
//                 //   description,
//                 //   style: TextStyle(color: Colors.grey[700]),
//                 // ),
//                 // const SizedBox(height: 8),
//               ],
//             ),
//           ),
//         ),
//       ),
//       beforeLineStyle: const LineStyle(color: Colors.orange, thickness: 4),
//     );
//   }
// }
