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
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    bool loggedIn = await isLoggedin();
    print("is log in = ${loggedIn}");
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
