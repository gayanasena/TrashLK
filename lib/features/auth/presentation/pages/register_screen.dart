import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wasteapp/utils/constants.dart';
import 'package:wasteapp/core/resources/colors.dart';
import 'package:wasteapp/core/resources/text_styles.dart';
import 'package:wasteapp/features/common/widgets/outlined_custom_button.dart';
import 'package:wasteapp/features/common/widgets/outlined_text_box.dart';
import 'package:wasteapp/features/home/data/Services/firebase_services.dart';
import 'package:wasteapp/features/home/data/model/user_model.dart';
import 'package:wasteapp/utils/assets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late FirebaseServices firebaseServices;
  late TextEditingController firstNameTextEditingController;
  late TextEditingController lastNameTextEditingController;
  late TextEditingController emailTextEditingController;
  late TextEditingController passwordTextEditingController;
  late TextEditingController cityTextEditingController;
  String uid = "";
  File? _imageFile;
  String? _uploadedImageUrl;

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    firebaseServices = FirebaseServices();
    firstNameTextEditingController = TextEditingController();
    lastNameTextEditingController = TextEditingController();
    emailTextEditingController = TextEditingController();
    passwordTextEditingController = TextEditingController();
    cityTextEditingController = TextEditingController();
    super.initState();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
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
              child: Card(
                color: ApplicationColors(context).whiteBackgroundTransparent,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Constants.appName,
                          style: TextStyles(context).loginPageHeaderText,
                        ),
                        Text(
                          'Create a new account',
                          style: TextStyles(context).loginDescriptionText,
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey[300],
                            backgroundImage:
                                _imageFile != null
                                    ? FileImage(_imageFile!)
                                    : null,
                            child:
                                _imageFile == null
                                    ? const Icon(Icons.add_a_photo)
                                    : null,
                          ),
                        ),
                        const SizedBox(height: 10),
                        OutlinedTextBox(
                          labelText: "First Name",
                          controller: firstNameTextEditingController,
                          validator:
                              (value) =>
                                  value!.isEmpty
                                      ? 'First name is required'
                                      : null,
                        ),
                        const SizedBox(height: 10),
                        OutlinedTextBox(
                          labelText: "Last Name",
                          controller: lastNameTextEditingController,
                          validator:
                              (value) =>
                                  value!.isEmpty
                                      ? 'Last name is required'
                                      : null,
                        ),
                        const SizedBox(height: 10),
                        OutlinedTextBox(
                          labelText: "City",
                          controller: cityTextEditingController,
                          validator:
                              (value) =>
                                  value!.isEmpty ? 'City is required' : null,
                        ),
                        const SizedBox(height: 10),
                        OutlinedTextBox(
                          labelText: "Email",
                          controller: emailTextEditingController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email is required';
                            } else if (!RegExp(
                              r'^[^@]+@[^@]+\.[^@]+',
                            ).hasMatch(value)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        OutlinedTextBox(
                          labelText: "Password",
                          isPassword: true,
                          controller: passwordTextEditingController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password is required';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomOutlinedButton(
                          label: 'Sign Up',
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              String email = emailTextEditingController.text;
                              String password =
                                  passwordTextEditingController.text;
                              onSignUpClick(
                                emailAddress: email,
                                password: password,
                              );
                            }
                          },
                          isOutlined: false,
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Already have an account? Sign In'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onSignUpClick({
    required String emailAddress,
    required String password,
  }) async {
    String message;
    bool isSuccess = false;

    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      if (cred.user != null) {
        uid = cred.user?.uid ?? "";

        if (_imageFile != null) {
          await firebaseServices.uploadImage(_imageFile!);
        }

        saveUserData(
          uid: uid,
          firstName: firstNameTextEditingController.text,
          lastName: lastNameTextEditingController.text,
          email: emailTextEditingController.text,
          city: cityTextEditingController.text,
          imageUrl:
              _uploadedImageUrl ?? 'https://picsum.photos/300/200?random=5',
        );
      }

      message =
          "Welcome! Your account has been successfully created. Please login";
      isSuccess = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else {
        message = e.message ?? "An error occurred, please try again.";
      }
    } catch (_) {
      message = "An error occurred, please try again.";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );

    if (isSuccess) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context); // Navigate to home screen
      });
    }
  }

  void saveUserData({
    required String uid,
    required String firstName,
    required String lastName,
    required String email,
    required String city,
    required String imageUrl,
  }) async {
    await firebaseServices.saveUserData(
      UserModel(
        uid: uid,
        firstName: firstName,
        lastName: lastName,
        city: city,
        email: email,
        imageUrl: imageUrl,
      ),
    );
  }
}
