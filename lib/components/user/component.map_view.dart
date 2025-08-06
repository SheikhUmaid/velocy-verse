import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ComponentMapView extends StatelessWidget {
  const ComponentMapView({super.key, required this.lat, required this.ln});
  final double lat, ln;
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
          // Mock Map Background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFFF3F4F6),
            ),
            child: Center(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(lat, ln),
                  zoom: 15,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
              ),
            ),
          ),

          // Map Controls
          Positioned(
            top: 16,
            right: 16,
            child: Column(
              children: [
                _MapControlButton(
                  icon: Icons.my_location,
                  onTap: () => print('Current location pressed'),
                ),
                const SizedBox(height: 8),
                _MapControlButton(
                  icon: Icons.zoom_in,
                  onTap: () => print('Zoom in pressed'),
                ),
              ],
            ),
          ),

          // Driver Avatar (Mock)
          const Positioned(
            bottom: 80,
            left: 60,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 20, color: Colors.black),
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
