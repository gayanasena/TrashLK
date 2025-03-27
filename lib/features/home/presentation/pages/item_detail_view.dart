import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:wasteapp/core/resources/colors.dart';
import 'package:wasteapp/core/resources/text_styles.dart';
import 'package:wasteapp/features/home/data/Services/firebase_services.dart';
import 'package:wasteapp/features/home/data/model/detail_model.dart';
import 'package:wasteapp/features/home/presentation/widgets/detail_carousel_card.dart';
import 'package:wasteapp/features/home/presentation/widgets/title_text.dart';

class ItemDetailPage extends StatefulWidget {
  final CommonDetailModel detailModel;

  const ItemDetailPage({super.key, required this.detailModel});

  @override
  ItemDetailPageState createState() => ItemDetailPageState();
}

class ItemDetailPageState extends State<ItemDetailPage> {
  late FirebaseServices firebaseServices;
  late bool isFlag = false;

  @override
  void initState() {
    firebaseServices = FirebaseServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          widget.detailModel.title,
          style: TextStyles(context).appBarText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              isFlag ? Icons.flag : Icons.flag_outlined,
              color: isFlag ? Colors.red : Colors.white,
            ),
            onPressed: () {
              setState(() => isFlag = !isFlag);
            },
          ),
        ],
      ),
      backgroundColor: ApplicationColors(context).appWhiteBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Image Carousel
            Visibility(
              visible: widget.detailModel.imageUrls?.isNotEmpty ?? false,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 250,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  viewportFraction: 0.95,
                ),
                items:
                    widget.detailModel.imageUrls?.map((imageUrl) {
                      return DetailCarouselCard(imageUrl: imageUrl);
                    }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            // Title & Info Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                // color: const Color.fromARGB(154, 200, 230, 201),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        widget.detailModel.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),

                      // Location
                      buildLocationRow(),

                      const SizedBox(height: 8),

                      // Category
                      buildCategoryRow(),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Description Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TitleText(titleText: "Description"),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      widget.detailModel.description ??
                          "No description provided.",
                      style: TextStyles(context).detailViewDescriptionText
                          .copyWith(fontSize: 16, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget buildLocationRow() {
    return Row(
      children: [
        const Icon(Icons.location_on, size: 20, color: Colors.red),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            widget.detailModel.location ?? "Unknown location",
            style: TextStyles(context).detailViewCategory.copyWith(
              fontSize: 15,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCategoryRow() {
    return Row(
      children: [
        const Icon(Icons.category, size: 20, color: Colors.blueGrey),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            'Category: ${widget.detailModel.category}',
            style: TextStyles(context).detailViewCategory.copyWith(
              fontSize: 15,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }
}
