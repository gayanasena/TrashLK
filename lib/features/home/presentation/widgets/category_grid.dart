import 'package:flutter/material.dart';

class CategoryGrid extends StatelessWidget {
  final List<Map<String, String>> items = [
    {"title": "Event Calendar", "image": "assets/images/event_calander.jpg"},
    {"title": "Travel Destinations", "image": "assets/images/destinations.jpg"},
    {"title": "Hotels", "image": "assets/images/hotels.jpg"},
    {"title": "Foods", "image": "assets/images/food.jpg"},
  ];
  final void Function(String category) onCategoryTap;

  CategoryGrid({super.key, required this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 columns
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 1.0,
      ),
      padding: const EdgeInsets.all(16.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            onCategoryTap("${items[index]['title']}");
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8.0,
                  offset: Offset(0, 4),
                ),
              ],
              image: DecorationImage(
                image: AssetImage(items[index]['image']!),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.3),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Center(
              child: Text(
                items[index]['title']!,
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }
}
