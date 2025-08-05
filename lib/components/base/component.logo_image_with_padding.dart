import 'package:flutter/material.dart';

class LogoImageWithPadding extends StatelessWidget {
  const LogoImageWithPadding({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset("assets/images/logo.png"),
    );
  }
}
