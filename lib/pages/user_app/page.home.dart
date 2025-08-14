import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/components/base/component.primary_button.dart';
import 'package:velocyverse/components/user/component.favorite_locations.dart';
import 'package:velocyverse/components/user/component.home_header.dart';
import 'package:velocyverse/components/user/component.live_offers.dart';
import 'package:velocyverse/components/user/component.location_display.dart';
import 'package:velocyverse/components/user/component.map_view.dart';
import 'package:velocyverse/components/user/component.ride_type_selector.dart';
import 'package:velocyverse/components/user/component.search_bar.dart';
import 'package:velocyverse/providers/user/provider.ride.dart';
import 'package:velocyverse/providers/user/provider.rider_profile.dart';
import 'package:velocyverse/utils/util.get_current_location.dart';
import 'package:velocyverse/utils/util.get_current_position.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  String selectedRideType = 'Scheduled';
  int selectedBottomNavIndex = 0;
  String currentAddress = "Fetching your address...";

  double lat = 28.6129, ln = 77.2295;

  void _showLocation() async {
    try {
      Position position = await getCurrentPosition();
      currentAddress = await getAddressFromPosition(position);
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      lat = position.latitude;
      ln = position.longitude;
      setState(() {});
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _showLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      drawer: Drawer(),
      // appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Consumer<RiderProfileProvider>(
              builder: (_, prov, __) {
                // prov.getRiderProfile();
                return ComponentHomeHeader(
                  userName: prov.name,
                  greeting: 'Hello, ${prov.name}',
                  subGreeting: 'Welcome back',
                );
              },
            ),

            // Location Display
            ComponentLocationDisplay(currentLocation: currentAddress),

            // Search Bar
            InkWell(
              onTap: () {
                Provider.of<RideProvider>(context, listen: false).rideType =
                    'now';
                context.pushNamed('/bookRide');
              },
              child: ComponentSearchBar(),
            ),

            // Map View
            Expanded(
              flex: 3,
              child: ComponentMapView(lat: lat, ln: ln),
            ),

            // Content Section
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Live Offers
                      const ComponentLiveOffers(),
                      const SizedBox(height: 24),

                      // Favourite Locations
                      const ComponentFavouriteLocations(),
                      const SizedBox(height: 24),

                      // Ride Type Selector
                      ComponentRideTypeSelector(
                        selectedType: selectedRideType,
                        onTypeChanged: (type) {
                          setState(() {
                            selectedRideType = type;
                          });
                        },
                      ),
                      const SizedBox(height: 24),

                      // Book Now Button
                      SizedBox(
                        width: double.maxFinite,
                        child: PrimaryButton(
                          text: 'Book now',
                          onPressed: () {
                            Provider.of<RideProvider>(
                              context,
                              listen: false,
                            ).rideType = 'now';
                            context.pushNamed('/bookRide');

                            print('Book now pressed');
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Bottom Navigation
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
