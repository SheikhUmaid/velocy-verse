// screens/host_rides_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/components/base/component.custom_app_bar.dart';
import 'package:velocyverse/components/base/component.custom_text_field.dart';
import 'package:velocyverse/components/base/component.primary_button.dart';
import 'package:velocyverse/components/user/component.vehcle_selector.dart';
import 'package:velocyverse/providers/login/provider.authentication.dart';
import 'package:velocyverse/providers/provider.loader.dart';
import 'package:velocyverse/providers/user/provider.ride.dart';

class DriverRegisterationScreen extends StatefulWidget {
  const DriverRegisterationScreen({super.key});

  @override
  State<DriverRegisterationScreen> createState() =>
      DriverRegisterationScreenState();
}

class DriverRegisterationScreenState extends State<DriverRegisterationScreen> {
  final TextEditingController vehicleNumberController = TextEditingController();
  final TextEditingController vehicleCompanyController =
      TextEditingController();
  final TextEditingController vehicleModelController = TextEditingController();
  final TextEditingController vehicleTypeController = TextEditingController(
    text: "Two Wheeler",
  );
  final TextEditingController yearController = TextEditingController();

  String selectedVehicle = 'Two Wheeler';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: 'Velocy'),
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
                      // Header section
                      const Text(
                        'Ready to host rides',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Provide your vehicle information to host rides.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Profile photo section
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE5E7EB),
                                ),
                              ),
                              child: const Icon(
                                Icons.person_outline,
                                size: 48,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFFE5E7EB),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.upload_outlined,
                                  size: 16,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Vehicle Number field
                      CustomTextField(
                        controller: vehicleNumberController,
                        label: 'Vehicle Number',
                        placeholder: 'Enter vehicle number',
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 24),

                      // Vehicle selector
                      const Text(
                        'Choose Vehicle Type',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      VehicleSelector(
                        selectedVehicle: selectedVehicle,
                        onVehicleSelected: (vehicle) {
                          setState(() {
                            selectedVehicle = vehicle;
                            // Update vehicle type based on selection
                            switch (vehicle) {
                              case 'Two Wheeler':
                                vehicleTypeController.text = 'Two Wheeler';
                                break;
                              case 'Three Wheeler':
                                vehicleTypeController.text = 'Three Wheeler';
                                break;
                              case 'Four Wheeler':
                                vehicleTypeController.text = 'Four Wheeler';
                                break;
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 24),

                      // Vehicle Type field
                      CustomTextField(
                        controller: vehicleCompanyController,
                        label: 'Vehicle Company',
                        placeholder: 'Enter vehicle type',
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 24),

                      // Year field
                      CustomTextField(
                        controller: vehicleModelController,
                        label: 'Vechicle Model',
                        placeholder: 'Enter Model',
                        keyboardType: TextInputType.text,
                      ),

                      const SizedBox(height: 24),
                      CustomTextField(
                        controller: yearController,
                        label: 'Year',
                        placeholder: 'Enter year',
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 40),

                      // Next button
                      PrimaryButton(
                        text: 'Next',
                        onPressed: () async {
                          context.read<LoaderProvider>().showLoader();
                          final rideProvder =
                              Provider.of<AuthenticationProvider>(
                                context,
                                listen: false,
                              );
                          final response = await rideProvder
                              .driverRegisteration(
                                vehicleNumber: vehicleNumberController.text,
                                vehicleType: vehicleTypeController.text,
                                vehicleCompany: vehicleCompanyController.text,
                                vehicleModel: vehicleModelController.text,
                                passingYear: yearController.text,
                              );

                          context.read<LoaderProvider>().hideLoader();
                          if (context.mounted) {
                            if (response) {
                              context.pushNamed('/documentVerification');
                            }
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
    vehicleNumberController.dispose();
    vehicleTypeController.dispose();
    yearController.dispose();
    super.dispose();
  }
}
