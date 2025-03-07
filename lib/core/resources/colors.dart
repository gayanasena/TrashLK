import 'package:flutter/material.dart';

const MaterialColor primaryColor = Colors.lightGreen;

class ApplicationColors {
  final BuildContext context;

  ApplicationColors(this.context);

  Color get primaryColor => Colors.lightGreen;
  Color get white => const Color(0xffFFFFFF);
  Color get black => const Color(0xff000000);
  Color get transparent => const Color(0x00000000);
  Color get darkModeBlack => const Color(0xff171819);
  Color get gray => const Color.fromARGB(255, 62, 64, 65);
  Color get red => Colors.red;
  Color get lightGray => const Color(0xffC4C4C6);
  Color get green => const Color(0xff00AB68);
  Color get blue => const Color(0xff0267C7);
  Color get lightBlue => const Color(0xffCCDCEC);

  Color get shimmerBackground => const Color(0x93E9EFF6);
  Color get appBackground => const Color(0xFFF5F5F5);
  Color get appWhiteBackground => const Color(0xFFFFFFFF);
  Color get shadowContainers => const Color(0xAA000000);
  Color get whiteBackgroundTransparent =>
      const Color.fromARGB(230, 255, 255, 255);
}
