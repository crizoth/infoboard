import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infoboard/app/data/apis/warning/warning_implement_service.dart';
import 'package:infoboard/app/data/apis/warning/warning_model.dart';

abstract class WarningService {
  Future<Map<String, dynamic>> saveWarning(
      {String? teamId, WarningModel? warning});

  Stream<QuerySnapshot<Map<String, dynamic>>> getWarnings({String? teamId});

  Future<void> deleteWarnings(String teamId, String warningId);

  factory WarningService() => WarningImplementService();
}
