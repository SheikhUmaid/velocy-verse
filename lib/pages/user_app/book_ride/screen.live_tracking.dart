import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/components/base/component.primary_button.dart';
import 'dart:async';
import 'package:velocyverse/credentials.dart';
import 'package:velocyverse/providers/user/provider.ride.dart';
import 'package:velocyverse/utils/util.active_ride_setter.dart';
import 'package:velocyverse/utils/util.error_toast.dart';
import 'package:velocyverse/utils/util.ride_persistor.dart';

class LiveTrackingScreen extends StatefulWidget {
  LiveTrackingScreen({Key? key, required this.otpText}) : super(key: key);
  String otpText;

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  String? driverName = "John Driver";
  String? carDetails = "Toyota Camry - Silver";
  String? licensePlate = "KA 01 AB 1234";
  String? eta = "15 mins";
  late GoogleMapController _mapController;
  late var ride;
  final PolylinePoints _polylinePoints = PolylinePoints(
    apiKey: Credentials.googleMapsAPIKey,
  );

  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  List<LatLng> _polylineCoordinates = [];

  // Sample data - replace with your actual data
  LatLng _pickupLocation = const LatLng(32.7767, -96.7970); // Dallas Downtown
  LatLng _dropLocation = const LatLng(32.8029, -96.7699); // Dallas Uptown
  // Current position
  // Driver and ride details
  final String remainingDistance = "3.2 km remaining";
  String pickupAddress = "123 Main Street, Downtown";
  String dropAddress = "456 Park Avenue, Uptown";
  Timer? _locationTimer;
  @override
  void initState() {
    super.initState();
    _initializeRideData();
  }

  Future<void> _initializeRideData() async {
    final rideProvider = Provider.of<RideProvider>(context, listen: false);
    await activeRideSetter(
      is_any: true,
      level: "/riderLiveTracking",
      rideId: rideProvider.activeId,
    );

    _pickupLocation = LatLng(
      rideProvider.fromLocation!.latitude!,
      rideProvider.fromLocation!.longitude!,
    );
    pickupAddress = rideProvider.fromLocation!.address;
    dropAddress = rideProvider.toLocation!.address;
    _dropLocation = LatLng(
      rideProvider.toLocation!.latitude!,
      rideProvider.toLocation!.longitude!,
    );
    setState(() {});
    final rideResponse = await rideProvider.driverArrivedScreen();
    setState(() {
      ride = rideResponse;
      driverName = ride.data['data']['driver']['username'];
      carDetails = ride.data['data']['vehicle_name'];
      licensePlate = ride.data['data']['vehicle_number'];
    });
    _addMarkers();
    // _createRoute();
    _startLocationUpdates();
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  void _startLocationUpdates() {
    _locationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      // Simulate driver location updates
    });
  }

  void _addMarkers() {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: _pickupLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          infoWindow: const InfoWindow(title: 'Pickup Location'),
        ),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('drop'),
          position: _dropLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Drop Location'),
        ),
      );
    });
  }

  Future<void> _createRoute(LatLng pickup, LatLng drop) async {
    try {
      final result = await _polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(pickup.latitude, pickup.longitude),
          destination: PointLatLng(drop.latitude, drop.longitude),
          mode: TravelMode.driving,
        ),
      );
      if (result.points.isNotEmpty) {
        _polylineCoordinates
          ..clear()
          ..addAll(
            result.points.map(
              (point) => LatLng(point.latitude, point.longitude),
            ),
          );
        setState(() {
          _polylines
            ..clear()
            ..add(
              Polyline(
                polylineId: const PolylineId('route'),
                color: Colors.black,
                width: 5,
                points: _polylineCoordinates,
              ),
            );
        });
      } else {
        debugPrint('No route found between $pickup and $drop');
      }
    } catch (e, stackTrace) {
      debugPrint('Error creating route: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rideProvider = Provider.of<RideProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Live Tracking"),

        leading: IconButton(
          onPressed: () => context.pushReplacementNamed('/userHome'),

          icon: const Icon(Icons.arrow_back, size: 24),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header

            // Map Section
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      GoogleMap(
                        onMapCreated: (GoogleMapController controller) {
                          _mapController = controller;
                        },
                        initialCameraPosition: CameraPosition(
                          target: _pickupLocation,
                          zoom: 13,
                        ),
                        polylines: _polylines,
                        markers: _markers,
                        myLocationEnabled: false,
                        zoomControlsEnabled: false,
                        mapToolbarEnabled: false,
                      ),
                      // ETA Info Card
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'ETA: $eta',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                remainingDistance,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Driver Details Section
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // Driver Info Card
                      Container(
                        padding: const EdgeInsets.all(16),
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
                        child: Row(
                          children: [
                            // Driver Avatar
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Driver Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    driverName!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    licensePlate!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    carDetails!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Action Buttons
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    // Handle call action
                                  },
                                  icon: const Icon(
                                    Icons.phone,
                                    color: Colors.green,
                                  ),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.green.withOpacity(
                                      0.1,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: () {
                                    // Handle chat action
                                  },
                                  icon: const Icon(Icons.chat_bubble_outline),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.blue.withOpacity(
                                      0.1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.maxFinite,
                        child: PrimaryButton(
                          text: "Show OTP",
                          onPressed: () {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (_) {
                                // Simulate rideId=123, replace with actual
                                Future.microtask(() {
                                  final rideProvider =
                                      Provider.of<RideProvider>(
                                        context,
                                        listen: false,
                                      );

                                  // What to do when OTP comes
                                  rideProvider.onOtpVerified = () {
                                    context.pushNamed('/routeWithDriver');
                                  };
                                  rideProvider.connectToOtpWs(123);
                                });

                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  insetPadding: const EdgeInsets.all(20),
                                  child: Container(
                                    width: double.infinity, // full width
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          "Share the OTP to the driver",
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          "Your OTP is:",
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          widget.otpText,
                                          style: const TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 16,

                                              vertical: 8,
                                            ),

                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.black,
                                              ),

                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),

                                            child: const Text(
                                              "OK",

                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Pickup and Drop Info
                      Container(
                        padding: const EdgeInsets.all(16),
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
                        child: Column(
                          children: [
                            // Pickup
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Pick-up',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Text(
                                        pickupAddress,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Drop-off
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Drop-off',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Text(
                                        dropAddress,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Action Buttons
                      Column(
                        children: [
                          // Share Ride Details Button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // Handle share ride details
                              },
                              icon: const Icon(Icons.share, size: 20),
                              label: const Text('Share Ride Details'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                side: const BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Cancel Ride Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _showCancelDialog();
                              },
                              icon: const Icon(Icons.cancel_outlined, size: 20),
                              label: const Text('Cancel Ride'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[100],
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
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

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Ride'),
          content: const Text('Are you sure you want to cancel this ride?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No', style: TextStyle(color: Colors.black54)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Go back to previous screen
              },
              child: const Text(
                'Yes, Cancel',

                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}
