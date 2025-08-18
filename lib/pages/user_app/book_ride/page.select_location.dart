import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/components/base/component.primary_button.dart';
import 'package:velocyverse/credentials.dart';
import 'package:velocyverse/models/model.loaction.dart';
import 'package:velocyverse/providers/user/provider.ride.dart';

// 🚨 Add this package in pubspec.yaml
// google_places_autocomplete_text_field: ^0.1.3 (check latest version)
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart'
    hide Location;

class SelectLocation extends StatefulWidget {
  final int pickDropFlag;
  const SelectLocation({super.key, required this.pickDropFlag});

  @override
  _SelectLocationState createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  final TextEditingController _searchController = TextEditingController();
  String _selectedAddress = '';

  static const LatLng _initialPosition = LatLng(
    20.5937,
    78.9629,
  ); // India center

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

      // Set current location as initial selection
      await _setSelectedLocation(pos.latitude, pos.longitude);
    }
  }

  double roundToDecimals(double value, int places) {
    final mod = pow(10.0, places).toDouble();
    return ((value * mod).round().toDouble() / mod);
  }

  Future<void> _setSelectedLocation(double lat, double lng) async {
    final roundedLat = roundToDecimals(lat, 6);
    final roundedLng = roundToDecimals(lng, 6);

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

      setState(() {
        _selectedAddress = address;
        _searchController.text = address;
      });

      LocationModel location = LocationModel(
        name: name.isNotEmpty ? name : address,
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

  Future<void> _onPlaceSelected(Prediction prediction) async {
    debugPrint("🔍 Selected Place: ${prediction.description}");

    try {
      // Get location details from place ID using geocoding
      List<Location> locations = await locationFromAddress(
        prediction.description ?? "",
      );

      if (locations.isNotEmpty) {
        Location location = locations.first;

        // Update map camera to navigate to selected location
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(location.latitude, location.longitude),
            18.0,
          ),
        );

        // Set the selected location
        await _setSelectedLocation(location.latitude, location.longitude);

        // Update search field with selected place
        setState(() {
          _searchController.text = prediction.description ?? "";
          _searchController.selection = TextSelection.fromPosition(
            TextPosition(offset: prediction.description?.length ?? 0),
          );
        });
      }
    } catch (e) {
      debugPrint('❌ Error getting location from address: $e');

      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to find location. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onMapTapped(LatLng tappedPoint) =>
      _setSelectedLocation(tappedPoint.latitude, tappedPoint.longitude);

  void _onConfirm() {
    if (_selectedLocation != null) {
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a location first'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _onCurrentLocationTap() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          18.0,
        ),
      );

      await _setSelectedLocation(position.latitude, position.longitude);
    } catch (e) {
      debugPrint('❌ Error getting current location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to get current location'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.pickDropFlag == 0
              ? "Select Pickup Location"
              : "Select Drop Location",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: const CameraPosition(
              target: _initialPosition,
              zoom: 18,
            ),
            onTap: _onMapTapped,
            markers: _selectedLocation == null
                ? {}
                : {
                    Marker(
                      markerId: const MarkerId('selected'),
                      position: _selectedLocation!,
                      infoWindow: InfoWindow(
                        title: 'Selected Location',
                        snippet: _selectedAddress.isNotEmpty
                            ? _selectedAddress.length > 50
                                  ? '${_selectedAddress.substring(0, 50)}...'
                                  : _selectedAddress
                            : 'Tap to select',
                      ),
                    ),
                  },
            myLocationEnabled: true,
            myLocationButtonEnabled: false, // We'll create custom button
            zoomControlsEnabled: false,
          ),

          // Search Box with Google Places Autocomplete
          Positioned(
            top: 10,
            left: 15,
            right: 15,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: GooglePlacesAutoCompleteTextFormField(
                textEditingController: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for a location...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 16,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey.shade600),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onSuggestionClicked: _onPlaceSelected,
                // getPlaceDetailWithLatLng: _onPlaceSelected,
                // countries: const ["in"], // Restrict to India
                // isLatLngRequired: true,
                config: GoogleApiConfig(
                  apiKey: Credentials.googleMapsAPIKey,
                  debounceTime: 600,
                  countries: const ["in"],
                  // language: "en",
                ),

                // Custom styling for dropdown
              ),
            ),
          ),

          // Current Location Button
          Positioned(
            bottom: _selectedLocation != null ? 100 : 30,
            right: 20,
            child: FloatingActionButton(
              onPressed: _onCurrentLocationTap,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              mini: true,
              child: const Icon(Icons.my_location),
            ),
          ),

          // Selected Location Info Card
          if (_selectedLocation != null && _selectedAddress.isNotEmpty)
            Positioned(
              bottom: 100,
              left: 20,
              right: 80,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.red.shade400,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Selected Location',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selectedAddress,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),

          // Confirm Button
          if (_selectedLocation != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: PrimaryButton(
                onPressed: _onConfirm,
                text: "Confirm Location",
                height: 52,
              ),
            ),

          // Loading indicator when searching
          if (_searchController.text.isNotEmpty && _selectedLocation == null)
            const Positioned(
              top: 80,
              left: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
        ],
      ),
    );
  }
}
