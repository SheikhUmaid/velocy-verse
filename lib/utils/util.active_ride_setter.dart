import 'package:shared_preferences/shared_preferences.dart';

Future<void> activeRideSetter({
  required bool is_any,
  required String level,
  int? rideId,
}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("is_any", is_any);
  prefs.setString("level", level);
  prefs.setInt("ride_id", rideId!);
}

Future<int?> activeRideGetter() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final isAny = prefs.getInt("ride_id");
  return isAny;
}

Future<void> activeRideClearer() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("is_any");
  await prefs.remove("level");
  await prefs.remove("ride_id");
}
