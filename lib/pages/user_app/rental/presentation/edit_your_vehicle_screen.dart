import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/components/base/component.primary_button.dart';
import 'package:velocyverse/pages/user_app/rental/provider/rental_provider.dart';

class EditYourVehicleScreen extends StatefulWidget {
  final int vehicleId;
  const EditYourVehicleScreen({super.key, required this.vehicleId});

  @override
  State<EditYourVehicleScreen> createState() => _EditYourVehicleScreenState();
}

class _EditYourVehicleScreenState extends State<EditYourVehicleScreen> {
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

  // List<XFile> _newImages = [];
  // List<String> _existingImages = [];
  // XFile? _vehicleDocument;
  // String? _existingDocumentUrl;
  List<XFile> _newImages = [];
  List<String> _existingImages = []; // Changed to store URLs
  List<String> _deletedImageUrls = []; // Track deleted existing images
  XFile? _vehicleDocument;
  String? _existingDocumentUrl;

  DateTime? _availableFrom;
  DateTime? _availableTo;

  @override
  void initState() {
    super.initState();
    _loadVehicleDetails();
  }

  void _removeExistingImage(int index) {
    setState(() {
      // Add to deleted images before removing
      _deletedImageUrls.add(_existingImages[index]);
      _existingImages.removeAt(index);
    });
  }

  Future<void> _loadVehicleDetails() async {
    final provider = Provider.of<RentalProvider>(context, listen: false);
    await provider.fetchMyVehicleDetails(widget.vehicleId);

    if (provider.myVehicleDetail != null) {
      final vehicle = provider.myVehicleDetail!;
      setState(() {
        _vehicleNameController.text = vehicle.vehicleName ?? '';
        _selectedVehicleType = vehicle.vehicleType;
        _registrationController.text = vehicle.registrationNumber ?? '';
        _seatingCapacity = vehicle.seatingCapacity;
        _bagCapacity = vehicle.bagCapacity;
        _fuelType = vehicle.fuelType;
        _transmission = vehicle.transmission;
        _securityDepositController.text = vehicle.securityDeposite ?? '';
        _rentalPriceController.text = vehicle.rentalPricePerHour ?? '';
        _availableFrom = vehicle.availableFromDate;
        _availableTo = vehicle.availableToDate;
        _pickupLocationController.text = vehicle.pickupLocation ?? '';
        _vehicleColorController.text = vehicle.vehicleColor ?? '';
        _isAc = vehicle.isAc ?? false;
        _isAvailable = vehicle.isAvailable ?? false;
        // _existingImages = vehicle.images;
        _existingDocumentUrl = vehicle.vehiclePapersDocument;
      });
    }
  }

  Future<void> _pickDate(BuildContext context, bool isFrom) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? _availableFrom ?? now : _availableTo ?? now,
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

