import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/components/base/component.custom_app_bar.dart';
import 'package:velocyverse/components/base/component.primary_button.dart';
import 'package:velocyverse/components/user/component.location_input.dart';
import 'package:velocyverse/components/user/component.price_input_filed.dart';
import 'package:velocyverse/components/user/component.vehcle_selector.dart';
import 'package:velocyverse/providers/user/provider.ride.dart';
import 'package:velocyverse/utils/util.success_toast.dart';

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
  late GoogleMapController _mapController;
  LatLng _pickupLocation = const LatLng(32.7767, -96.7970); // Dallas Downtown
  Set<Polyline> _polylines = {};

  Set<Marker> _markers = {};

  String selectedVehicle = 'bike'; // bike, car, auto
  bool womenOnly = false;

  @override
  void initState() {
    super.initState();
    final rideProvider = Provider.of<RideProvider>(context, listen: false);
    _pickupLocation = LatLng(
      rideProvider.fromLocation!.latitude!,
      rideProvider.fromLocation!.longitude!,
    );
    _markers.add(
      Marker(
        markerId: const MarkerId('pickup'),
        position: _pickupLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'Pickup Location'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(title: Text("Book a Ride")),
      body: SafeArea(
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
                child: GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: _pickupLocation,
                    zoom: 18,
                  ),
                  polylines: _polylines,
                  markers: _markers,
                  myLocationEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
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
              // Row(
              //   children: [
              //     GestureDetector(
              //       onTap: () => setState(() => womenOnly = !womenOnly),
              //       child: Container(
              //         width: 20,
              //         height: 20,
              //         decoration: BoxDecoration(
              //           color: womenOnly
              //               ? const Color(0xFF3B82F6)
              //               : Colors.transparent,
              //           border: Border.all(
              //             color: womenOnly
              //                 ? const Color(0xFF3B82F6)
              //                 : const Color(0xFFD1D5DB),
              //             width: 2,
              //           ),
              //           borderRadius: BorderRadius.circular(4),
              //         ),
              //         child: womenOnly
              //             ? const Icon(
              //                 Icons.check,
              //                 color: Colors.white,
              //                 size: 14,
              //               )
              //             : null,
              //       ),
              //     ),
              //     const SizedBox(width: 12),
              //     const Text(
              //       'Women only',
              //       style: TextStyle(fontSize: 16, color: Colors.black),
              //     ),
              //     const Spacer(),
              //     Container(
              //       width: 20,
              //       height: 20,
              //       decoration: BoxDecoration(
              //         color: const Color(0xFFF3F4F6),
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       child: const Icon(
              //         Icons.info_outline,
              //         color: Color(0xFF6B7280),
              //         size: 14,
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 8),
        child: // Request ride button
        PrimaryButton(
          text: 'Request Ride',
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
              if (rideProvider.rideType == "scheduled") {
                showFancySuccessToast(context, " Yout Ride has been scheduled");
                context.goNamed("/userHome");
              } else {
                context.pushNamed('/waitingForDriver');
              }
            }
          },
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
