import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/pages/user_app/ride_share/presentation/my_vehicles_screen.dart';
import 'package:velocyverse/pages/user_app/ride_share/provider/ride_share_provider.dart';

class CreateRideScreen extends StatefulWidget {
  const CreateRideScreen({super.key});

  @override
  State<CreateRideScreen> createState() => _CreateRideScreenState();
}

class _CreateRideScreenState extends State<CreateRideScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<RideShareProvider>(context, listen: false);
      provider.fetchMyVehicles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Create Ride"),
        actions: [
          ElevatedButton.icon(
            icon: Icon(Icons.add_circle_outline_rounded, color: Colors.black),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyVehiclesScreen()),
              );
            },
            label: Text("My Vehicels", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: Column(children: [
        
      ],),
    );
  }
}