  Future<void> _pickVehicleDocument() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _vehicleDocument = picked;
      });
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked != null && picked.isNotEmpty) {
      setState(() {
        _newImages.addAll(picked);
      });
    }
  }

  // void _removeExistingImage(int index) {
  //   setState(() {
  //     _existingImages.removeAt(index);
  //   });
  // }

  void _submitEditVehicle(BuildContext context) async {
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
        _vehicleColorController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    final provider = Provider.of<RentalProvider>(context, listen: false);

    await provider.editVehicle(
      vehicleId: widget.vehicleId,
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
      vehicleImages: _newImages.isNotEmpty
          ? _newImages.map((x) => File(x.path)).toList()
          : null,
      vehiclePaper: _vehicleDocument != null
          ? File(_vehicleDocument!.path)
          : null,
      deletedImages: _existingImages,
    );

    if (provider.editSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vehicle updated successfully!")),
      );
      Navigator.pop(context);
    } else if (provider.editError != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(provider.editError!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RentalProvider>(context);
    if (provider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final vehicle = provider.myVehicleDetail;
    final String ip = "http://82.25.104.152/";

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Your Vehicle")),
      body: vehicle == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Upload Vehicle Photos
                  Text("Upload Vehicle Photos"),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _existingImages.length + _newImages.length + 1,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1,
                        ),
                    itemBuilder: (context, index) {
                      if (index < _existingImages.length) {
                        final imgUrl = _existingImages[index];
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                imgUrl,
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
                                onPressed: () => _removeExistingImage(index),
                              ),
                            ),
                          ],
                        );
                      } else if (index <
                          _existingImages.length + _newImages.length) {
                        final img = _newImages[index - _existingImages.length];
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
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                                onPressed: () => setState(
                                  () => _newImages.removeAt(
                                    index - _existingImages.length,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
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

                  const SizedBox(height: 8),
                  const Text("Vehicle Document"),
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
                                    onPressed: () =>
                                        setState(() => _vehicleDocument = null),
                                  ),
                                ),
                              ],
                            )
                          : _existingDocumentUrl != null
                          ? Image.network(
                              "$ip${_existingDocumentUrl!}",
                              fit: BoxFit.cover,
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
                  const SizedBox(height: 16),

                  // Vehicle Name
                  buildTextField("Vehicle Name", _vehicleNameController),
                  const SizedBox(height: 12),

                  Row(
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
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  _availableFrom != null
                                      ? _availableFrom!
                                            .toIso8601String()
                                            .substring(0, 10)
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
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  _availableTo != null
                                      ? _availableTo!
                                            .toIso8601String()
                                            .substring(0, 10)
                                      : "Select Date",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
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
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) => setState(() => _fuelType = v),
                              decoration: InputDecoration(
                                // labelText: "Fuel Type",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2,
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
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _transmission = v),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                // labelText: "Transmission",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  buildTextField("Vehicle Color", _vehicleColorController),

                  const SizedBox(height: 12),

                  // Registration Number
                  buildTextField(
                    "Registration Number",
                    _registrationController,
                  ),
                  const SizedBox(height: 12),
                  buildTextField(
                    "Security Deposit",
                    _securityDepositController,
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
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2,
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
                              onChanged: (v) =>
                                  setState(() => _bagCapacity = v),
                              decoration: InputDecoration(
                                // labelText: "Bag Capacity",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 12),

                  buildTitleText("AC"),
                  Switch(
                    value: _isAc,
                    onChanged: (v) => setState(() => _isAc = v),
                  ),
                  const SizedBox(height: 12),

                  // Rental Price
                  buildTextField(
                    "Rental Price per Day",
                    _rentalPriceController,
                  ),
                  const SizedBox(height: 12),

                  // Availability
                  buildTitleText("Availability"),
                  DropdownButtonFormField<bool>(
                    value: _isAvailable,

                    items: const [
                      DropdownMenuItem(value: true, child: Text("Available")),
                      DropdownMenuItem(
                        value: false,
                        child: Text("Not Available"),
                      ),
                    ],
                    onChanged: (v) => setState(() => _isAvailable = v ?? true),
                    decoration: InputDecoration(
                      // labelText: "Available or Not",
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: provider.isEditing
            ? const CircularProgressIndicator()
            : PrimaryButton(
                text: "Update Vehicle",
                onPressed: () => _submitEditVehicle(context),
              ),
      ),
    );
  }
}

Widget buildTitleText(String title) {
  return Text(title, style: TextStyle(color: Colors.grey, fontSize: 12));
}

Widget buildTextField(String labelTExt, TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(labelTExt, style: TextStyle(color: Colors.grey, fontSize: 12)),
      TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "Enter $labelTExt",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
        ),
      ),
    ],
  );
}

// class _EditYourVehicleScreenState extends State<EditYourVehicleScreen> {
//   final _nameController = TextEditingController();
//   final _registrationController = TextEditingController();
//   final _rentalPriceController = TextEditingController();
//   final _securityDepositController = TextEditingController();
//   final _pickupLocationController = TextEditingController();
//   final _vehicleColorController = TextEditingController();

//   DateTime? _availableFrom;
//   DateTime? _availableTo;

