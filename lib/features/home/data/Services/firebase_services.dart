// ignore_for_file: avoid_print

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wasteapp/features/home/data/model/detail_model.dart';
import 'package:wasteapp/features/home/data/model/taxi_booking_model.dart';
import 'package:wasteapp/features/home/data/model/user_model.dart';

class FirebaseServices {
  late FlutterSecureStorage secureStorage;

  FirebaseServices() {
    secureStorage = const FlutterSecureStorage();
  }

  String getUserId() {
    if (FirebaseAuth.instance.currentUser != null) {
      return FirebaseAuth.instance.currentUser?.uid ?? "";
    } else {
      return "";
    }
  }

  void setUserData({UserCredential? userCredintials}) async {
    late String uid;

    if (userCredintials != null) {
      uid = userCredintials.user?.uid ?? '';
    } else {
      uid = getUserId();
    }

    // Retrieve user data from Firebase Realtime Database
    UserModel? user = await getUserData(uid);

    if (user != null) {
      // Save user data in secure storage if user data is found
      await secureStorage.write(key: 'uid', value: user.uid);
      await secureStorage.write(
          key: 'username', value: "${user.firstName} ${user.lastName}");
      await secureStorage.write(key: 'country', value: user.country);
      await secureStorage.write(key: 'userEmail', value: user.email);
      await secureStorage.write(key: 'userImageUrl', value: user.imageUrl);

      print('User data saved to secure storage.');
    } else {
      print('User data not found.');
    }
  }

  Future<UserModel?> getUserData(String uid) async {
    try {
      // Reference to the specific user's data in Firebase Realtime Database
      DatabaseReference userRef = FirebaseDatabase.instance.ref('users/$uid');

      // Fetch the user data snapshot
      DatabaseEvent event = await userRef.once();

      if (event.snapshot.value != null) {
        // Convert snapshot to a Map and then to a UserModel
        Map<String, dynamic> userData =
            Map<String, dynamic>.from(event.snapshot.value as Map);
        return UserModel.fromMap(userData);
      } else {
        print('User not found.');
        return null;
      }
    } catch (error) {
      print('Failed to retrieve user data: $error');
      return null;
    }
  }

  Future<void> saveUserData(UserModel user) async {
    try {
      // Reference to the 'users' node in Firebase Realtime Database
      DatabaseReference usersRef =
          FirebaseDatabase.instance.ref('users/${user.uid}');

      // Save user data as a map using the toMap method in UserModel
      await usersRef.set(user.toMap()).then((_) {
        print('User data saved successfully');
      }).catchError((error) {
        print('User data saved faild, ${error.toString()}');
      });
      print('User data saved successfully');
    } catch (error) {
      print('Failed to save user data: $error');
    }
  }

  Future<void> saveBookingData({required TaxiBookingModel bookingModel}) async {
    try {
      var uid = getUserId();
      DatabaseReference ref = FirebaseDatabase.instance.ref('taxi_booking/');
      DatabaseReference newRecordRef =
          ref.push(); // This generates a unique key
      newRecordRef.key!;
      bookingModel.userId = uid;
      // Save user data as a map using the toMap method in UserModel
      await newRecordRef.set(bookingModel.toMap()).then((_) {
        print('User data saved successfully');
      }).catchError((error) {
        print('User data saved faild, ${error.toString()}');
      });
      print('User data saved successfully');
    } catch (error) {
      print('Failed to save user data: $error');
    }
  }

  void toggleIsFavourite(
      {required bool isFavourite,
      required DetailModel detailModel,
      required String collection}) async {
    try {
      DatabaseReference destinationRef = FirebaseDatabase.instance.ref(
          '$collection/${detailModel.id}'); 

      // Update the isFavourite field in Firebase
      await destinationRef.update({
        'isFavourite': isFavourite,
      });
      print('Successfully updated isFavourite field.');
    } catch (e) {
      print('Error updating isFavourite field: $e');
    }
  }

  
  Future<String?> uploadImage(File image) async {
    try {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef =
          FirebaseStorage.instance.ref().child('user_images').child(fileName);

      await storageRef.putFile(image);
      String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  Future<void> uploadItemList(List<DetailModel> items, String path) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref(path); // Firebase path to store items

    // Convert the list of DetailTableModel items into a map
    Map<String, Map<String, dynamic>> itemsMap = {
      for (DetailModel item in items) item.id: item.toJson()
    };

    try {
      // Upload the entire map to Firebase at the given path
      await ref.set(itemsMap);
      print('Items uploaded successfully');
    } catch (error) {
      print('Failed to upload items: $error');
    }
  }

  Future<List<DetailModel>> fetchAllData(
      {required String collectionName}) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref().child(collectionName);

    List<DetailModel> items = [];

    try {
      DatabaseEvent event = await ref.once();

      if (event.snapshot.value != null) {
        if (event.snapshot.value is List) {
          // Case when the data is a list
          List<dynamic> data = event.snapshot.value as List<dynamic>;

          // Convert data to a list of DetailTableModel instances, skipping nulls
          items = data.where((item) => item != null).map((item) {
            Map<String, dynamic> itemData = Map<String, dynamic>.from(item);
            return DetailModel.fromJson(itemData);
          }).toList();
        } else if (event.snapshot.value is Map) {
          // Case when the data is a map
          Map<dynamic, dynamic> data =
              event.snapshot.value as Map<dynamic, dynamic>;

          // Convert data to a list of DetailTableModel instances
          items = data.entries.map((entry) {
            Map<String, dynamic> itemData =
                Map<String, dynamic>.from(entry.value);
            return DetailModel.fromJson(itemData);
          }).toList();
        } else {
          print('Unknown data format');
        }
      } else {
        print('No data available');
      }
    } catch (error) {
      print('Failed to fetch data: $error');
    }

    return items;
  }
}
