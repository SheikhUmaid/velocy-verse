import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.pushNamed('/driverRegisteration');
              },
              child: Text("Driver"),
            ),
            ElevatedButton(
              onPressed: () {
                context.pushNamed('/login');
              },
              child: Text("GetStarted"),
            ),
          ],
        ),
      ),
    );
  }
}
