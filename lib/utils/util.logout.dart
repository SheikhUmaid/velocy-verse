import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void logout() {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  storage.delete(key: "access");
  storage.delete(key: "refresh");
  storage.deleteAll();
  return;
}
