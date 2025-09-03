import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:VelocyTaxzz/components/base/component.custom_app_bar.dart';
import 'package:VelocyTaxzz/components/base/component.custom_text_field.dart';
import 'package:VelocyTaxzz/components/base/component.primary_button.dart';
import 'package:VelocyTaxzz/components/driver/component.dropdown.dart';
import 'package:VelocyTaxzz/components/driver/component.file_upload.dart';
import 'package:VelocyTaxzz/providers/login/provider.authentication.dart';
import 'package:VelocyTaxzz/providers/provider.loader.dart';

class DocumentVerificationScreen extends StatefulWidget {
  final String vehicleNumber;

  const DocumentVerificationScreen({
    super.key,
    this.vehicleNumber = 'TN 01 A 0000',
  });

  @override
  State<DocumentVerificationScreen> createState() =>
      _DocumentVerificationScreenState();
}

class _DocumentVerificationScreenState
    extends State<DocumentVerificationScreen> {
  final TextEditingController plateNumberController = TextEditingController();
  String selectedVehicleType = '';

  String? registrationFile;
  String? licenseFile;
  String? insuranceFile;

  File? _registrationFile;
  File? _licenseFile;
  File? _insuranceFile;

  final List<String> vehicleTypes = [
    'Select vehicle type',
    'Two Wheeler',
    'Three Wheeler',
    'Four Wheeler',
  ];

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
                      const Text(
                        'Document Verification',
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
                      const SizedBox(height: 24),

                      Text(
                        'Verify Documents for ${widget.vehicleNumber}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 24),

                      DropdownField(
                        label: 'Vehicle Type',
                        value: selectedVehicleType.isEmpty
                            ? vehicleTypes[0]
                            : selectedVehicleType,
                        items: vehicleTypes,
                        onChanged: (value) {
                          setState(() {
                            selectedVehicleType = value ?? '';
                          });
                        },
                      ),
                      const SizedBox(height: 24),

                      CustomTextField(
                        controller: plateNumberController,
                        label: 'License Plate Number',
                        placeholder: 'Enter plate number',
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 24),

                      FileUploadWidget(
                        label: 'Vehicle Registration',
                        fileName: registrationFile,
                        icon: Icons.upload_file,
                        uploadText: 'Upload registration document',
                        subtitle: 'PDF, JPG or PNG (max. 5MB)',
                        onFileSelected: (file) {
                          setState(() {
                            _registrationFile = file;
                            registrationFile = file.path.split('/').last;
                          });
                        },
                      ),
                      const SizedBox(height: 24),

                      FileUploadWidget(
                        label: 'Driver\'s License',
                        fileName: licenseFile,
                        icon: Icons.credit_card,
                        uploadText: 'Upload driver\'s license',
                        subtitle: 'PDF, JPG or PNG (max. 5MB)',
                        onFileSelected: (file) {
                          setState(() {
                            _licenseFile = file;
                            licenseFile = file.path.split('/').last;
                          });
                        },
                      ),
                      const SizedBox(height: 24),

                      FileUploadWidget(
                        label: 'Vehicle Insurance',
                        fileName: insuranceFile,
                        icon: Icons.description,
                        uploadText: 'Upload insurance document',
                        subtitle: 'PDF, JPG or PNG (max. 5MB)',
                        onFileSelected: (file) {
                          setState(() {
                            _insuranceFile = file;
                            insuranceFile = file.path.split('/').last;
                          });
                        },
                      ),
                      const SizedBox(height: 40),

                      PrimaryButton(
                        text: 'Finish',
                        onPressed: _canFinish()
                            ? () async {
                                context.read<LoaderProvider>().showLoader();
                                final authProvider =
                                    Provider.of<AuthenticationProvider>(
                                      context,
                                      listen: false,
                                    );
                                final response = await authProvider
                                    .documentUpload(
                                      licensePlateNumber:
                                          plateNumberController.text,
                                      vehicleType: selectedVehicleType,
                                      vehicleRegistrationDoc: _registrationFile,
                                      driverLicense: _licenseFile,
                                      vehicleInsurance: _insuranceFile,
                                    );

                                context.read<LoaderProvider>().hideLoader();
                                if (response) {
                                  FlutterSecureStorage secureStorage =
                                      FlutterSecureStorage();
                                  await secureStorage.write(
                                    key: "role",
                                    value: 'driver',
                                  );
                                  context.pushNamed('/driverMain');
                                }
                              }
                            : null,
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

  bool _canFinish() {
    return selectedVehicleType.isNotEmpty &&
        selectedVehicleType != 'Select vehicle type' &&
        plateNumberController.text.isNotEmpty &&
        _registrationFile != null &&
        _licenseFile != null &&
        _insuranceFile != null;
  }

  @override
  void dispose() {
    plateNumberController.dispose();
    super.dispose();
  }
}
