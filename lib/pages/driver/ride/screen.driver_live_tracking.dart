import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:velocyverse/credentials.dart';
import 'package:velocyverse/providers/driver/provider.driver.dart';

class DriverLiveTracking extends StatefulWidget {
  const DriverLiveTracking({Key? key}) : super(key: key);

  @override
  State<DriverLiveTracking> createState() => _DriverLiveTrackingState();
}

class _DriverLiveTrackingState extends State<DriverLiveTracking> {
  GoogleMapController? _mapController;
  late PolylinePoints _polylinePoints;

  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  List<LatLng> _polylineCoordinates = [];

  // Ride completion data defaults
  LatLng _pickupLocation = const LatLng(42.3601, -71.0589); // Boston Downtown
  LatLng _dropLocation = const LatLng(42.3736, -71.0530); // Boston Uptown
  final LatLng _currentLocation = const LatLng(42.3736, -71.0530);

  final String rideFare = "\$20.50";
  final String rideDistance = "10km";

  bool _dataInitialized = false;

  @override
  void initState() {
    super.initState();
    _polylinePoints = PolylinePoints(apiKey: Credentials.googleMapsAPIKey);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_dataInitialized) {
      final driverProvider = Provider.of<DriverProvider>(
        context,
        listen: false,
      );

      final rideDetail = driverProvider.rideDetail?.data;
      if (rideDetail != null) {
        _pickupLocation = LatLng(
          double.tryParse(rideDetail.fromLatitude ?? '') ?? 0,
          double.tryParse(rideDetail.fromLongitude ?? '') ?? 0,
        );
        _dropLocation = LatLng(
          double.tryParse(rideDetail.toLatitude ?? '') ?? 0,
          double.tryParse(rideDetail.toLongitude ?? '') ?? 0,
        );
      }

      _addMarkers();
      _createRoute();

      _dataInitialized = true;
    }
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
          infoWindow: const InfoWindow(title: 'Drop-off Location'),
        ),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('current'),
          position: _currentLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          infoWindow: const InfoWindow(title: 'You are here'),
        ),
      );
    });
  }

  Future<void> _createRoute() async {
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
        _polylineCoordinates.clear();
        for (var point in result.points) {
          _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }

        _polylines.clear();
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            color: Colors.blue,
            width: 4,
            points: _polylineCoordinates,
          ),
        );

        _polylines.add(
          Polyline(
            polylineId: const PolylineId('dotted_route'),
            color: Colors.green,
            width: 3,
            patterns: [PatternItem.dot, PatternItem.gap(10)],
            points: _polylineCoordinates.sublist(
              _polylineCoordinates.length ~/ 2,
            ),
          ),
        );

        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      print('Error creating route: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final driverProvider = Provider.of<DriverProvider>(context);
    final rideDetail = driverProvider.rideDetail?.data;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              flex: 2,
              child: GoogleMap(
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: _dropLocation,
                  zoom: 14,
                ),
                polylines: _polylines,
                markers: _markers,
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                compassEnabled: true,
                style: '''
                [
                  {
                    "featureType": "all",
                    "stylers": [{"saturation": -20}]
                  }
                ]
                ''',
              ),
            ),
            _buildRideDetails(rideDetail),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, size: 24),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 16),
          const Text(
            'Drop location',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildRideDetails(dynamic rideDetail) {
    return Expanded(
      flex: 2,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: rideDetail == null
            ? const Center(child: Text("No ride details available"))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Ride',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          rideDetail.estimatedPrice.toString(),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "${rideDetail.distanceKm} Km",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _buildLocationInfo(
                      'Pick-up',
                      rideDetail.fromLocation.toString(),
                      true,
                    ),
                    _buildLocationInfo(
                      'Drop-off',
                      rideDetail.toLocation.toString(),
                      false,
                    ),
                    const SizedBox(height: 32),
                    _buildButtons(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildLocationInfo(String title, String address, bool isPickup) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isPickup ? Colors.black : Colors.grey[400],
                shape: BoxShape.circle,
              ),
            ),
            if (isPickup)
              Container(width: 2, height: 30, color: Colors.grey[300]),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                address,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        if (isPickup)
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 16),
          ),
      ],
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        SizedBox(
          width: 120,
          height: 45,
          child: ElevatedButton.icon(
            onPressed: _showSOSDialog,
            icon: const Icon(Icons.warning, color: Colors.white, size: 18),
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
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _completeRide,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Ride Completed',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
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
      ),
    );
  }

  void _completeRide() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Complete Ride'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Your ride has been completed successfully!'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      'Total Fare: $rideFare',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Distance: $rideDistance',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showRatingDialog();
              },
              child: const Text('Rate Driver'),
            ),
          ],
        );
      },
    );
  }

  void _showRatingDialog() {
    int rating = 5;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Rate Your Driver'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('How was your ride experience?'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() => rating = index + 1);
                        },
                        child: Icon(
                          Icons.star,
                          color: index < rating
                              ? Colors.amber
                              : Colors.grey[300],
                          size: 32,
                        ),
                      );
                    }),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Skip'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
