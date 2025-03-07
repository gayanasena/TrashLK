import 'package:flutter/material.dart';
import 'package:wasteapp/core/resources/colors.dart';

class TextStyles {
  final BuildContext context;

  TextStyles(this.context);

  late TextStyle appBarText = TextStyle(
    fontFamily: 'graphik_medium_500',
    fontSize: 20,
    color: ApplicationColors(context).white,
  );

  late TextStyle snackBarText = TextStyle(
    fontFamily: 'graphik_semibold_600',
    fontWeight: FontWeight.w600,
    fontSize: 15.0,
    color: ApplicationColors(context).white,
  );

  late TextStyle homeScreenUserNameText = TextStyle(
    fontFamily: 'graphik_regular_400',
    color: ApplicationColors(context).black,
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
  );

  late TextStyle homeCarouselHeaderText = TextStyle(
    fontFamily: 'graphik_regular_600',
    color: ApplicationColors(context).black,
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
  );

  late TextStyle buttonText = TextStyle(
    fontFamily: 'graphik_regular_600',
    color: ApplicationColors(context).white,
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
  );

  late TextStyle outlinedButtonText = const TextStyle(
    fontFamily: 'graphik_regular_600',
    color: primaryColor,
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
  );

  late TextStyle detailViewCategory = TextStyle(
    fontFamily: 'graphik_regular_500',
    color: ApplicationColors(context).gray,
    fontSize: 17.0,
    fontWeight: FontWeight.w500,
  );

  late TextStyle detailViewDescriptionText = TextStyle(
    fontFamily: 'graphik_regular_400',
    color: ApplicationColors(context).black,
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
  );

  late TextStyle loginPageHeaderText = TextStyle(
    fontFamily: 'DancingScript',
    color: ApplicationColors(context).black,
    fontSize: 40.0,
    fontWeight: FontWeight.bold,
  );

  late TextStyle loginDescriptionText = TextStyle(
    fontFamily: 'graphik_regular_400',
    color: Colors.grey.shade800,
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
  );

  late TextStyle homeHeaderTitle = TextStyle(
    fontFamily: 'DancingScript',
    color: ApplicationColors(context).black,
    fontSize: 28.0,
  );
}
