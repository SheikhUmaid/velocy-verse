import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:velocyverse/components/base/component.primary_button.dart';
import 'package:velocyverse/utils/svg_image.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Image.asset(
              AppImage.onBoarding.value,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Bottom content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Welcome to VelocyTax",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  "You've successfully registered!",
                  style: TextStyle(color: Color(0xff6F6F6F)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  height: 1,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.black, Colors.white],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('To offer rides as a driver,'),
                    GestureDetector(
                      onTap: () {
                        context.pushNamed('/driverRegisteration');
                      },
                      child: const Text(
                        '\tClick here.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                PrimaryButton(
                  onPressed: () {
                    context.pushNamed('/login');
                  },
                  text: "Get Started",
                  height: 42,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
