import 'package:flutter/material.dart';

class StylishTextField extends StatelessWidget {
  const StylishTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          cursorColor: Colors.deepPurple,
          style: TextStyle(fontSize: 16, color: Colors.black87),
          decoration: InputDecoration(
            icon: Padding(padding: EdgeInsetsGeometry.all(1)),
            hintText: "9898123234",
            hintStyle: TextStyle(color: Colors.grey[500]),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
