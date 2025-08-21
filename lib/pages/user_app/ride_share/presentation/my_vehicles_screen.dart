import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/pages/user_app/ride_share/presentation/add_ride_share_vehicle_screen.dart';
import 'package:velocyverse/pages/user_app/ride_share/provider/ride_share_provider.dart';
import 'package:velocyverse/utils/util.error_toast.dart';

class MyVehiclesScreen extends StatefulWidget {
  const MyVehiclesScreen({super.key});

  @override
  State<MyVehiclesScreen> createState() => _MyVehiclesScreenState();
}

class _MyVehiclesScreenState extends State<MyVehiclesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<RideShareProvider>(context, listen: false);
      provider.fetchMyVehicles();
    });
  }

  void openImage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          backgroundColor: Colors.black,
          body: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Center(
              child: InteractiveViewer(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const CircularProgressIndicator(color: Colors.white);
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.error, color: Colors.red, size: 48),
                        SizedBox(height: 8),
                        Text(
                          "Failed to load image",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Vehicles")),
      body: Consumer<RideShareProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text("Error: ${provider.error}"));
          }

          final myVehilces = provider.myVehiclesResponseModel.data;

          if (myVehilces.isEmpty) {
            return const Center(child: Text("No vehicels found."));
          }

          return RefreshIndicator(
            onRefresh: () => Provider.of<RideShareProvider>(
              context,
              listen: false,
            ).fetchMyVehicles(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: myVehilces.length,
              itemBuilder: (context, index) {
                final vehicle = myVehilces[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 15),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade500,
                        blurRadius: 0.6,
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black38),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  vehicle.approved == true
                                      ? "✅ Approved"
                                      : "⌛Wating for Approval",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: const Icon(
                          Icons.directions_car_rounded,
                          size: 35,
                          color: Colors.black,
                        ),
                        title: Text(
                          vehicle.modelName ?? "Unknown Model",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(vehicle.vehicleNumber ?? "-"),
                        trailing: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(4),
                          child: FittedBox(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  (vehicle.seatCapacity ?? 0).toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const Text(
                                  "Seats",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: vehicle.aadharCard != null
                                ? () => openImage(vehicle.aadharCard!)
                                : () => showFancyMessageToast(
                                    context,
                                    "Aadhar Card image not uploaded",
                                  ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              child: Text(
                                "Aadhar Card",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: vehicle.drivingLicense != null
                                ? () => openImage(vehicle.drivingLicense!)
                                : () => showFancyMessageToast(
                                    context,
                                    "Driving Licence image not uploaded",
                                  ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              child: Text(
                                "Driving Licence",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: vehicle.registrationDoc != null
                                ? () => openImage(vehicle.registrationDoc!)
                                : () => showFancyMessageToast(
                                    context,
                                    "Registration Document not uploaded",
                                  ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              child: Text(
                                "Registration Doc",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddRideShareVehicleScreen(),
            ),
          );
        },
        child: Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }
}
