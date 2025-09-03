import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:VelocyTaxzz/components/base/component.primary_button.dart';
import 'package:VelocyTaxzz/components/user/component.location_input.dart';
import 'package:VelocyTaxzz/providers/user/provider.ride.dart';
import 'package:VelocyTaxzz/utils/util.error_toast.dart';
import 'package:VelocyTaxzz/utils/util.get_distance_duration.dart';

class ConfirmLocationScreen extends StatefulWidget {
  const ConfirmLocationScreen({super.key});

  @override
  State<ConfirmLocationScreen> createState() => _ConfirmLocationScreenState();
}

class _ConfirmLocationScreenState extends State<ConfirmLocationScreen> {
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropController = TextEditingController();
  DateTime? scheduledDateTime; // new field

  @override
  Widget build(BuildContext context) {
    final rideProvider = Provider.of<RideProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text("Book Ride")),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // const CustomAppBar(title: 'Book a Ride'),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Location Input Section
                    ComponentLocationInput(),

                    // Location Suggestions

                    // Date & Time Picker (only if scheduled ride)
                    if (rideProvider.rideType == 'scheduled')
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 30),
                              ),
                            );
                            if (date != null) {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (time != null) {
                                setState(() {
                                  scheduledDateTime = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    time.hour,
                                    time.minute,
                                  );
                                });
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  scheduledDateTime != null
                                      ? "${scheduledDateTime!.day}/${scheduledDateTime!.month}/${scheduledDateTime!.year} "
                                            "${scheduledDateTime!.hour}:${scheduledDateTime!.minute.toString().padLeft(2, '0')}"
                                      : "Select Date & Time",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const Icon(
                                  Icons.calendar_today,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    // Confirm Location Button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 8),
        child: PrimaryButton(
          text: 'Confirm Location',
          onPressed: () async {
            // ensure date/time is picked for scheduled rides
            if (rideProvider.rideType == 'scheduled' &&
                scheduledDateTime == null) {
              showFancyErrorToast(
                context,
                "Please select a date and time for your scheduled ride",
              );
              return;
            }

            if (rideProvider.fromLocation == null ||
                rideProvider.toLocation == null) {
              showFancyErrorToast(
                context,
                rideProvider.fromLocation == null &&
                        rideProvider.toLocation == null
                    ? "Please select pickup and drop-off locations"
                    : rideProvider.fromLocation == null
                    ? "Please select pickup location"
                    : "Please select drop-off location",
              );
              return;
            }

            try {
              await getDistanceAndDuration(
                originLat: rideProvider.fromLocation!.latitude,
                originLng: rideProvider.fromLocation!.longitude,
                destLat: rideProvider.toLocation!.latitude,
                destLng: rideProvider.toLocation!.longitude,
                context: context,
              );

              final response = await rideProvider.confirmRide(
                scheduledTime: scheduledDateTime,
              );

              if (context.mounted) {
                if (response) {
                  context.pushNamed('/selectVehicle');
                } else {
                  showFancyErrorToast(
                    context,
                    "Failed to confirm ride. Please try again.",
                  );
                }
              }
            } catch (e) {
              // rethrow;
              if (context.mounted) {
                showFancyErrorToast(
                  context,
                  "An error occurred: ${e.toString()}",
                );
              }
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    pickupController.dispose();
    dropController.dispose();
    super.dispose();
  }
}
