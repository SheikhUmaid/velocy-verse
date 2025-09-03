import 'package:flutter/cupertino.dart';

class ResponsiveWraper extends StatelessWidget {
  final Widget child;
  const ResponsiveWraper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 650),
        child: child,
      ),
    );
  }
}

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double maxWidth;

    if (screenWidth >= 1200) {
      maxWidth = 1000; // Desktop
    } else if (screenWidth >= 800) {
      maxWidth = 600; // Tablet
    } else {
      maxWidth = double.infinity; // Mobile
    }

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
