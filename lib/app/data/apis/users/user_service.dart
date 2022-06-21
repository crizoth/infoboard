import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infoboard/app/data/apis/users/user_implement_service.dart';
import 'package:infoboard/app/data/apis/users/user_model.dart';
import 'package:infoboard/app/modules/home/home_page.dart';

abstract class UserService {
  Future<void> saveUser(UserModel user);

  Future<void> updateUser(UserModel user);

  Future<QuerySnapshot<Map<String, dynamic>>> searchUser(String userName);

  Future<QuerySnapshot<Map<String, dynamic>>> searchTeam(String teamName);

  factory UserService() => UserImplementService();
}
