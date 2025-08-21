import 'package:flutter/material.dart';

class AddFavLocationScreen extends StatefulWidget {
  const AddFavLocationScreen({super.key});

  @override
  State<AddFavLocationScreen> createState() => _AddFavLocationScreenState();
}

class _AddFavLocationScreenState extends State<AddFavLocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favorite Locations"), elevation: 0),
      // body,
    );
  }
}
