import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:VelocyTaxzz/utils/util.get_current_position.dart';

class ComponentMapView extends StatefulWidget {
  const ComponentMapView({super.key, required this.lat, required this.ln});
  final double lat, ln;

  @override
  State<ComponentMapView> createState() => _ComponentMapViewState();
}

class _ComponentMapViewState extends State<ComponentMapView> {
  GoogleMapController? _mapController;

  @override
  void didUpdateWidget(ComponentMapView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If lat/lng changed → animate camera
    if (oldWidget.lat != widget.lat || oldWidget.ln != widget.ln) {
      _goToLocation(widget.lat, widget.ln);
    }
  }

  void _goToLocation(double lat, double lng) {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, lng), zoom: 15),
        ),
      );
    }
  }

  Future<void> _goToCurrentLocation() async {
    Position pos = await getCurrentPosition();
    _goToLocation(pos.latitude, pos.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[200],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.lat, widget.ln),
                zoom: 15,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              onMapCreated: (controller) {
                _mapController = controller;
              },
            ),
          ),

          // Controls
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              children: [
                _MapControlButton(
                  icon: Icons.my_location,
                  onTap: _goToCurrentLocation,
                ),
                const SizedBox(height: 8),
                _MapControlButton(
                  icon: Icons.zoom_in,
                  onTap: () =>
                      _mapController?.animateCamera(CameraUpdate.zoomIn()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MapControlButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: Colors.black),
      ),
    );
  }
}

// // Your location fetch function
// Future<Position> getCurrentPosition() async {
//   bool serviceEnabled;
//   LocationPermission permission;

//   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     return Future.error('Location services are disabled.');
//   }

//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       return Future.error('Location permissions are denied');
//     }
//   }

//   if (permission == LocationPermission.deniedForever) {
//     return Future.error(
//       'Location permissions are permanently denied, we cannot request permissions.',
//     );
//   }

//   return await Geolocator.getCurrentPosition(
//     desiredAccuracy: LocationAccuracy.high,
//   );
// }
