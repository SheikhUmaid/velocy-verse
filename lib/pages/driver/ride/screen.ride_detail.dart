import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/credentials.dart';
import 'package:velocyverse/models/model.ride_detail.dart';
import 'package:velocyverse/providers/driver/provider.driver.dart';
import 'package:velocyverse/utils/util.error_toast.dart';

class RideDetailsScreen extends StatefulWidget {
  const RideDetailsScreen({super.key});

  @override
  State<RideDetailsScreen> createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends State<RideDetailsScreen>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final List<LatLng> _polylineCoordinates = [];
  final PolylinePoints _polylinePoints = PolylinePoints(
    apiKey: Credentials.googleMapsAPIKey,
  );

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    Future.microtask(() {
      Provider.of<DriverProvider>(context, listen: false).getRideDetails();
    });
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

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_currentPosition!, 15),
    );
  }

  Future<void> _setMapData(Data ride) async {
    if (ride.fromLatitude == null ||
        ride.fromLongitude == null ||
        ride.toLatitude == null ||
        ride.toLongitude == null)
      return;

    final pickup = LatLng(
      double.parse(ride.fromLatitude!),
      double.parse(ride.fromLongitude!),
    );
    final drop = LatLng(
      double.parse(ride.toLatitude!),
      double.parse(ride.toLongitude!),
    );

    _markers.clear();
    _markers.add(
      Marker(
        markerId: const MarkerId('pickup'),
        position: pickup,
        infoWindow: InfoWindow(title: "Pickup", snippet: ride.fromLocation),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );

    _markers.add(
      Marker(
        markerId: const MarkerId('drop'),
        position: drop,
        infoWindow: InfoWindow(title: "Drop", snippet: ride.toLocation),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );

    await _createRoute(pickup, drop);

    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            pickup.latitude < drop.latitude ? pickup.latitude : drop.latitude,
            pickup.longitude < drop.longitude
                ? pickup.longitude
                : drop.longitude,
          ),
          northeast: LatLng(
            pickup.latitude > drop.latitude ? pickup.latitude : drop.latitude,
            pickup.longitude > drop.longitude
                ? pickup.longitude
                : drop.longitude,
          ),
        ),
        50,
      ),
    );
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
    final driverProvider = Provider.of<DriverProvider>(context);
    final rideDetail = driverProvider.rideDetail?.data;

    if (rideDetail != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _setMapData(rideDetail);
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Ride Details"),
        backgroundColor: Colors.white,
      ),
      body: rideDetail == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 16),
                _buildRideDetailsCard(rideDetail),
                _buildFareSection(rideDetail.estimatedPrice),
                Expanded(child: _buildMapSection()),
                _buildActionButtons(),
              ],
            ),
    );
  }

  Widget _buildRideDetailsCard(Data ride) {
    final rider = ride.user;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              _buildProfileAvatar(rider?.profile),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rider?.username ?? "Unknown Rider",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Column(
                children: [
                  const Icon(Icons.location_searching),
                  Container(width: 2, height: 30, color: Colors.grey[300]),
                  const Icon(Icons.location_on),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ride.fromLocation ?? "Pickup location"),
                    const SizedBox(height: 20),
                    Text(ride.toLocation ?? "Drop location"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar(String? profileUrl) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: profileUrl != null && profileUrl.isNotEmpty
            ? Image.network(profileUrl, fit: BoxFit.cover)
            : const Icon(Icons.person, color: Colors.grey, size: 30),
      ),
    );
  }

  Widget _buildFareSection(String? fare) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Row(
        children: [
          const Text('Rider fare'),
          const Spacer(),
          Text(
            '₹${fare ?? "0"}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition ?? _initialCameraPosition.target,
              zoom: 15,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (controller) => _mapController = controller,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => context.pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
              ),
              child: const Text('Decline'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                final driverProvider = Provider.of<DriverProvider>(
                  context,
                  listen: false,
                );
                final response = await driverProvider.acceptRide();
                if (response) {
                  context.pushNamed("/pickUpNavigation");
                  //     final driverProvider = Provider.of<DriverProvider>(
                  //   context,
                  //   listen: false,
                  // );
                  await driverProvider.generateOTP();
                }
                if (!response) {
                  showFancyErrorToast(
                    context,
                    "Seems like this ride has been taken already",
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text('Accept'),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
      ],
    );
  }
}
