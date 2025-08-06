// lib/pages/profile/page.complete_profile.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/components/base/component.custom_app_bar.dart';
import 'package:velocyverse/components/base/component.custom_text_field.dart';
import 'package:velocyverse/components/base/component.file_upload_area.dart';
import 'package:velocyverse/components/base/component.primary_button.dart';
import 'package:velocyverse/components/base/component.profile_avatar.dart';
import 'package:velocyverse/components/login/component.address_type_selector.dart';
import 'package:velocyverse/components/login/component.gender_selector.dart';
import 'package:velocyverse/providers/login/provider.authentication.dart';

class PageCompleteProfile extends StatefulWidget {
  const PageCompleteProfile({super.key});

  @override
  State<PageCompleteProfile> createState() => _PageCompleteProfileState();
}

class _PageCompleteProfileState extends State<PageCompleteProfile> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  String selectedGender = 'male';
  String selectedAddressType = 'permanent';
  File? _pickedImage; // <-- Holds the selected image
  File? _pickedAadhar; // <-- Holds the selected image
  final ImagePicker _picker = ImagePicker(); // <-- Image picker instance

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickAadhar() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _pickedAadhar = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authenticationProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );

    FlutterSecureStorage _storage = FlutterSecureStorage();

    await _storage.read('access')
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: 'Complete Profile'),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      const Text(
                        'One last step to\nfinish',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Ready for booking, one step left',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Profile Avatar
                      Center(
                        child: ComponentProfileAvatar(
                          onTap: _pickImage,
                          image: _pickedImage != null
                              ? Center(child: Image.file(_pickedImage!))
                              : const Center(
                                  child: Icon(
                                    Icons.person_outline,
                                    size: 40,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // User Name Field
                      CustomTextField(
                        controller: usernameController,
                        label: 'User name',
                        placeholder: 'Enter your name',
                      ),
                      const SizedBox(height: 24),

                      // Gender Selector
                      ComponentGenderSelector(
                        selectedGender: selectedGender,
                        onGenderChanged: (gender) {
                          setState(() {
                            selectedGender = gender;
                          });
                        },
                      ),
                      const SizedBox(height: 24),

                      // Address Section
                      const Text(
                        'Address',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'House / Flat / Block No.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: addressController,
                        label: '',
                        placeholder: 'Enter your address',
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        'Area / Location / City',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: cityController,
                        label: '',
                        placeholder: 'Enter your address',
                      ),
                      const SizedBox(height: 32),

                      // Adhar Card Upload
                      const Text(
                        'Adhar Card (Optional)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const ComponentFileUploadArea(),
                      const SizedBox(height: 32),

                      // Address Type Selector
                      ComponentAddressTypeSelector(
                        selectedType: selectedAddressType,
                        onTypeChanged: (type) {
                          setState(() {
                            selectedAddressType = type;
                          });
                        },
                      ),
                      const SizedBox(height: 32),

                      // Finish Button
                      Center(
                        child: PrimaryButton(
                          text: 'Finish',
                          onPressed: () async {
                            final response = await authenticationProvider
                                .profileSetup(
                                  profile: _pickedImage,
                                  aadhar: _pickedAadhar,
                                  addressType: selectedAddressType,
                                  username: usernameController.text,
                                  street: cityController.text,
                                  area: addressController.text,
                                  gender: selectedGender,
                                );

                            if (response) {
                              debugPrint(
                                "--------profile setup---------done---------------------------",
                              );

                              if (context.mounted) {
                                context.goNamed('/onboarding');
                              }
                            } else {
                              debugPrint(
                                "---------profle setup--------somehting went wrong---------------------------",
                              );
                            }
                          },
                        ),
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
    usernameController.dispose();
    addressController.dispose();
    cityController.dispose();
    super.dispose();
  }
}
