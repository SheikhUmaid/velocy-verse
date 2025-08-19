import 'dart:io';

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

  List<XFile> _newImages = [];
  List<String> _existingImages = [];
  List<String> _deletedImageUrls = [];
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
        _existingImages = vehicle.images.map((img) => img.image ?? '').toList();

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

  void openImageCaurosel(List<String> images, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          final pageController = PageController(initialPage: initialIndex);
          int currentIndex = initialIndex;

          return StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(
                  centerTitle: false,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  title: Text(
                    '${currentIndex + 1} / ${images.length}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                body: PageView.builder(
                  controller: pageController,
                  onPageChanged: (index) => setState(() {
                    currentIndex = index;
                  }),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Center(
                        child: InteractiveViewer(
                          child: Image.network(
                            images[index],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
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
      await Provider.of<RentalProvider>(context, listen: false).fetchVehicles();
    } else if (provider.editError != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(provider.editError!)));
    }
  }

  void openImage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            centerTitle: false,
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          backgroundColor: Colors.black,
          body: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Center(
              child: InteractiveViewer(child: Image.network(imageUrl)),
            ),
          ),
        ),
      ),
    );
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
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
                            InkWell(
                              onTap: () => openImageCaurosel(
                                vehicle.images
                                    .map((img) => "$ip$imgUrl")
                                    .toList(),
                                index,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  "$ip$imgUrl",
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
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

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Vehicle Document"),
                      InkWell(
                        onTap: _pickVehicleDocument,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.image, size: 18),
                              Text(
                                "Change Image",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () =>
                        openImage("$ip${vehicle.vehiclePapersDocument!}"),
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
                  const SizedBox(height: 20),

                  // Vehicle Name
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
                                  border: Border.all(color: Colors.black54),
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
                                  border: Border.all(color: Colors.black54),
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
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
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
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _transmission = v),
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
                                // labelText: "Transmission",
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
                              onChanged: (v) =>
                                  setState(() => _bagCapacity = v),
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
                      fillColor: Colors.white,
                      // labelText: "Available or Not",
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
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
  return Column(
    children: [
      Text(title, style: TextStyle(color: Colors.black54, fontSize: 14)),
      const SizedBox(height: 2),
    ],
  );
}

Widget buildTextField(String labelTExt, TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(labelTExt, style: TextStyle(color: Colors.black54, fontSize: 14)),
      const SizedBox(height: 2),
      TextField(
        controller: controller,
        decoration: InputDecoration(
          fillColor: Colors.white,
          hintText: "Enter $labelTExt",
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
      const SizedBox(height: 8),
    ],
  );
}
