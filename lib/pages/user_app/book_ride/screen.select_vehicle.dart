import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/components/base/component.custom_app_bar.dart';
import 'package:velocyverse/components/base/component.primary_button.dart';
import 'package:velocyverse/components/user/component.location_input.dart';
import 'package:velocyverse/components/user/component.price_input_filed.dart';
import 'package:velocyverse/components/user/component.vehcle_selector.dart';
import 'package:velocyverse/providers/user/provider.ride.dart';

class SelectVehicleScreen extends StatefulWidget {
  const SelectVehicleScreen({super.key});

  @override
  State<SelectVehicleScreen> createState() => _SelectVehicleScreenState();
}

class _SelectVehicleScreenState extends State<SelectVehicleScreen> {
  final TextEditingController pickupController = TextEditingController(
    text: 'Shollinganallur, Chennai',
  );
  final TextEditingController dropController = TextEditingController(
    text: 'Navalur, Chennai',
  );
  final TextEditingController priceController = TextEditingController();

  String selectedVehicle = 'bike'; // bike, car, auto
  bool womenOnly = false;

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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Map placeholder
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F4F8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                      ),
                      const SizedBox(height: 24),

                      AbsorbPointer(child: ComponentLocationInput()),

                      // Location inputs
                      const SizedBox(height: 16),

                      // Add stop button
                      GestureDetector(
                        onTap: () {
                          // Handle add stop
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.add, color: Color(0xFF3B82F6), size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Add stop',
                              style: TextStyle(
                                color: Color(0xFF3B82F6),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Vehicle selector
                      const Text(
                        'Choose Vehicle Type',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      VehicleSelector(
                        selectedVehicle: selectedVehicle,
                        onVehicleSelected: (vehicle) {
                          selectedVehicle = vehicle;
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 24),

                      // Estimate price
                      Consumer<RideProvider>(
                        builder: (_, prov, __) {
                          return Text(
                            'Estimate Price : ${prov.estimatedPrice}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Price input
                      PriceInputField(
                        controller: priceController,
                        onPriceSet: () {
                          // Handle price set
                          print('Price set: ${priceController.text}');
                        },
                      ),
                      const SizedBox(height: 24),

                      // Women only checkbox
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => womenOnly = !womenOnly),
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: womenOnly
                                    ? const Color(0xFF3B82F6)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: womenOnly
                                      ? const Color(0xFF3B82F6)
                                      : const Color(0xFFD1D5DB),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: womenOnly
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 14,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Women only',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          const Spacer(),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.info_outline,
                              color: Color(0xFF6B7280),
                              size: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Request ride button
                      PrimaryButton(
                        text: 'Request ba Ride',
                        onPressed: () async {
                          final rideProvider = Provider.of<RideProvider>(
                            context,
                            listen: false,
                          );
                          final response = await rideProvider.ridePatchBooking(
                            womenOnly: womenOnly,
                            offeredPrice: priceController.text,
                          );
                          if (response) {
                            context.pushNamed('/waitingForDriver');
                          }
                        },
                      ),
                    ],
                  ),
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
    priceController.dispose();
    super.dispose();
  }
}
