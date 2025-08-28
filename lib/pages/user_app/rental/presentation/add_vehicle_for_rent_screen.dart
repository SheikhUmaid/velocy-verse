import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:VelocyTaxzz/components/base/component.primary_button.dart';
import 'package:VelocyTaxzz/pages/user_app/rental/presentation/edit_your_vehicle_screen.dart';
import 'package:VelocyTaxzz/pages/user_app/rental/provider/rental_provider.dart';
import 'package:VelocyTaxzz/utils/responsive_wraper.dart';
import 'package:VelocyTaxzz/utils/util.error_toast.dart';
import 'package:VelocyTaxzz/utils/util.success_toast.dart';

class AddVehicleForRentScreen extends StatefulWidget {
  const AddVehicleForRentScreen({super.key});

  @override
  State<AddVehicleForRentScreen> createState() =>
      _AddVehicleForRentScreenState();
}

class _AddVehicleForRentScreenState extends State<AddVehicleForRentScreen> {
  final _vehicleNameController = TextEditingController();
  final _registrationController = TextEditingController();
  final _rentalPriceController = TextEditingController();
  final _securityDepositController = TextEditingController();
  final _pickupLocationController = TextEditingController();
  final _vehicleColorController = TextEditingController();

  String? _selectedVehicleType;
  int? _seatingCapacity;
  int? _bagCapacity;
  String? _fuelType;
  String? _transmission;
  bool _isAc = false;
  bool _isAvailable = true;

  List<XFile> _newImages = [];
  XFile? _vehicleDocument;

  DateTime? _availableFrom;
  DateTime? _availableTo;

