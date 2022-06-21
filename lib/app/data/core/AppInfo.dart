import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:infoboard/app/data/apis/users/user_model.dart';
import 'package:infoboard/app/data/apis/users/user_service.dart';
import 'package:infoboard/app/data/core/LocalStorageService.dart';

class AppInfo {
  static UserModel authUser = UserModel();
  static FirebaseApp? firebaseApp;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<void> initialize() async {
    var userRef = await LocalStorageService().read('user');
    if (userRef != null) {
      authUser = UserModel.fromJson(source: userRef);
    } else
      return;
  }
}
