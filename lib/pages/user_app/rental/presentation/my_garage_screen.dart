import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/components/base/component.primary_button.dart';
import 'package:velocyverse/pages/user_app/rental/presentation/add_vehicle_for_rent_screen.dart';
import 'package:velocyverse/pages/user_app/rental/presentation/edit_your_vehicle_screen.dart';
import 'package:velocyverse/pages/user_app/rental/provider/rental_provider.dart';

class MyGarageScreen extends StatefulWidget {
  const MyGarageScreen({super.key});

  @override
  State<MyGarageScreen> createState() => _MyGarageScreenState();
}

class _MyGarageScreenState extends State<MyGarageScreen> {
  int? _deletingVehicleId;
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

          return RefreshIndicator(
            onRefresh: () async {
              await provider.fetchVehicles();
            },
            child: ListView.builder(
              itemCount: provider.vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = provider.vehicles[index];
                final isDeleting = _deletingVehicleId == vehicle.id;
                return InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditYourVehicleScreen(vehicleId: vehicle.id!),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.grey, blurRadius: 0.5),
                      ],
                    ),
                    margin: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        ListTile(
                          leading: vehicle.images.isNotEmpty
                              ? Image.network(
                                  vehicle.images.first,
                                  width: 60,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.directions_car),
                          title: Text(vehicle.vehicleName ?? 'Unnamed'),
                          subtitle: Text(vehicle.registrationNumber ?? ''),
                          trailing: PopupMenuButton<String>(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            onSelected: (value) {
                              if (value == 'edit') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditYourVehicleScreen(
                                      vehicleId: vehicle.id!,
                                    ),
                                  ),
                                );
                              } else if (value == 'delete') {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.white,
                                      title: Text("Delete Vehicle"),
                                      content: Text(
                                        "Are you sure you want to delete this vehicle?",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            setState(() {
                                              _deletingVehicleId = vehicle.id;
                                            });

                                            await provider.deleteMyVehicle(
                                              vehicle.id!,
                                            );
                                            await provider.fetchVehicles();

                                            setState(() {
                                              _deletingVehicleId = null;
                                            });

                                            Navigator.pop(context);

                                            if (provider.error == null) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    "Vehicle Deleted successfully",
                                                  ),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Error: ${provider.error}",
                                                  ),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          },
                                          child: isDeleting
                                              ? SizedBox(
                                                  width: 18,
                                                  height: 18,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                )
                                              : Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'edit',
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 7,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.edit_rounded,
                                        size: 18,
                                        color: Colors.black54,
                                      ),
                                      SizedBox(width: 6),
                                      Text('Edit'),
                                    ],
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 7,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade100,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.delete_rounded,
                                        size: 18,
                                        color: Colors.redAccent,
                                      ),
                                      SizedBox(width: 6),
                                      Text('Delete'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: PrimaryButton(
                                  onPressed: () async {
                                    final provider =
                                        Provider.of<RentalProvider>(
                                          context,
                                          listen: false,
                                        );

                                    await provider.toggleAvailability(
                                      vehicle.id!,
                                    );

                                    if (provider.isSuccess) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Availability updated successfully",
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );

                                      // Refresh the list to show updated availability
                                      await provider.fetchVehicles();
                                    } else if (provider.sendError != null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Error: ${provider.sendError}",
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                  text: "Available",
                                  textColor: vehicle.isAvailable == true
                                      ? Colors.white
                                      : Colors.black,
                                  backgroundColor: vehicle.isAvailable == true
                                      ? Colors.black
                                      : Colors.grey.shade200,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: PrimaryButton(
                                  onPressed: () async {
                                    final provider =
                                        Provider.of<RentalProvider>(
                                          context,
                                          listen: false,
                                        );

                                    await provider.toggleAvailability(
                                      vehicle.id!,
                                    );

                                    if (provider.isSuccess) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Availability updated successfully",
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );

                                      // Refresh the list to show updated availability
                                      await provider.fetchVehicles();
                                    } else if (provider.sendError != null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Error: ${provider.sendError}",
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                  text: "Unavailable",
                                  textColor: vehicle.isAvailable == true
                                      ? Colors.black
                                      : Colors.white,
                                  backgroundColor: vehicle.isAvailable == true
                                      ? Colors.grey.shade200
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: PrimaryButton(
          text: "Add Vehicle",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddVehicleForRentScreen(),
              ),
            );
          },
        ),
      ),
    );
  }
}
