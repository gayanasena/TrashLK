import 'package:flutter/material.dart';

class Assets {
  final BuildContext context;

  /// Pass context for dark mode use
  Assets(this.context);

  //logos
  String get appLogo => 'assets/images/logo.png';

  // Common icons
  String get icSampleUserImage => 'assets/images/blank_user.png';

  // images
  String get loginBackground => "assets/images/background.png";
  String get scanQR => "assets/images/scan_QR.jpg";
}

class CustomIcons {
  final BuildContext context;
  CustomIcons(this.context);

  // SvgPicture get svgLoginOrganisation => SvgPicture.asset(
  //       Assets(context).icLoginOrganisation,
  //       colorFilter:
  //           ColorFilter.mode(AppColors(context).appThemeBlue, BlendMode.srcIn),
  //     );
}
