import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:velocyverse/components/base/component.primary_button.dart';
import 'package:velocyverse/credentials.dart';
import 'package:velocyverse/providers/driver/provider.driver.dart';
import 'package:velocyverse/utils/util.maike_phone_call.dart';
import 'package:velocyverse/utils/util.success_toast.dart';

class NavigationPickUp extends StatefulWidget {
  @override
  _NavigationPickUpState createState() => _NavigationPickUpState();
}

class _NavigationPickUpState extends State<NavigationPickUp> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  late LatLng? pickupLocation; // Example pickup location
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  bool _routeDrawn = false;
  bool _otpVerified = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final prov = Provider.of<DriverProvider>(context, listen: false);

    setState(() {
      pickupLocation = LatLng(
        double.parse(prov.rideDetail!.data!.fromLatitude.toString()),
        double.parse(prov.rideDetail!.data!.fromLongitude.toString()),
      );
      _currentPosition = LatLng(position.latitude, position.longitude);
      _addMarkers();
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_currentPosition!, 15),
    );

    if (!_routeDrawn) {
      _drawRoute();
    }
  }

  void _addMarkers() {
    _markers.clear();
    if (_currentPosition != null) {
      _markers.add(
        Marker(
          markerId: MarkerId('current'),
          position: _currentPosition!,
          infoWindow: InfoWindow(title: "Your Location"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }
    _markers.add(
      Marker(
        markerId: MarkerId('pickup'),
        position: pickupLocation!,
        infoWindow: InfoWindow(title: "Pickup Location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );
  }

  Future<void> _drawRoute() async {
    if (_currentPosition == null) return;

    PolylinePoints polylinePoints = PolylinePoints(
      apiKey: Credentials.googleMapsAPIKey,
    );

    // The new syntax uses a PolylineRequest object
    PolylineRequest request = PolylineRequest(
      mode: TravelMode.driving,
      origin: PointLatLng(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      ),
      destination: PointLatLng(
        pickupLocation!.latitude,
        pickupLocation!.longitude,
      ),
      // travelMode: TravelMode.driving,
    );

    // Pass the request object to the method
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: request,
    );

    if (result.points.isNotEmpty) {
      List<LatLng> polylineCoords = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      setState(() {
        _polylines.add(
          Polyline(
            polylineId: PolylineId('route'),
            color: Colors.blue,
            width: 5,
            points: polylineCoords,
          ),
        );
        _routeDrawn = true;
      });
    }
  }

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 12,
  );

  @override
  Widget build(BuildContext context) {
    final driverProvider = Provider.of<DriverProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text('Pick Up location')),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: _markers,
              polylines: _polylines,
              onMapCreated: (controller) {
                _mapController = controller;
                if (_currentPosition != null) _drawRoute();
              },
            ),
          ),
          Expanded(flex: 2, child: _buildBottomDetails(context)),
        ],
      ),
    );
  }

  Widget _buildBottomDetails(BuildContext context) {
    final driverProvder = Provider.of<DriverProvider>(context, listen: false);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLocationTile(
              'Pick up',
              driverProvder.rideDetail!.data!.fromLocation.toString(),

              Colors.green,
            ),
            SizedBox(height: 12),
            _buildLocationTile(
              'Drop off',
              driverProvder.rideDetail!.data!.toLocation.toString(),
              Colors.red,
            ),
            SizedBox(height: 20),
            _buildUserInfo(),
            SizedBox(height: 24),
            _buildActionButtons(context),
            SizedBox(height: 24),

            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationTile(String label, String address, Color dotColor) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  address,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    final driverProvder = Provider.of<DriverProvider>(context, listen: false);
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: Icon(Icons.person, color: Colors.grey[600]),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            driverProvder.rideDetail!.data!.user!.username.toString(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        _iconButton(
          Icons.phone,
          onTap: () async {
            await makePhoneCall(
              driverProvder.rideDetail!.data!.user!.phoneNumber.toString(),
            );
          },
        ),
        SizedBox(width: 12),
        _iconButton(Icons.message),
      ],
    );
  }

  Widget _iconButton(IconData icon, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Colors.grey[100],
        child: Icon(icon, color: Colors.grey[700], size: 20),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        _fullButton(CupertinoIcons.paperplane, 'Begin', Colors.black, () async {
          final driverProvider = Provider.of<DriverProvider>(
            context,
            listen: false,
          );
          final response = await driverProvider.beginRide();
          if (response) {
            // context.goNamed("/dropOffNavigation");
            context.goNamed("/driverLiveTracking");
          }
        }),
        SizedBox(height: 12),
        _outlinedButton(Icons.cancel_outlined, 'Cancel Ride', () {}),
        SizedBox(height: 12),
        _fullButton(
          CupertinoIcons.text_aligncenter,
          'Send OTP',
          Colors.black,
          () async {
            if (!_otpVerified) {
              final driverProvider = Provider.of<DriverProvider>(
                context,
                listen: false,
              );
              final response = await driverProvider.generateOTP();
              if (response) {
                _showOtpDialog(context);
                _otpVerified = response;
              } else {
                showFancySuccessToast(context, "OTP has been already verified");
              }
            }
          },
        ),
      ],
    );
  }

  void _showOtpDialog(BuildContext context) {
    final TextEditingController otpController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false, // User must tap Verify or Cancel
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter OTP"),
          content: TextField(
            controller: otpController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Enter OTP",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close without doing anything
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                String enteredOtp = otpController.text.trim();
                final driverProvider = Provider.of<DriverProvider>(
                  context,
                  listen: false,
                );
                final response = await driverProvider.verifyOTP(
                  otp: enteredOtp,
                );
                if (response) {
                  showFancySuccessToast(
                    context,
                    "OTP has been verified successfully! You may begin the ride!",
                  );
                  Navigator.of(context).pop(); // Close without doing anything

                  // context.goNamed("/driverLiveTracking");
                }
              },
              child: const Text("Verify"),
            ),
          ],
        );
      },
    );
  }

  Widget _fullButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _outlinedButton(IconData icon, String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          side: BorderSide(color: Colors.grey[300]!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
// 307557