import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<bool> isLoggedin() async {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final token = await storage.read(key: 'access_token');
  if (token == null) {
    // Token not found
    print("User not logged in");
    return false;
  } else {
    print("Token: $token");
    // Token found
    return true;
  }
}
