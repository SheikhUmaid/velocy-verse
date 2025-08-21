import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/components/base/component.custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:velocyverse/components/base/component.primary_button.dart';
import 'package:velocyverse/pages/user_app/ride_share/provider/ride_share_provider.dart';
import 'package:velocyverse/utils/util.error_toast.dart';
import 'package:velocyverse/utils/util.success_toast.dart';

class AddRideShareVehicleScreen extends StatefulWidget {
  const AddRideShareVehicleScreen({super.key});

  @override
  State<AddRideShareVehicleScreen> createState() =>
      _AddRideShareVehicleScreenState();
}

class _AddRideShareVehicleScreenState extends State<AddRideShareVehicleScreen> {
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();

  int? _seatCapacity;
  File? _aadharImage;
  File? _licenseImage;
  File? _registrationImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(Function(File) onSelected) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      onSelected(File(picked.path));
    }
  }

  Widget _buildImagePicker(String label, File? imageFile, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100,
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: imageFile != null
            ? Image.file(imageFile, fit: BoxFit.cover)
            : Center(
                child: Text(label, style: const TextStyle(color: Colors.grey)),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Vehicle")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              label: "Model Name",
              placeholder: "Enter model name",
              controller: _modelController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _vehicleNumberController,
              label: "Vehicle Number",
              placeholder: "Enter Vehicle Number",
            ),
            const SizedBox(height: 16),
            Text(
              "Seat Capacity",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<int>(
              value: _seatCapacity,
              items: List.generate(
                10,
                (index) => DropdownMenuItem(
                  value: index + 1,
                  child: Text('${index + 1} Seats'),
                ),
              ),
              onChanged: (val) {
                setState(() {
                  _seatCapacity = val;
                });
              },
              decoration: InputDecoration(
                hintText: "Seat Capacity",
                hintStyle: TextStyle(color: Colors.grey.shade200, fontSize: 16),
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.black, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildImagePicker("Aadhar Card", _aadharImage, () {
              _pickImage((file) => setState(() => _aadharImage = file));
            }),
            const SizedBox(height: 12),
            _buildImagePicker("Driving License", _licenseImage, () {
              _pickImage((file) => setState(() => _licenseImage = file));
            }),
            const SizedBox(height: 12),
            _buildImagePicker("Registration Document", _registrationImage, () {
              _pickImage((file) => setState(() => _registrationImage = file));
            }),

            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Your vehicle will be reviewd before it appears for ride sharing",
              style: TextStyle(color: Colors.black45),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            PrimaryButton(
              width: double.infinity,
              text: "Submit",
              onPressed: () async {
                if (_modelController.text.isEmpty ||
                    _vehicleNumberController.text.isEmpty ||
                    _seatCapacity == null ||
                    _aadharImage == null ||
                    _licenseImage == null ||
                    _registrationImage == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please fill all fields & upload docs"),
                    ),
                  );
                  return;
                }

                final provider = Provider.of<RideShareProvider>(
                  context,
                  listen: false,
                );

                await provider.addVehicleRequest(
                  vehicleNumber: _vehicleNumberController.text.trim(),
                  modelName: _modelController.text.trim(),
                  seatCapacity: _seatCapacity!,
                  aadharCard: _aadharImage!,
                  drivingLicense: _licenseImage!,
                  registrationDoc: _registrationImage!,
                );

                if (provider.error != null) {
                  showFancyErrorToast(context, "Failed to Add Vehicle");
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text("Error: ${provider.error}")),
                  // );
                  print(provider.error);
                } else {
                  showFancySuccessToast(context, "Vehicle added successfully!");
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(content: Text("Vehicle added successfully!")),
                  // );
                  Navigator.pop(context);
                  Provider.of<RideShareProvider>(
                    context,
                    listen: false,
                  ).fetchMyVehicles();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
