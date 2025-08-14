import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/components/driver/component.ongoingRide.dart';
import 'package:velocyverse/providers/driver/provider.driver.dart';
import 'package:velocyverse/providers/driver/provider.driver_profile.dart';
import 'package:velocyverse/providers/user/provider.ride.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  bool isOnline = false;
  int selectedTab = 0;
  String selectedRideTab = 'Live';

  @override
  void initState() {
    // TODO: implement initState
    Future.microtask(() {
      Provider.of<DriverProvider>(context, listen: false).driverINIT();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final driverProvider = Provider.of<DriverProvider>(context, listen: false);
    // driverProvider.driverINIT();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      // ),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeader(),

            SizedBox(height: 10),
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                // padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOngoingRideSection(context),

                    // Go Online Section
                    _buildGoOnlineSection(),
                    const SizedBox(height: 20),

                    // Today's Earnings Section
                    _buildTodaysEarningsSection(),
                    const SizedBox(height: 20),

                    // Cash Limit Section
                    _buildCashLimitSection(),
                    const SizedBox(height: 20),

                    // Ride Requests Section
                    _buildRideRequestsSection(),
                    const SizedBox(height: 20),

                    // Active Ride Card
                    _buildActiveRideCard(),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            // _buildBottomNavigation(),
          ],
        ),
      ),

      drawer: Drawer(backgroundColor: Colors.red),
    );
  }

  Widget _buildHeader() {
    final driverProfileProvider = Provider.of<DriverProfileProvider>(
      context,
      listen: true,
    );

    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Row(
        children: [
          // Profile Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: InkWell(
              onTap: () {
                print("opening drawer");
                Scaffold.of(context).openDrawer();

                print("drawer open");
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(
                      Icons.person,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${driverProfileProvider.profileDetails?.username ?? '__'}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      // Text(
                      //   'ID: DRV2025001',
                      //   style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          // Notification Icon
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
            color: Colors.grey[700],
          ),
        ],
      ),
    );
  }

  Widget _buildOngoingRideSection(BuildContext context) {
    final driverProvider = Provider.of<DriverProvider>(context, listen: true);

    return (driverProvider.ongoingRide == null)
        ? SizedBox.shrink()
        : OngoingRideCard(
            onTap: () {
              driverProvider.ongoingRide!.otpVerified == true
                  ? context.push('/dropOffNavigation')
                  : context.push('/pickUpNavigation', extra: true);
            },
            ride: ActiveRide(
              id: driverProvider.ongoingRide!.id ?? 0,
              fromLocation: driverProvider.ongoingRide!.fromLocation.toString(),
              toLocation: driverProvider.ongoingRide!.toLocation.toString(),
              status: driverProvider.ongoingRide!.status.toString(),
              otpVerified: driverProvider.ongoingRide!.otpVerified ?? false,
            ),
          );
  }

  Widget _buildGoOnlineSection() {
    final driverProvider = Provider.of<DriverProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            'Go Online',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const Spacer(),
          Consumer<DriverProvider>(
            builder: (_, provider, __) {
              return Switch(
                activeColor: Colors.blue,
                activeTrackColor: Colors.blue.withOpacity(.3),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey[300],
                trackOutlineColor: MaterialStateProperty.all(Colors.white),
                // trackColor: MaterialStateProperty.all(Colors.grey.shade300),
                value: isOnline,
                onChanged: (value) async {
                  await driverProvider.toggleOnlineStatus();
                  setState(() {
                    isOnline = value;
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTodaysEarningsSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Earnings",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                // Earnings
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '₹ 125',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Total',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                // Trips
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '8',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Trips',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                // Rating
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.grey[400]!, width: 2),
                    // borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '4.9',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Rating',
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashLimitSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Cash Limit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const Spacer(),
              Text(
                'Max: \$200',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress Bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.75, // 75% progress
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$150 collected - Submit by today',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildRideRequestsSection() {
    final driverProvider = Provider.of<DriverProvider>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Ride Requests',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const Spacer(),
              // Tab buttons
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTabButton('Live', selectedRideTab == 'Live'),
                    _buildTabButton(
                      'Scheduled',
                      selectedRideTab == 'Scheduled',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRideTab = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 2,

                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.black : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveRideCard() {
    final driverProvider = Provider.of<DriverProvider>(context, listen: false);
    return Consumer<DriverProvider>(
      builder: (context, driverProvider, child) {
        if (driverProvider.nowRides.isEmpty) {
          return const Center(
            child: Text(
              'No available rides',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: driverProvider.nowRides.length,
          itemBuilder: (context, index) {
            final ride = driverProvider.nowRides[index];

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 6,
              ),
              child: InkWell(
                onTap: () {
                  driverProvider.activeRide = ride.id;
                  context.pushNamed('/rideDetail');
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ride.toLocation ?? 'Unknown Location',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '${ride.toLatitude}, ${ride.toLongitude}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '₹${ride.price?.toStringAsFixed(2) ?? '0.00'}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}



//eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzU1MDY4NzExLCJpYXQiOjE3NTQ5ODIzMTEsImp0aSI6ImE0NGY5MzhhODcyMjQ0NzdhMGMyOGM5ZTk0ZTA1NDVkIiwidXNlcl9pZCI6ODZ9.Tu45-vef5Hxvy9fALl4BfNf1VR8PjLI36lomlLf_J9w