import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:velocyverse/components/base/component.primary_button.dart';
import 'package:velocyverse/utils/svg_image.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AppImage.onBoarding.value, fit: BoxFit.cover),
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to VelocyTax",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "You've successfully registered!",
                      style: TextStyle(color: const Color(0xff6F6F6F)),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.black, Colors.white],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('To offer rides as a driver,'),
                        GestureDetector(
                          onTap: () {
                            context.pushNamed('/driverRegisteration');
                          },
                          child: Text(
                            '\tClick here.',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 26),
                    PrimaryButton(
                      onPressed: () {
                        context.pushNamed('/login');
                      },
                      text: "Get Started",
                      height: 42,
                      width: 132,
                    ),
                    SizedBox(height: 26),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// ElevatedButton(
//               onPressed: () {
//                 context.pushNamed('/driverRegisteration');
//               },
//               child: Text("Driver"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 context.pushNamed('/login');
//               },
//               child: Text("GetStarted"),
//             ),