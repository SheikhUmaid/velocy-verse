import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<bool> isDriver() async {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final token = await storage.read(key: 'role');
  return token == 'driver';
}
