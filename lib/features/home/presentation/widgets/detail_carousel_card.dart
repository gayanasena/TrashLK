import 'package:flutter/material.dart';
import 'package:wasteapp/core/resources/colors.dart';

class DetailCarouselCard extends StatelessWidget {
  final String imageUrl;

  const DetailCarouselCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color: ApplicationColors(context).shimmerBackground,
        borderRadius: BorderRadius.circular(16.0),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
