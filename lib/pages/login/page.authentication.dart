import 'package:flutter/material.dart';
import 'package:velocyverse/components/base/component.custom_app_bar.dart';
import 'package:velocyverse/pages/login/data.auth_form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Velocy")),
      body: Column(children: [Expanded(child: AuthForm())]),
    );
  }
}
