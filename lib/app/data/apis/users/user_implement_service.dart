import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infoboard/app/data/apis/users/user_model.dart';
import 'package:infoboard/app/data/apis/users/user_service.dart';
import 'package:infoboard/app/data/core/AppInfo.dart';

class UserImplementService implements UserService {
  @override
  Future<void> saveUser(UserModel user) {
    try {
      return AppInfo.firestore.collection("users").add(user.toMap());
    } catch (error) {
      throw (error);
    }
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> searchUser(String userName) {
    try {
      return AppInfo.firestore
          .collection("users")
          .where('name', isEqualTo: userName)
          .get();
    } catch (error) {
      throw (error);
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> searchTeam(String teamName) {
    try {
      return AppInfo.firestore
          .collection("teams")
          .where('name', isEqualTo: teamName)
          .get();
    } catch (error) {
      throw (error);
    }
  }

  @override
  Future<void> updateUser(UserModel user) {
    try {
      return AppInfo.firestore
          .collection("users")
          .doc(user.id)
          .update(user.toMap());
    } catch (error) {
      throw (error);
    }
  }
}
