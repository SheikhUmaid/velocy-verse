import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/components/base/component.primary_button.dart';
import 'package:velocyverse/pages/user_app/rental/presentation/rental_vehicle_owner_info_screen.dart';
import 'package:velocyverse/pages/user_app/rental/provider/rental_provider.dart';
import 'package:velocyverse/utils/responsive_wraper.dart';

class RentalVehicleDetailScreen extends StatefulWidget {
  final int vehicleId;
  final bool isAvailable;
  const RentalVehicleDetailScreen({
    super.key,
    required this.vehicleId,
    required this.isAvailable,
  });

  @override
  State<RentalVehicleDetailScreen> createState() =>
      _RentalVehicleDetailScreenState();
}

class _RentalVehicleDetailScreenState extends State<RentalVehicleDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<RentalProvider>(
        context,
        listen: false,
      ).fetchVehicleDetail(widget.vehicleId);
    });
  }

  DateTime? _pickupDateTime;
  DateTime? _dropDateTime;

  Future<void> _selectDateTime(BuildContext context, bool isPickup) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    final DateTime selectedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      if (isPickup) {
        _pickupDateTime = selectedDateTime;
      } else {
        _dropDateTime = selectedDateTime;
      }
    });
  }

  File? _licenceImage;

  Future<void> _pickLicenceImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _licenceImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vehicle Details"),
        actions: [
          Consumer<RentalProvider>(
            builder: (context, provider, _) {
              final v = provider.vehicleDetail;
              if (v?.user?.profile != null) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RentalVehicleOwnerInfoScreen(
                            vehicleId: widget.vehicleId,
                          ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        "http://82.25.104.152/${v!.user!.profile}",
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: Consumer<RentalProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(child: Text("Error: ${provider.error}"));
          }

          final v = provider.vehicleDetail;
          if (v == null) {
            return const Center(child: Text("No details found"));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vehicle Image
                if (v.images.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      "http://82.25.104.152/${v.images.first}",
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 16),

                // Name + type
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        v.vehicleName ?? "",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (v.vehicleType != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(v.vehicleType!),
                      ),
                  ],
                ),

                const SizedBox(height: 4),

                // Rating
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.black, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      v.averageRating != null
                          ? "${v.averageRating} "
                          : "No rating",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Price
                Text(
                  "₹${v.rentalPricePerHour ?? ''} /hour",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                // Info cards
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _infoCard(
                      "Capacity",
                      "${v.seatingCapacity} Seater",
                      Icons.event_seat,
                    ),
                    _infoCard(
                      "AC",
                      v.isAc == true ? "Yes" : "No",
                      Icons.ac_unit,
                    ),
                    _infoCard(
                      "Fuel",
                      v.fuelType ?? "-",
                      Icons.local_gas_station,
                    ),
                    _infoCard(
                      "Transmission",
                      v.transmission ?? "-",
                      Icons.settings,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Rental Duration",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Pickup Time
                      const Text("Pickup Time"),
                      GestureDetector(
                        onTap: () => _selectDateTime(context, true),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          margin: const EdgeInsets.only(top: 6, bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _pickupDateTime != null
                                    // ? "${_pickupDateTime!.toLocal()}".split('.')[0]
                                    ? DateFormat(
                                        'dd-MM-yyyy HH:mm',
                                      ).format(_pickupDateTime!)
                                    : "Select Pickup Date & Time",
                                style: const TextStyle(fontSize: 14),
                              ),
                              Icon(Icons.calendar_month_rounded),
                            ],
                          ),
                        ),
                      ),

                      // Drop Time
                      const Text("Drop Time"),
                      GestureDetector(
                        onTap: () => _selectDateTime(context, false),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          margin: const EdgeInsets.only(top: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _dropDateTime != null
                                    // ? "${_dropDateTime!.toLocal()}".split('.')[0]
                                    ? DateFormat(
                                        'dd-MM-yyyy HH:mm',
                                      ).format(_dropDateTime!)
                                    : "Select Drop Date & Time",
                                style: const TextStyle(fontSize: 14),
                              ),
                              Icon(Icons.calendar_month_rounded),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Upload your driving licence",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_licenceImage == null)
                        InkWell(
                          onTap: _pickLicenceImage,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black26),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: _pickLicenceImage,
                                  icon: Icon(
                                    Icons.cloud_upload_outlined,
                                    color: Colors.black,
                                  ),
                                ),
                                Text("Select an image"),
                              ],
                            ),
                          ),
                        ),

                      const SizedBox(height: 12),

                      // Preview
                      if (_licenceImage != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                _licenceImage!,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            TextButton(
                              onPressed: _pickLicenceImage,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.edit_document),
                                  Text(
                                    "Change Image",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: PrimaryButton(
          text: widget.isAvailable ? "Send Request" : "Unavailable",
          backgroundColor: widget.isAvailable ? Colors.black : Colors.grey,
          onPressed: widget.isAvailable
              ? () {
                  if (_pickupDateTime == null ||
                      _dropDateTime == null ||
                      _licenceImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Please fill all fields and upload your license.",
                        ),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }

                  _submitRentalRequest(context);
                }
              : () {
                  if (_pickupDateTime == null ||
                      _dropDateTime == null ||
                      _licenceImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("This vehicle is not available"),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }
                },
        ),
      ),
    );
  }

  void _submitRentalRequest(BuildContext context) async {
    final provider = Provider.of<RentalProvider>(context, listen: false);

    await provider.sendRentRequest(
      vehicleId: widget.vehicleId,
      pickupDateTime: _pickupDateTime!,
      dropoffDateTime: _dropDateTime!,
      licenseDocument: _licenceImage!,
    );

    // Show Snackbar based on result
    if (provider.isSuccess) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.black,
                size: 60,
              ),
              const SizedBox(height: 12),
              const Text(
                "Rental request sent successfully!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 25),
              PrimaryButton(
                text: "Ok",
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    } else if (provider.sendError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${provider.sendError}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _infoCard(String title, String value, IconData icon) {
    return Container(
      width: (MediaQuery.of(context).size.width / 2) - 24,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
