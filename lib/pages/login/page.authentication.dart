import 'package:flutter/material.dart';
import 'package:VelocyTaxzz/pages/login/data.auth_form.dart';
import 'package:VelocyTaxzz/utils/responsive_wrapper.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Velocy")),
      body: ResponsiveWraper(
        child: Column(children: [Expanded(child: AuthForm())]),
      ),
    );
  }
}
