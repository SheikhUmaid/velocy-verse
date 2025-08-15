import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:velocyverse/utils/util.is_driver.dart';
import 'package:velocyverse/utils/util.is_logged_in.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    _startLoadingAnimation();
  }

  void _startLoadingAnimation() {
    const duration = Duration(seconds: 2); // Changed to 2 seconds
    const steps = 100;
    final interval = duration.inMilliseconds ~/ steps;

    Timer.periodic(Duration(milliseconds: interval), (timer) {
      setState(() {
        _progressValue += 1 / steps;
        if (_progressValue >= 1.0) {
          timer.cancel();
          checkLoginStatus();
          // Get.offAllNamed(Routes.permissionPage.value);
        }
      });
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   checkLoginStatus();
  // }

  void checkLoginStatus() async {
    bool loggedIn = await isLoggedin();

    if (context.mounted) {
      if (loggedIn) {
        if (await isDriver()) {
          context.goNamed('/driverMain');
        } else {
          context.goNamed("/userHome");
        }
      } else {
        context.goNamed("/permissions");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            const SizedBox(height: 8),
            Container(
              width: 194,
              height: 7,
              decoration: BoxDecoration(
                color: Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _progressValue,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF393939),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Text(
        textAlign: TextAlign.center,
        "Made in India",
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