//   String? _selectedVehicleType;
//   int? _seatingCapacity;
//   int? _bagCapacity;
//   String? _fuelType;
//   String? _transmission;
//   bool _isAc = false;
//   bool _isAvailable = true;

//   List<XFile> _newImages = [];
//   List<int> _removedImageIds = [];
//   XFile? _vehicleDocument;
//   int? _existingDocumentId;

//   Future<void> _pickImages() async {
//     final picker = ImagePicker();
//     final picked = await picker.pickMultiImage();
//     if (picked != null && picked.isNotEmpty) {
//       setState(() {
//         _newImages.addAll(picked);
//       });
//     }
//   }

//   void _removeExistingImage(int imageId) {
//     setState(() {
//       _removedImageIds.add(imageId);
//     });
//   }

//   void _removeNewImage(int index) {
//     setState(() {
//       _newImages.removeAt(index);
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() async {
//       final provider = Provider.of<RentalProvider>(context, listen: false);
//       await provider.fetchMyVehicleDetails(widget.vehicleId);
//       final details = provider.myVehicleDetail;
//       if (details != null) {
//         _nameController.text = details.vehicleName ?? '';
//         _registrationController.text = details.registrationNumber ?? '';
//         _rentalPriceController.text = details.rentalPricePerHour ?? '';
//         _selectedVehicleType = details.vehicleType;
//         _seatingCapacity = details.seatingCapacity;
//         _bagCapacity = details.bagCapacity;
//         _fuelType = details.fuelType;
//         _transmission = details.transmission;
//         _isAc = details.isAc ?? false;
//         _isAvailable = details.isAvailable ?? true;
//         _securityDepositController.text = details.securityDeposite ?? "0";
//         _pickupLocationController.text = details.pickupLocation ?? "";
//         _vehicleColorController.text = details.vehicleColor ?? "";
//         setState(() {});
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<RentalProvider>(context);
//     final vehicle = provider.myVehicleDetail;
//     final String ip = "http://82.25.104.152/";

//     return Scaffold(
//       appBar: AppBar(title: const Text("Edit Your Vehicle")),
//       body: vehicle == null
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Upload Vehicle Photos
//                   Text("Upload Vehicle Photos"),
//                   const SizedBox(height: 8),
//                   GridView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount:
//                         vehicle.images
//                             .where((img) => !_removedImageIds.contains(img.id))
//                             .length +
//                         _newImages.length +
//                         1,
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           crossAxisSpacing: 8,
//                           mainAxisSpacing: 8,
//                           childAspectRatio: 1,
//                         ),
//                     itemBuilder: (context, index) {
//                       final existingImages = vehicle.images
//                           .where((img) => !_removedImageIds.contains(img.id))
//                           .toList();
//                       if (index < existingImages.length) {
//                         final img = existingImages[index];
//                         return Stack(
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: Image.network(
//                                 "$ip${img.image}",
//                                 fit: BoxFit.cover,
//                                 width: double.infinity,
//                                 height: double.infinity,
//                               ),
//                             ),
//                             Positioned(
//                               right: 0,
//                               top: 0,
//                               child: IconButton(
//                                 icon: const Icon(
//                                   Icons.close,
//                                   color: Colors.red,
//                                 ),
//                                 onPressed: () => _removeExistingImage(img.id!),
//                               ),
//                             ),
//                           ],
//                         );
//                       } else if (index <
//                           existingImages.length + _newImages.length) {
//                         final imgIndex = index - existingImages.length;
//                         final img = _newImages[imgIndex];
//                         return Stack(
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: Image.file(
//                                 File(img.path),
//                                 fit: BoxFit.cover,
//                                 width: double.infinity,
//                                 height: double.infinity,
//                               ),
//                             ),
//                             Positioned(
//                               right: 0,
//                               top: 0,
//                               child: IconButton(
//                                 icon: const Icon(
//                                   Icons.close,
//                                   color: Colors.red,
//                                 ),
//                                 onPressed: () => _removeNewImage(imgIndex),
//                               ),
//                             ),
//                           ],
//                         );
//                       } else {
//                         // Add button
//                         return InkWell(
//                           onTap: _pickImages,
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               border: Border.all(color: Colors.grey),
//                             ),
//                             child: const Icon(Icons.add),
//                           ),
//                         );
//                       }
//                     },
//                   ),

//                   const SizedBox(height: 16),

//                   // Vehicle Name
//                   buildTextField("Vehicle Name", _nameController),
//                   const SizedBox(height: 12),

//                   // Vehicle Type
//                   buildTitleText("Vehicle Type"),
//                   DropdownButtonFormField<String>(
//                     value: _selectedVehicleType,
//                     items: ["SUV", "Sedan", "Hatchback"]
//                         .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                         .toList(),
//                     onChanged: (v) => setState(() => _selectedVehicleType = v),
//                     decoration: InputDecoration(
//                       // labelText: "Vehicle Type",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(color: Colors.black, width: 1),
//                       ),
//                       contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(color: Colors.black, width: 1),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(color: Colors.black, width: 2),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             buildTitleText("Fuel Type"),
//                             DropdownButtonFormField<String>(
//                               value: _fuelType,
//                               items: ["Petrol", "Diesel", "Hybrid", "Electric"]
//                                   .map(
//                                     (e) => DropdownMenuItem(
//                                       value: e,
//                                       child: Text(e),
//                                     ),
//                                   )
//                                   .toList(),
//                               onChanged: (v) => setState(() => _fuelType = v),
//                               decoration: InputDecoration(
//                                 // labelText: "Fuel Type",
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide(
//                                     color: Colors.black,
//                                     width: 1,
//                                   ),
//                                 ),
//                                 contentPadding: EdgeInsets.symmetric(
//                                   horizontal: 10,
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide(
//                                     color: Colors.black,
//                                     width: 1,
//                                   ),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide(
//                                     color: Colors.black,
//                                     width: 2,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             buildTitleText("Transmission"),
//                             DropdownButtonFormField<String>(
//                               value: _transmission,
//                               items: ["Manual", "Automatic"]
//                                   .map(
//                                     (e) => DropdownMenuItem(
//                                       value: e,
//                                       child: Text(e),
//                                     ),
//                                   )
//                                   .toList(),
//                               onChanged: (v) =>
//                                   setState(() => _transmission = v),
//                               decoration: InputDecoration(
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide(
//                                     color: Colors.black,
//                                     width: 1,
//                                   ),
//                                 ),
//                                 contentPadding: EdgeInsets.symmetric(
//                                   horizontal: 10,
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide(
//                                     color: Colors.black,
//                                     width: 1,
//                                   ),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide(
//                                     color: Colors.black,
//                                     width: 2,
//                                   ),
//                                 ),
//                                 // labelText: "Transmission",
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 12),
//                   buildTextField("Vehicle Color", _vehicleColorController),

//                   const SizedBox(height: 12),

//                   // Registration Number
//                   buildTextField(
//                     "Registration Number",
//                     _registrationController,
//                   ),
//                   const SizedBox(height: 12),
//                   buildTextField(
//                     "Security Deposit",
//                     _securityDepositController,
//                   ),
//                   const SizedBox(height: 12),
//                   buildTextField("Pickup Location", _pickupLocationController),
//                   const SizedBox(height: 12),

//                   Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             buildTitleText("Seating Capacity"),
//                             DropdownButtonFormField<int>(
//                               value: _seatingCapacity,
//                               items: [2, 4, 5, 7]
//                                   .map(
//                                     (e) => DropdownMenuItem(
//                                       value: e,
//                                       child: Text(e.toString()),
//                                     ),
//                                   )
//                                   .toList(),
//                               onChanged: (v) =>
//                                   setState(() => _seatingCapacity = v),

//                               decoration: InputDecoration(
//                                 // labelText: "Seating Capacity",
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide(
//                                     color: Colors.black,
//                                     width: 1,
//                                   ),
//                                 ),
//                                 contentPadding: EdgeInsets.symmetric(
//                                   horizontal: 10,
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide(
//                                     color: Colors.black,
//                                     width: 1,
//                                   ),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide(
//                                     color: Colors.black,
//                                     width: 2,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             buildTitleText("Bag Capacity"),
//                             DropdownButtonFormField<int>(
//                               value: _bagCapacity,
//                               items: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
//                                   .map(
//                                     (e) => DropdownMenuItem(
//                                       value: e,
//                                       child: Text(e.toString()),
//                                     ),
//                                   )
//                                   .toList(),
//                               onChanged: (v) =>
//                                   setState(() => _bagCapacity = v),
//                               decoration: InputDecoration(
//                                 // labelText: "Bag Capacity",
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide(
//                                     color: Colors.black,
//                                     width: 1,
//                                   ),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide(
//                                     color: Colors.black,
//                                     width: 1,
//                                   ),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide(
//                                     color: Colors.black,
//                                     width: 2,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(width: 12),

//                   buildTitleText("AC"),
//                   Switch(
//                     value: _isAc,
//                     onChanged: (v) => setState(() => _isAc = v),
//                   ),
//                   const SizedBox(height: 12),

//                   // Rental Price
//                   buildTextField(
//                     "Rental Price per Day",
//                     _rentalPriceController,
//                   ),
//                   const SizedBox(height: 12),

//                   // Availability
//                   buildTitleText("Availability"),
//                   DropdownButtonFormField<bool>(
//                     value: _isAvailable,

//                     items: const [
//                       DropdownMenuItem(value: true, child: Text("Available")),
//                       DropdownMenuItem(
//                         value: false,
//                         child: Text("Not Available"),
//                       ),
//                     ],
//                     onChanged: (v) => setState(() => _isAvailable = v ?? true),
//                     decoration: InputDecoration(
//                       // labelText: "Available or Not",
//                       contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(color: Colors.black, width: 1),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(color: Colors.black, width: 1),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(color: Colors.black, width: 2),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: PrimaryButton(
//           text: provider.isEditing ? "Saving..." : "Save Edit",
//           onPressed: provider.isEditing
//               ? null
//               : () async {
//                   // Prepare new images as MultipartFile
//                   List<MultipartFile> multipartImages = [];
//                   for (var img in _newImages) {
//                     multipartImages.add(
//                       await MultipartFile.fromFile(
//                         img.path,
//                         filename: img.name,
//                       ),
//                     );
//                   }

//                   await provider.editMyVehicleDetails(
//                     widget.vehicleId,
//                     _nameController.text,
//                     _selectedVehicleType ?? "",
//                     _registrationController.text,
//                     _seatingCapacity ?? 0,
//                     _fuelType ?? "",
//                     _transmission ?? "",
//                     _vehicleColorController.text,
//                     _securityDepositController.text,
//                     _pickupLocationController.text,
//                     _bagCapacity ?? 0,
//                     _isAc,
//                     _rentalPriceController.text,
//                     _isAvailable,
//                     multipartImages,
//                   );

//                   if (provider.editSuccess) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text("Vehicle updated successfully"),
//                       ),
//                     );
//                     Navigator.pop(context);
//                     await Provider.of<RentalProvider>(
//                       context,
//                       listen: false,
//                     ).fetchVehicles();
//                   } else if (provider.editError != null) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text(provider.editError!)),
//                     );
//                   }
//                 },
//         ),
//       ),
//     );
//   }
// }

// Widget buildTitleText(String title) {
//   return Text(title, style: TextStyle(color: Colors.grey, fontSize: 12));
// }

// Widget buildTextField(String labelTExt, TextEditingController controller) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(labelTExt, style: TextStyle(color: Colors.grey, fontSize: 12)),
//       TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           hintText: "Enter $labelTExt",
//           hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
//           contentPadding: EdgeInsets.symmetric(horizontal: 10),
//           border: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.black),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide(color: Colors.black, width: 1),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide(color: Colors.black, width: 2),
//           ),
//         ),
//       ),
//     ],
//   );
// }
