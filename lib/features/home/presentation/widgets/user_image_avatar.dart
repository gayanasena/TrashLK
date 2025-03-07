import 'package:flutter/material.dart';
import 'package:wasteapp/core/resources/colors.dart';
import 'package:wasteapp/utils/assets.dart';

class UserImageAvatar extends StatelessWidget {
  final String imageUrl;

  const UserImageAvatar({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Border Circle
          Container(
            width: 60, // Adjust size as needed
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor,
            ),
          ),

          // Inner CircleAvatar
          CircleAvatar(
            radius: 26, // Inner avatar size
            backgroundImage:
                imageUrl.isNotEmpty
                    ? NetworkImage(imageUrl)
                    : AssetImage(Assets(context).icSampleUserImage),
          ),
        ],
      ),
    );
  }
}
