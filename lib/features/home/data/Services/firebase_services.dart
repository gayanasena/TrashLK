// ignore_for_file: avoid_print

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wasteapp/features/home/data/model/accounts_model.dart';
import 'package:wasteapp/features/home/data/model/bins_model.dart';
import 'package:wasteapp/features/home/data/model/detail_model.dart';
import 'package:wasteapp/features/home/data/model/user_model.dart';
import 'package:wasteapp/utils/constants.dart';
import 'package:intl/intl.dart';

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
        key: 'username',
        value: "${user.firstName} ${user.lastName}",
      );
      await secureStorage.write(key: 'city', value: user.city);
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
      DatabaseReference userRef = FirebaseDatabase.instance.ref(
        '${DBConstants.usersCollection}/$uid',
      );

      // Fetch the user data snapshot
      DatabaseEvent event = await userRef.once();

      if (event.snapshot.value != null) {
        // Convert snapshot to a Map and then to a UserModel
        Map<String, dynamic> userData = Map<String, dynamic>.from(
          event.snapshot.value as Map,
        );
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

  Future<Account?> getUserAccountsData(String uid) async {
    try {
      // Reference to the specific user's data in Firebase Realtime Database
      DatabaseReference userRef = FirebaseDatabase.instance.ref(
        '${DBConstants.accountsCollection}/$uid/0',
      );

      // Fetch the user data snapshot
      DatabaseEvent event = await userRef.once();

      if (event.snapshot.value != null) {
        // Convert snapshot to a Map and then to a UserModel
        Map<String, dynamic> data = Map<String, dynamic>.from(
          event.snapshot.value as Map,
        );
        return Account.fromMap(data);
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
      DatabaseReference usersRef = FirebaseDatabase.instance.ref(
        'users/${user.uid}',
      );

      // Save user data as a map using the toMap method in UserModel
      await usersRef
          .set(user.toMap())
          .then((_) {
            print('User data saved successfully');
          })
          .catchError((error) {
            print('User data saved faild, ${error.toString()}');
          });
      print('User data saved successfully');
    } catch (error) {
      print('Failed to save user data: $error');
    }
  }

  Future<void> saveData({
    required dynamic model,
    required String collectionName,
  }) async {
    try {
      var uid = getUserId();
      DatabaseReference ref = FirebaseDatabase.instance.ref('$collectionName/');
      DatabaseReference newRecordRef =
          ref.push(); // This generates a unique key
      newRecordRef.key!;
      model.userId = uid;

      await newRecordRef
          .set(model.toMap())
          .then((_) {
            print('Data saved successfully');
          })
          .catchError((error) {
            print('Data saved faild, ${error.toString()}');
          });
      print('Data saved successfully');
    } catch (error) {
      print('Failed to save data: $error');
    }
  }

  Future<bool> qrScanUpdate(String qrCode, Bin binModel) async {
    DateTime now = DateTime.now();
    String uid = getUserId();

    String title = "";
    double price = 0.0;
    String dateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(now) +
        DateFormat('a').format(now);

    // Set title
    if (binModel.type == "master") {
      title = "Master bin accessed";
      price = 150.00;
    } else {
      title = "User managed bin accessed";
      price = 200.00;
    }

    CommonDetailModel model = CommonDetailModel(
      id: "",
      title: title,
      BUId: binModel.ownerId,
      category: "Debited",
      description: "Successfully accessed the bin.",
      imageUrls: [],
      isFlag: false,
      location: binModel.location,
      notes: dateTime,
      percentage: 0.0,
      price: price.toString(),
      subLocation: "",
      uId: uid,
      url_1: "",
      url_2: "",
    );
    try {
      // Add payment record
      await savePaymentData(model);

      // Update account
      updateAccounts(uid, price);

      // Open bin
      updateBinIsOpen(binModel.reference, true);

      return true;
    } catch (e) {
      print(e);
    }

    return false;
  }

  Future<void> savePaymentData(CommonDetailModel model) async {
    try {
      DatabaseReference paymentRef =
          FirebaseDatabase.instance
              .ref(DBConstants.paymentsRecordsCollection)
              .push(); 

      await paymentRef
          .set(model.toJson())
          .then((_) {
            print('Payment data saved successfully');
          })
          .catchError((error) {
            print('Payment data save failed: ${error.toString()}');
          });
    } catch (error) {
      print('Failed to save payment data: $error');
    }
  }

  void updateAccounts(String uid, double price) async {
    final accountRef = FirebaseDatabase.instance.ref().child(
      '${DBConstants.accountsCollection}/$uid/0',
    );

    try {
      final snapshot = await accountRef.get();

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);

        // Get old values
        int oldBalance = data['currentBalance'] ?? 0;
        int oldDue = data['dueAmount'] ?? 0;

        // Add to old values
        int newBalance = oldBalance + price.round();
        int newDue = newBalance - oldDue;

        // Update Firebase
        await accountRef.update({
          'currentBalance': newBalance,
          'dueAmount': newDue,
        });
      } else {
        print('Account does not exist');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateBinIsOpen(String binId, bool newStatus) async {
    final binRef = FirebaseDatabase.instance.ref().child('bins/$binId');

    try {
      await binRef.update({'isOpen': newStatus});

      print('isOpen updated to $newStatus for $binId');
    } catch (e) {
      print('Error updating isOpen: $e');
    }
  }

  Future<String?> uploadImage(File image) async {
    try {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child(fileName);

      await storageRef.putFile(image);
      String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  Future<void> uploadItemList(
    List<CommonDetailModel> items,
    String collectionName,
  ) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(
      collectionName,
    ); // Firebase path to store items

    // Convert the list of DetailTableModel items into a map
    Map<String, Map<String, dynamic>> itemsMap = {
      for (CommonDetailModel item in items) item.id: item.toJson(),
    };

    try {
      // Upload the entire map to Firebase at the given path
      await ref.set(itemsMap);
      print('Items uploaded successfully');
    } catch (error) {
      print('Failed to upload items: $error');
    }
  }

  Future<void> uploadBinList(List<Bin> items, String collectionName) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(
      collectionName,
    ); // Firebase path to store items

    // Convert the list of DetailTableModel items into a map
    Map<String, Map<String, dynamic>> itemsMap = {
      for (Bin item in items) item.reference: item.toMap(),
    };

    try {
      // Upload the entire map to Firebase at the given path
      await ref.set(itemsMap);
      print('Items uploaded successfully');
    } catch (error) {
      print('Failed to upload items: $error');
    }
  }

  Future<List<CommonDetailModel>> fetchAllData({
    required String collectionName,
  }) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child(
      collectionName,
    );

    List<CommonDetailModel> items = [];

    try {
      DatabaseEvent event = await ref.once();

      if (event.snapshot.value != null) {
        if (event.snapshot.value is List) {
          // Case when the data is a list
          List<dynamic> data = event.snapshot.value as List<dynamic>;

          // Convert data to a list of DetailTableModel instances, skipping nulls
          items =
              data.where((item) => item != null).map((item) {
                Map<String, dynamic> itemData = Map<String, dynamic>.from(item);
                return CommonDetailModel.fromJson(itemData);
              }).toList();
        } else if (event.snapshot.value is Map) {
          // Case when the data is a map
          Map<dynamic, dynamic> data =
              event.snapshot.value as Map<dynamic, dynamic>;

          // Convert data to a list of DetailTableModel instances
          items =
              data.entries.map((entry) {
                Map<String, dynamic> itemData = Map<String, dynamic>.from(
                  entry.value,
                );
                return CommonDetailModel.fromJson(itemData);
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

  Future<List<Bin>> fetchAllBins() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child(
      DBConstants.binsCollection,
    );

    List<Bin> items = [];

    try {
      DatabaseEvent event = await ref.once();

      if (event.snapshot.value != null) {
        if (event.snapshot.value is List) {
          // Case when the data is a list
          List<dynamic> data = event.snapshot.value as List<dynamic>;

          // Convert data to a list of DetailTableModel instances, skipping nulls
          items =
              data.where((item) => item != null).map((item) {
                Map<String, dynamic> itemData = Map<String, dynamic>.from(item);
                return Bin.fromMap(itemData);
              }).toList();
        } else if (event.snapshot.value is Map) {
          // Case when the data is a map
          Map<dynamic, dynamic> data =
              event.snapshot.value as Map<dynamic, dynamic>;

          // Convert data to a list of Bin instances
          items =
              data.entries.map((entry) {
                Map<String, dynamic> itemData = Map<String, dynamic>.from(
                  entry.value,
                );
                return Bin.fromMap(itemData);
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
