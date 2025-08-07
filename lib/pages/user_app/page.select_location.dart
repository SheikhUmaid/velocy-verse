import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:velocyverse/components/base/component.primary_button.dart';
import 'package:velocyverse/models/model.loaction.dart';

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

  void _onMapTapped(LatLng tappedPoint) {
    setState(() {
      _selectedLocation = tappedPoint;
    });

    print(
      "Selected Latitude: ${tappedPoint.latitude}, Longitude: ${tappedPoint.longitude}",
    );
  }

  void _onConfirm() async {
    if (_selectedLocation != null) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          _selectedLocation!.latitude,
          _selectedLocation!.longitude,
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
          name: name,
          address: address,
          latitude: _selectedLocation!.latitude,
          longitude: _selectedLocation!.longitude, // corrected from `.latitude`
        );

        Navigator.pop(context, location);
      } catch (e) {
        print('Error getting placemark: $e');
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
