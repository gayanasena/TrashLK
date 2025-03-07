import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wasteapp/utils/constants.dart';
import 'package:wasteapp/core/resources/colors.dart';
import 'package:wasteapp/core/resources/text_styles.dart';
import 'package:wasteapp/features/common/widgets/outlined_custom_button.dart';
import 'package:wasteapp/features/common/widgets/outlined_text_box.dart';
import 'package:wasteapp/features/home/data/Services/firebase_services.dart';
import 'package:wasteapp/routes/routes.dart';
import 'package:wasteapp/routes/routes_extension.dart';
import 'package:wasteapp/utils/assets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late FirebaseServices firebaseServices;
  late TextEditingController emailFieldController;
  late TextEditingController passwordFieldController;
  late FlutterSecureStorage secureStorage;

  @override
  void initState() {
    firebaseServices = FirebaseServices();
    emailFieldController = TextEditingController();
    passwordFieldController = TextEditingController();
    secureStorage = const FlutterSecureStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets(context).loginBackground),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    color:
                        ApplicationColors(context).whiteBackgroundTransparent,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            Constants.appName,
                            style: TextStyles(context).loginPageHeaderText,
                          ),
                          Text(
                            'Sign in to your account',
                            style: TextStyles(context).loginDescriptionText,
                          ),
                          const SizedBox(height: 20),
                          OutlinedTextBox(
                            labelText: "Email",
                            controller: emailFieldController,
                          ),
                          const SizedBox(height: 10),
                          OutlinedTextBox(
                            controller: passwordFieldController,
                            labelText: "Password",
                            isPassword: true,
                          ),
                          const SizedBox(height: 20),
                          CustomOutlinedButton(
                            label: 'Sign in',
                            onPressed: () async {
                              String txtEmail = emailFieldController.text;
                              String txtPassword = passwordFieldController.text;
                              if (txtPassword.isNotEmpty &&
                                  txtEmail.isNotEmpty) {
                                String message = await onLoginClick(
                                  emailAddress: txtEmail,
                                  password: txtPassword,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      message,
                                      style: TextStyles(context).snackBarText,
                                    ),
                                    duration: const Duration(seconds: 1),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: primaryColor,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Invalid credentials. Please check your username and password and try again',
                                      style: TextStyles(context).snackBarText,
                                    ),
                                    duration: const Duration(seconds: 1),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: primaryColor,
                                  ),
                                );
                              }
                            },
                            isOutlined: false,
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              context.toNamed(ScreenRoutes.toRegisterScreen);
                            },
                            child: const Text(
                              'Not a member? Sign up and get started!',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> onLoginClick({
    required String emailAddress,
    required String password,
  }) async {
    String message = "";
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      message = "Login successful!";

      if (message.isNotEmpty) {
        // save detail model in secure storage.
        firebaseServices.setUserData();

        context.pushReplacementNamed(ScreenRoutes.toHomeScreen);
        // Turn off guest mode
        secureStorage.write(key: "isGuestMode", value: 'false');
        secureStorage.write(key: "isLoggedIn", value: 'true');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      } else {
        message = e.message ?? "invalid credentials";
      }
    }

    return message;
  }
}
