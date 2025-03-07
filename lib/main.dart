import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wasteapp/app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureSecureStorage();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const App());
}

configureSecureStorage() async {
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  if (!await secureStorage.containsKey(key: "isGuestMode")) {
    await secureStorage.write(key: 'isGuestMode', value: 'true');
    await secureStorage.write(key: 'isLoggedIn', value: 'false');
    await secureStorage.write(key: 'uid', value: '');
    await secureStorage.write(key: 'username', value: '');
    await secureStorage.write(key: 'userEmail', value: '');
    await secureStorage.write(key: 'userImageUrl', value: '');
  }
}
