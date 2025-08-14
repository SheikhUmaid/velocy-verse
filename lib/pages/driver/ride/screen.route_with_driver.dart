import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';

import 'package:velocyverse/credentials.dart';

class EnRouteScreen extends StatefulWidget {
  const EnRouteScreen({Key? key}) : super(key: key);

  @override
  State<EnRouteScreen> createState() => _EnRouteScreenState();
}

class _EnRouteScreenState extends State<EnRouteScreen> {
  late GoogleMapController _mapController;
  final PolylinePoints _polylinePoints = PolylinePoints(
    apiKey: Credentials.googleMapsAPIKey,
  );

  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  List<LatLng> _polylineCoordinates = [];

  // Driver and ride data
  final LatLng _driverLocation = const LatLng(
    42.3601,
    -71.0589,
  ); // Current driver location
  final LatLng _pickupLocation = const LatLng(
    42.3736,
    -71.0530,
  ); // Pickup location
  final LatLng _dropLocation = const LatLng(
    42.3850,
    -71.0420,
  ); // Final destination

  // Driver details
  final String driverName = "Michael Smith";
  final String driverRating = "4.89";
  final String totalTrips = "2.8k trips";
  final String carModel = "Toyota Camry";
  final String licensePlate = "ABC 123";
  final String carColor = "Black";

  // Trip details
  final String currentLocation = "123 Main Street";
  final String destination = "456 Oak Avenue";
  final String estimatedArrival = "12:45 PM";
  final String timeRemaining = "15 min";

  Timer? _locationTimer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _addMarkers();
    _createRoute();
    _startLocationUpdates();
    _startTimeUpdates();
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  void _startLocationUpdates() {
    _locationTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      // Simulate driver movement towards pickup
      _updateDriverLocation();
    });
  }

  void _startTimeUpdates() {
    Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  void _updateDriverLocation() {
    // Simulate driver moving towards pickup location
    if (mounted) {
      setState(() {
        _markers.removeWhere((marker) => marker.markerId.value == 'driver');
        _markers.add(
          Marker(
            markerId: const MarkerId('driver'),
            position: _driverLocation,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
            infoWindow: InfoWindow(title: 'Driver - $driverName'),
          ),
        );
      });
    }
  }

  void _addMarkers() {
    setState(() {
      // Driver location marker
      _markers.add(
        Marker(
          markerId: const MarkerId('driver'),
          position: _driverLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(title: 'Driver - $driverName'),
        ),
      );

      // Pickup location marker
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

      // Final destination marker (shown but not primary focus)
      _markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: _dropLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Final Destination'),
        ),
      );
    });
  }

  Future<void> _createRoute() async {
    try {
      // Route from driver to pickup location
      PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(
            _driverLocation.latitude,
            _driverLocation.longitude,
          ),
          destination: PointLatLng(
            _pickupLocation.latitude,
            _pickupLocation.longitude,
          ),
          mode: TravelMode.driving,
        ),
      );

      if (result.points.isNotEmpty) {
        _polylineCoordinates.clear();
        for (var point in result.points) {
          _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }

        _polylines.clear();
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('driver_to_pickup'),
            color: Colors.blue,
            width: 4,
            points: _polylineCoordinates,
          ),
        );

        // Add dotted line from pickup to final destination
        _addDestinationRoute();

        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      print('Error creating route: $e');
    }
  }

  Future<void> _addDestinationRoute() async {
    try {
      PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(
            _pickupLocation.latitude,
            _pickupLocation.longitude,
          ),
          destination: PointLatLng(
            _dropLocation.latitude,
            _dropLocation.longitude,
          ),
          mode: TravelMode.driving,
        ),
      );

      if (result.points.isNotEmpty) {
        List<LatLng> destinationRoute = [];
        for (var point in result.points) {
          destinationRoute.add(LatLng(point.latitude, point.longitude));
        }

        _polylines.add(
          Polyline(
            polylineId: const PolylineId('pickup_to_destination'),
            color: Colors.green,
            width: 3,
            patterns: [PatternItem.dot, PatternItem.gap(10)],
            points: destinationRoute,
          ),
        );

        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      print('Error creating destination route: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, size: 24),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const Text(
                    'En Route',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    onPressed: () {
                      _showMoreOptions();
                    },
                    icon: const Icon(Icons.more_vert, size: 24),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Map Section
            Expanded(
              flex: 2,
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: _driverLocation,
                  zoom: 13,
                ),
                polylines: _polylines,
                markers: _markers,
                myLocationEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                compassEnabled: true,
                onTap: (_) {
                  // Handle map tap if needed
                },
              ),
            ),

            // Driver and Trip Details Section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Driver Information
                  Row(
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

                      // Driver Name and Rating
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              driverName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$driverRating ($totalTrips)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Car Information
                  Row(
                    children: [
                      const Icon(
                        Icons.directions_car,
                        color: Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '$carModel • $licensePlate',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        carColor,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Location Information
                  Column(
                    children: [
                      // Current Location
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(top: 6),
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Current Location',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  currentLocation,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Dotted line connector
                      Container(
                        margin: const EdgeInsets.only(
                          left: 4,
                          top: 8,
                          bottom: 8,
                        ),
                        child: Column(
                          children: List.generate(
                            3,
                            (index) => Container(
                              width: 2,
                              height: 4,
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Destination
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(top: 6),
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Destination',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  destination,
                                  style: const TextStyle(
                                    fontSize: 16,
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

                  const SizedBox(height: 20),

                  // SOS Button
                  Center(
                    child: SizedBox(
                      width: 120,
                      height: 45,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showSOSDialog();
                        },
                        icon: const Icon(
                          Icons.warning,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: const Text(
                          'SOS',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ETA Information
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Estimated arrival',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            estimatedArrival,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Time remaining',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            timeRemaining,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Call Driver'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle call driver
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat),
                title: const Text('Message Driver'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle message driver
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share Trip'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle share trip
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSOSDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Emergency SOS',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'This will contact emergency services and share your location. Do you want to continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _triggerSOS();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'Call SOS',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _triggerSOS() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Emergency services contacted. Help is on the way.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
