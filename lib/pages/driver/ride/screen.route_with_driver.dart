import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:velocyverse/credentials.dart';

class EnRouteScreen extends StatefulWidget {
  final int rideId; // pass ride ID when opening this screen
  const EnRouteScreen({Key? key, required this.rideId}) : super(key: key);

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

  // Example coordinates — you’ll change later
  final LatLng _pickupLocation = const LatLng(42.3736, -71.0530);
  final LatLng _dropLocation = const LatLng(42.3850, -71.0420);

  WebSocketChannel? _channel;

  @override
  void initState() {
    super.initState();
    _addMarkers();
    _createRoute();
    connectRideWebSocket(widget.rideId);
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }

  void _addMarkers() {
    _markers.add(
      Marker(
        markerId: const MarkerId('pickup'),
        position: _pickupLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'Pickup'),
      ),
    );

    _markers.add(
      Marker(
        markerId: const MarkerId('drop'),
        position: _dropLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: 'Drop'),
      ),
    );
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

        _polylines.add(
          Polyline(
            polylineId: const PolylineId('pickup_to_drop'),
            color: Colors.blue,
            width: 4,
            points: _polylineCoordinates,
          ),
        );
        setState(() {});
      }
    } catch (e) {
      print('Error creating route: $e');
    }
  }

  void connectRideWebSocket(int rideId) {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://82.25.104.152/ws/ride_notifications/?ride_id=$rideId'),
    );

    _channel!.stream.listen(
      (message) {
        final data = jsonDecode(message);

        switch (data['type']) {
          case 'otp':
            print("📩 OTP Received: ${data['otp']}");
            print("Ride ID: ${data['ride_id']}");
            break;

          case 'ride_completed':
            print("✅ Ride Completed: ${data['message']}");
            print("End Time: ${data['end_time']}");
            // Navigate to another screen
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const RideCompletedScreen()),
              );
            }
            break;

          default:
            print("Unknown message type: $data");
        }
      },
      onError: (error) {
        print("⚠️ WebSocket Error: $error");
      },
      onDone: () {
        print("❌ WebSocket Closed");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: (controller) => _mapController = controller,
        initialCameraPosition: CameraPosition(
          target: _pickupLocation,
          zoom: 13,
        ),
        markers: _markers,
        polylines: _polylines,
        zoomControlsEnabled: false,
      ),
    );
  }
}

// Dummy ride completed screen
class RideCompletedScreen extends StatelessWidget {
  const RideCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Ride Completed ✅", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
