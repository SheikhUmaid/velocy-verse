import 'package:flutter/material.dart';

class PageDot extends StatelessWidget {
  PageDot({super.key, this.isActive = false});
  bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: 10,
        width: isActive ? 50 : 10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: isActive ? Colors.green : Colors.green.withAlpha(100),
        ),
      ),
    );
  }
}
