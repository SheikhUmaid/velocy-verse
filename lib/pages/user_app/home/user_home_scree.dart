import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:velocyverse/components/base/component.primary_button.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PrimaryButton(
          text: "Book Ride",
          onPressed: () {
            context.pushNamed("/bookRide");
          },
        ),
      ),
    );
  }
}
