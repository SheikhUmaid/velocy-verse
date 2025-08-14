import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/components/base/component.custom_app_bar.dart';
import 'package:velocyverse/components/base/component.primary_button.dart';
import 'package:velocyverse/components/user/component.location_input.dart';
import 'package:velocyverse/components/user/component.location_suggestion.dart';
import 'package:velocyverse/providers/user/provider.ride.dart';
import 'package:velocyverse/utils/util.error_toast.dart';
import 'package:velocyverse/utils/util.get_distance_duration.dart';

class ConfirmLocationScreen extends StatefulWidget {
  const ConfirmLocationScreen({super.key});

  @override
  State<ConfirmLocationScreen> createState() => _ConfirmLocationScreenState();
}

class _ConfirmLocationScreenState extends State<ConfirmLocationScreen> {
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropController = TextEditingController();

  List<LocationSuggestion> suggestions = [
    LocationSuggestion(
      name: 'Egmore Railway Station',
      address: 'Gandhi Irwin Road, Egmore, Chennai',
    ),
    LocationSuggestion(
      name: 'Egmore Railway Station',
      address: 'Gandhi Irwin Road, Egmore, Chennai',
    ),
    LocationSuggestion(
      name: 'Egmore Railway Station',
      address: 'Gandhi Irwin Road, Egmore, Chennai',
    ),
    LocationSuggestion(
      name: 'Egmore Railway Station',
      address: 'Gandhi Irwin Road, Egmore, Chennai',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: 'Book a Ride'),
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
                    Expanded(
                      child: ComponentLocationSuggestions(
                        suggestions: suggestions,
                        onSuggestionTap: (suggestion) {
                          // Handle suggestion selection
                          print('Selected: ${suggestion.name}');
                        },
                      ),
                    ),

                    // Confirm Location Button
                    SizedBox(
                      width: double.maxFinite,
                      child: PrimaryButton(
                        text: 'Confirm Location',
                        onPressed: () async {
                          final rideProvider = Provider.of<RideProvider>(
                            context,
                            listen: false,
                          );

                          // Check if locations are null and show fancy toast
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
                            // context.read<LoaderProvider>().showLoader();

                            await getDistanceAndDuration(
                              originLat: rideProvider.fromLocation!.latitude,
                              originLng: rideProvider.fromLocation!.longitude,
                              destLat: rideProvider.toLocation!.latitude,
                              destLng: rideProvider.toLocation!.longitude,
                              context: context,
                            );

                            final response = await rideProvider.confirmRide();

                            if (context.mounted) {
                              // context.read<LoaderProvider>().hideLoader();

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
                            if (context.mounted) {
                              // context.read<LoaderProvider>().hideLoader();
                              showFancyErrorToast(
                                context,
                                "An error occurred: ${e.toString()}",
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
