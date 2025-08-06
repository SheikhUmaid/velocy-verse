import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:velocyverse/components/base/component.primary_button.dart';
import 'package:velocyverse/components/user/component.bottom_nav_bar.dart';
import 'package:velocyverse/components/user/component.favorite_locations.dart';
import 'package:velocyverse/components/user/component.home_header.dart';
import 'package:velocyverse/components/user/component.live_offers.dart';
import 'package:velocyverse/components/user/component.location_display.dart';
import 'package:velocyverse/components/user/component.map_view.dart';
import 'package:velocyverse/components/user/component.ride_type_selector.dart';
import 'package:velocyverse/components/user/component.search_bar.dart';
import 'package:velocyverse/utils/util.get_current_position.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  String selectedRideType = 'Scheduled';
  int selectedBottomNavIndex = 0;

  double lat = 28.6129, ln = 77.2295;

  void _showLocation() async {
    try {
      Position position = await getCurrentPosition();
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      lat = position.latitude;
      ln = position.longitude;
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    _showLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            const ComponentHomeHeader(
              userName: 'Alex',
              greeting: 'Hello, Alex',
              subGreeting: 'Welcome back',
            ),

            // Location Display
            const ComponentLocationDisplay(
              currentLocation: '123 Main Street, City',
            ),

            // Search Bar
            const ComponentSearchBar(),

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
                      PrimaryButton(
                        text: 'Book now',
                        onPressed: () {
                          print('Book now pressed');
                        },
                      ),
                      const SizedBox(height: 16),

                      // Bottom Navigation
                      ComponentBottomNavigation(
                        selectedIndex: selectedBottomNavIndex,
                        onIndexChanged: (index) {
                          setState(() {
                            selectedBottomNavIndex = index;
                          });
                        },
                      ),
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
