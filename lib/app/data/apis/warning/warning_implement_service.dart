import 'package:infoboard/app/data/apis/warning/warning_model.dart';
import 'package:infoboard/app/data/apis/warning/warning_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infoboard/app/data/apis/warning/warning_model.dart';
import 'package:infoboard/app/data/core/AppInfo.dart';

class WarningImplementService implements WarningService {
  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getWarnings({String? teamId}) {
    //get chat data
    final snapshots = AppInfo.firestore
        .collection('teams')
        .doc(teamId)
        .collection('warnings')
        .orderBy('fromDate', descending: false)
        .snapshots();

    return snapshots;
  }

  @override
  Future<Map<String, dynamic>> saveWarning(
      {String? teamId, WarningModel? warning}) async {
    Map<String, dynamic> warningToFirebase = warning!.toMap();
    final docRef = await AppInfo.firestore
        .collection('teams')
        .doc(teamId)
        .collection('warnings')
        .add(warningToFirebase);

    final doc = await docRef.get();
    return doc.data()!;
  }

  @override
  Future<void> deleteWarnings(String teamId, String warningId) async {
    await AppInfo.firestore
        .collection('teams')
        .doc(teamId)
        .collection('warnings')
        .doc(warningId)
        .delete();
  }
}
