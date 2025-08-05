import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void logout(context) {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  storage.delete(key: "access_token");
  storage.delete(key: "refresh_token");
  storage.deleteAll();
  return;
}
