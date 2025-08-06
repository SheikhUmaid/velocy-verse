import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/pages/user_app/rental/provider/rental_provider.dart';

class RentalScreen extends StatelessWidget {
  const RentalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Garage")),
      body: Consumer<RentalProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text('Error: ${provider.error}'));
          }

          if (provider.vehicles.isEmpty) {
            return const Center(child: Text("No vehicles found."));
          }

          return ListView.builder(
            itemCount: provider.vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = provider.vehicles[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: vehicle.images.isNotEmpty
                      ? Image.network(
                          vehicle.images.first,
                          width: 60,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.directions_car),
                  title: Text(vehicle.vehicleName ?? 'Unnamed'),
                  subtitle: Text(vehicle.registrationNumber ?? ''),
                  trailing: Icon(
                    vehicle.isApproved == true
                        ? Icons.check_circle
                        : Icons.hourglass_top,
                    color: vehicle.isApproved == true
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
