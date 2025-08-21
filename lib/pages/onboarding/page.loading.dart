import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocyverse/providers/user/provider.ride.dart';
import 'package:velocyverse/providers/user/provider.rider_profile.dart';
import 'package:velocyverse/utils/util.active_ride_setter.dart';
import 'package:velocyverse/utils/util.is_driver.dart';
import 'package:velocyverse/utils/util.is_logged_in.dart';
import 'package:velocyverse/utils/util.ride_persistor.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    bool loggedIn = await isLoggedin();

    if (!loggedIn) {
      context.goNamed("/permissions");
      return;
    }

    if (await isDriver()) {
      context.goNamed('/driverMain');
      return;
    }

    // Check active ride
    final activeRide = await activeRideGetter();
    if (activeRide == null) {
      context.goNamed("/userHome");
      return;
    }

    // Restore ride state from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final rideProvider = Provider.of<RideProvider>(context, listen: false);
    RidePersistor.load(rideProvider);

    rideProvider.activeId = prefs.getInt("ride_id");
    final level = prefs.getString("level");

    if (level != null) {
      context.goNamed(level);
    } else {
      // fallback if level is missing
      context.goNamed("/userHome");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Velocy",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 140,
              child: LinearProgressIndicator(
                color: Colors.black,
                backgroundColor: Colors.black12,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          textAlign: TextAlign.center,
          "Made in India",
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
