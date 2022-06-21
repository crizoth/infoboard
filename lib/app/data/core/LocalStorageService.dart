import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// abstract class LocalStorage {
//   Future<dynamic> read(String key);
//   Future<dynamic> readAll();
//   Future<void> delete(String key);
//   Future<void> deleteAll();
//   Future<void> save({required String key, required String value});
// }

class LocalStorageService /*implements LocalStorage */ {
  // Create storage
  final storage = FlutterSecureStorage();
  // LocalStorageService(this.storage);

// Delete all
  Future<void> deleteAll() async {
    await storage.deleteAll();
  }

// Delete value
  Future<void> delete(String key) async {
    await storage.delete(key: key);
  }

// Write value
  Future<void> save({required String key, required String value}) async {
    await storage.write(key: key, value: value);
  }

// Read value
  Future<String> read(String key) async {
    String? value = await storage.read(key: key);
    return value!;
  }

// Read all values
  Future<Map<String, dynamic>> readAll() async {
    Map<String, String> allValues = await storage.readAll();
    return allValues;
  }
}
