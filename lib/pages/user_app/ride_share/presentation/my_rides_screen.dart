import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/pages/user_app/ride_share/presentation/create_ride_screen.dart';
import 'package:velocyverse/pages/user_app/ride_share/presentation/my_vehicles_screen.dart';
import 'package:velocyverse/pages/user_app/ride_share/provider/ride_share_provider.dart';
import 'package:intl/intl.dart';

class MyRidesScreen extends StatefulWidget {
  const MyRidesScreen({super.key});

  @override
  State<MyRidesScreen> createState() => _MyRidesScreenState();
}

class _MyRidesScreenState extends State<MyRidesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<RideShareProvider>(context, listen: false);
      provider.fetchMyRides();
    });
  }

  String formatDate(String? dateStr) {
    if (dateStr == null) return "";
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat("dd MMM yyyy, hh:mm a").format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("My Rides"),
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
                MaterialPageRoute(builder: (context) => CreateRideScreen()),
              );
            },
            label: Text("Create RIde", style: TextStyle(color: Colors.black)),
          ),
        ],
        // actions: [
        //   ElevatedButton(
        //     onPressed: () => Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => const MyVehiclesScreen()),
        //     ),
        //     child: const Text("My Vehicles"),
        //   ),
        // ],
      ),
      body: Consumer<RideShareProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(child: Text("Error: ${provider.error}"));
          }

          final myRides = provider.myRidesResponseModel.data;

          if (myRides.isEmpty) {
            return const Center(child: Text("No Rides found."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: myRides.length,
            itemBuilder: (context, index) {
              final ride = myRides[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      blurRadius: 3,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: const Icon(Icons.directions_car, size: 40),
                  title: Text(
                    ride.modelName ?? "Unknown Model",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Vehicle No: ${ride.vehicleNumber ?? '-'}"),
                      Text("Seats: ${ride.seatCapacity ?? 0}"),
                      Text("Created: ${formatDate(ride.createdAt)}"),
                    ],
                  ),
                  trailing: ride.approved == true
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : const Icon(Icons.pending, color: Colors.orange),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
