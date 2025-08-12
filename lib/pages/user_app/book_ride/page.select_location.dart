import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/components/base/component.primary_button.dart';
import 'package:velocyverse/models/model.loaction.dart';
import 'package:velocyverse/providers/user/provider.ride.dart';

class SelectLocation extends StatefulWidget {
  int pickDropFlag;
  SelectLocation({super.key, required this.pickDropFlag});
  @override
  _SelectLocationState createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;

  static const LatLng _initialPosition = LatLng(
    20.5937,
    78.9629,
  ); // India center

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position pos = await Geolocator.getCurrentPosition();
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(LatLng(pos.latitude, pos.longitude)),
      );
    }
  }

  double roundToDecimals(double value, int places) {
    final mod = pow(10.0, places).toDouble();
    return ((value * mod).round().toDouble() / mod);
  }

  void _onMapTapped(LatLng tappedPoint) async {
    // Round coordinates to avoid backend errors
    final roundedLat = roundToDecimals(tappedPoint.latitude, 6);
    final roundedLng = roundToDecimals(tappedPoint.longitude, 6);

    setState(() {
      _selectedLocation = LatLng(roundedLat, roundedLng);
    });

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        roundedLat,
        roundedLng,
      );

      Placemark place = placemarks.first;

      String name = place.name ?? '';
      String address = [
        place.street,
        place.subLocality,
        place.locality,
        place.administrativeArea,
        place.country,
        place.postalCode,
      ].where((e) => e != null && e.isNotEmpty).join(', ');

      LocationModel location = LocationModel(
        name: name.isNotEmpty ? name : address, // fallback if name missing
        address: address,
        latitude: roundedLat,
        longitude: roundedLng,
      );

      final rideProvider = Provider.of<RideProvider>(context, listen: false);
      if (widget.pickDropFlag == 0) {
        rideProvider.fromLocation = location;
      } else {
        rideProvider.toLocation = location;
      }

      debugPrint("📍 Selected Address: $address");
    } catch (e) {
      debugPrint('❌ Error getting placemark: $e');
    }

    debugPrint("✅ Selected Latitude: $roundedLat, Longitude: $roundedLng");
  }

  void _onConfirm() async {
    if (_selectedLocation != null) {
      try {
        context.pop();
      } catch (e) {
        debugPrint('Error getting placemark: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Location")),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 18,
            ),
            onTap: _onMapTapped,
            markers: _selectedLocation == null
                ? {}
                : {
                    Marker(
                      markerId: MarkerId('selected'),
                      position: _selectedLocation!,
                    ),
                  },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          if (_selectedLocation != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: PrimaryButton(
                onPressed: _onConfirm,
                text: "Confirm Location",
              ),
            ),
        ],
      ),
    );
  }
}
