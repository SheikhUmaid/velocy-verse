import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:velocyverse/components/base/component.custom_app_bar.dart';
import 'package:velocyverse/components/base/component.primary_button.dart';
import 'package:velocyverse/components/user/component.location_input.dart';
import 'package:velocyverse/components/user/component.location_suggestion.dart';

class BookRide extends StatefulWidget {
  const BookRide({super.key});

  @override
  State<BookRide> createState() => _BookRideState();
}

class _BookRideState extends State<BookRide> {
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
                    ComponentLocationInput(
                      pickupController: pickupController,
                      dropController: dropController,
                    ),

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
                        onPressed: () {
                          // Handle location confirmation
                          print('Location confirmed');
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