  Future<void> _pickDate(BuildContext context, bool isFrom) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _availableFrom = picked;
        } else {
          _availableTo = picked;
        }
      });
    }
  }

  // Future<void> _pickVehicleDocument() async {
  //   final picker = ImagePicker();
  //   final picked = await picker.pickImage(source: ImageSource.gallery);
  //   if (picked != null) {
  //     setState(() {
  //       _vehicleDocument = picked;
  //     });
  //   }
  // }
  Future<void> _pickVehicleDocument() async {
    var mediaStatus = await Permission.photos.request();
    // For Android below 13, use Permission.storage instead
    if (mediaStatus.isDenied) {
      mediaStatus = await Permission.storage.request();
    }

    if (mediaStatus.isGranted) {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          _vehicleDocument = picked;
        });
      }
    } else if (mediaStatus.isDenied) {
      Fluttertoast.showToast(
        msg: "Oops We can not procced without permission!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else if (mediaStatus.isPermanentlyDenied) {
      openAppSettings(); // from permission_handler
    }
  }

  Future<void> _pickImages() async {
    var mediaStatus = await Permission.photos.request();
    // For Android below 13, use Permission.storage instead
    if (mediaStatus.isDenied) {
      mediaStatus = await Permission.storage.request();
    }

    if (mediaStatus.isGranted) {
      final picker = ImagePicker();
      final picked = await picker.pickMultiImage();
      if (picked != null && picked.isNotEmpty) {
        setState(() {
          _newImages.addAll(picked);
        });
      }
    } else if (mediaStatus.isDenied) {
      Fluttertoast.showToast(
        msg: "Oops We can not procced without permission!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else if (mediaStatus.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Vehicle")),
      body: ResponsiveWraper(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              Text("Upload Vehicle Photos"),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _newImages.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  if (index < _newImages.length) {
                    final img = _newImages[index];
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(img.path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () =>
                                setState(() => _newImages.removeAt(index)),
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Add button
                    return InkWell(
                      onTap: _pickImages,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: const Icon(Icons.add),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              Text("Upload Vehicle Document"),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickVehicleDocument,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _vehicleDocument != null
                      ? Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(_vehicleDocument!.path),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _vehicleDocument = null;
                                  });
                                },
                              ),
                            ),
                          ],
                        )
                      : const Center(
                          child: Icon(
                            Icons.upload_file,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              buildTextField("Vehicle Name", _vehicleNameController),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTitleText("Available From"),
                        InkWell(
                          onTap: () => _pickDate(context, true),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black45),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              _availableFrom != null
                                  ? _availableFrom!.toIso8601String().substring(
                                      0,
                                      10,
                                    )
                                  : "Select Date",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTitleText("Available To"),
                        InkWell(
                          onTap: () => _pickDate(context, false),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black45),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              _availableTo != null
                                  ? _availableTo!.toIso8601String().substring(
                                      0,
                                      10,
                                    )
                                  : "Select Date",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Vehicle Type
              buildTitleText("Vehicle Type"),
              DropdownButtonFormField<String>(
                value: _selectedVehicleType,
                items: ["SUV", "Sedan", "Hatchback"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedVehicleType = v),
                decoration: InputDecoration(
                  // labelText: "Vehicle Type",
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black45, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTitleText("Fuel Type"),
                        DropdownButtonFormField<String>(
                          value: _fuelType,
                          items: ["Petrol", "Diesel", "Hybrid", "Electric"]
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _fuelType = v),
                          decoration: InputDecoration(
                            // labelText: "Fuel Type",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black45,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.black45,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTitleText("Transmission"),
                        DropdownButtonFormField<String>(
                          value: _transmission,
                          items: ["Manual", "Automatic"]
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _transmission = v),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black45,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.black45,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),
              buildTextField("Vehicle Color", _vehicleColorController),

              const SizedBox(height: 12),

              // Registration Number
              buildTextField("Registration Number", _registrationController),
              const SizedBox(height: 12),
              buildTextField(
                "Security Deposit",
                _securityDepositController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              buildTextField("Pickup Location", _pickupLocationController),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTitleText("Seating Capacity"),
                        DropdownButtonFormField<int>(
                          value: _seatingCapacity,
                          items: [2, 4, 5, 7]
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.toString()),
                                ),
                              )
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _seatingCapacity = v),

                          decoration: InputDecoration(
                            // labelText: "Seating Capacity",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black45,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.black45,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTitleText("Bag Capacity"),
                        DropdownButtonFormField<int>(
                          value: _bagCapacity,
                          items: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.toString()),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _bagCapacity = v),
                          decoration: InputDecoration(
                            // labelText: "Bag Capacity",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black45,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.black45,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildTitleText("AC"),
                  const SizedBox(width: 5),
                  Switch(
                    activeColor: Colors.black,
                    value: _isAc,
                    onChanged: (v) => setState(() => _isAc = v),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Rental Price
              buildTextField(
                "Rental Price per Day",
                _rentalPriceController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),

              // Availability
              buildTitleText("Availability"),
              DropdownButtonFormField<bool>(
                value: _isAvailable,

                items: const [
                  DropdownMenuItem(value: true, child: Text("Available")),
                  DropdownMenuItem(value: false, child: Text("Not Available")),
                ],
                onChanged: (v) => setState(() => _isAvailable = v ?? true),
                decoration: InputDecoration(
                  // labelText: "Available or Not",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black45, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: PrimaryButton(
          text: "Add Vehicle",
          onPressed: () => _submitAddVehicle(context),
        ),
      ),
    );
  }

  void _submitAddVehicle(BuildContext context) async {
    if (_vehicleNameController.text.isEmpty ||
        _selectedVehicleType == null ||
        _registrationController.text.isEmpty ||
        _seatingCapacity == null ||
        _bagCapacity == null ||
        _fuelType == null ||
        _transmission == null ||
        _securityDepositController.text.isEmpty ||
        _rentalPriceController.text.isEmpty ||
        _availableFrom == null ||
        _availableTo == null ||
        _pickupLocationController.text.isEmpty ||
        _vehicleColorController.text.isEmpty ||
        _newImages.isEmpty ||
        _vehicleDocument == null) {
      showFancyMessageToast(
        context,
        "Please fill all fields and upload images/documents",
      );

      return;
    }

    final provider = Provider.of<RentalProvider>(context, listen: false);

    await provider.addVehicleForRental(
      vehicleName: _vehicleNameController.text,
      vehicleType: _selectedVehicleType!,
      registrationNumber: _registrationController.text,
      seatCapacity: _seatingCapacity!,
      bagCapcity: _bagCapacity!,
      fuelType: _fuelType!,
      transmission: _transmission!,
      securityDeposit: _securityDepositController.text,
      rentalPricePerHour: _rentalPriceController.text,
      availableFrom: _availableFrom!,
      availableTo: _availableTo!,
      pickupLocation: _pickupLocationController.text,
      vehicleColor: _vehicleColorController.text,
      isAc: _isAc,
      isAvailable: _isAvailable,
      vehicleImages: _newImages.map((x) => File(x.path)).toList(),
      vehiclePaper: File(_vehicleDocument!.path),
    );

    if (provider.addSuccess) {
      showFancySuccessToast(context, "Vehicle added successfully!");
      Navigator.pop(context);
      await Provider.of<RentalProvider>(context, listen: false).fetchVehicles();
    } else if (provider.addError != null) {
      showFancyErrorToast(context, "Failed to Add Vehicle\nTry again");
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(SnackBar(content: Text(provider.addError!)));
    }
  }
}
