import 'package:flutter/material.dart';
import 'package:wasteapp/utils/constants.dart';
import 'package:wasteapp/core/resources/colors.dart';
import 'package:wasteapp/core/resources/text_styles.dart';
import 'package:wasteapp/features/common/widgets/outlined_custom_button.dart';
import 'package:wasteapp/routes/routes.dart';
import 'package:wasteapp/routes/routes_extension.dart';
import 'package:wasteapp/utils/assets.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ApplicationColors(context).appWhiteBackground,
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image
                  Image.asset(
                    Assets(context).appLogo,
                    width: 250.0,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    Constants.appName,
                    style: TextStyles(context).loginPageHeaderText,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Column(
                  //       children: [
                  //         Container(
                  //           width: 150,
                  //           height: 200,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(20.0),
                  //             image: const DecorationImage(
                  //               image:
                  //                   NetworkImage('https://picsum.photos/200/300'),
                  //               fit: BoxFit.cover,
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     const SizedBox(width: 8.0),
                  //     Column(
                  //       children: [
                  //         Container(
                  //           width: 110,
                  //           height: 110,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(20.0),
                  //             image: const DecorationImage(
                  //               image: NetworkImage(
                  //                   'https://picsum.photos/60/60?random=1'),
                  //               fit: BoxFit.cover,
                  //             ),
                  //           ),
                  //         ),
                  //         const SizedBox(height: 8.0),
                  //         Container(
                  //           width: 100,
                  //           height: 100,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(20.0),
                  //             image: const DecorationImage(
                  //               image: NetworkImage(
                  //                   'https://picsum.photos/60/60?random=2'),
                  //               fit: BoxFit.cover,
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 24.0),

                  // Title Text
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      text: 'Clean Sri Lanka,',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: " Green Future!",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12.0),

                  Text(
                    "Empowering Sri Lanka for a cleaner, greener future with smart waste solution at a time! 🌱",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 64.0),

                  // Login / Register Button
                  CustomOutlinedButton(
                    label: 'Login or Register',
                    onPressed: () {
                      context.toNamed(ScreenRoutes.toLoginScreen);
                    },
                    isOutlined: false,
                  ),
                  const SizedBox(height: 12.0),

                  // Guest Button
                  CustomOutlinedButton(
                    label: 'Continue as Guest',
                    onPressed: () {
                      context.pushReplacementNamed(ScreenRoutes.toHomeScreen);
                    },
                    isOutlined: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
