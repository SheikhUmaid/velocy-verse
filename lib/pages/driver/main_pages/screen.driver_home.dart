import 'package:VelocyTaxzz/models/model.earningsNreport.dart';
import 'package:VelocyTaxzz/providers/driver/provider.earningNreport.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:VelocyTaxzz/components/driver/component.ongoingRide.dart';
import 'package:VelocyTaxzz/providers/driver/provider.driver.dart';
import 'package:VelocyTaxzz/providers/driver/provider.driver_profile.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  bool isOnline = false;
  String selectedRideTab = 'Live';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      // ?Fetch earning
      final earningsProvider = Provider.of<EaningsNreportsProvider>(
        context,
        listen: false,
      );

      bool earningsSuccess = await earningsProvider.fetchEarningsNReport();
      if (!earningsSuccess) debugPrint("Failed to fetch earnings");
    });
  }

  @override
  Widget build(BuildContext context) {
    final driverProvider = Provider.of<DriverProvider>(context, listen: false);
    driverProvider.driverINIT();
    final earningsProvider = Provider.of<EaningsNreportsProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;
            bool isTablet = width > 600; // adjust breakpoint as needed

            return Column(
              children: [
                _buildHeader(width),
                SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? width * 0.1 : 16.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildOngoingRideSection(context),

                          const SizedBox(height: 20),
                          _buildGoOnlineSection(),
                          const SizedBox(height: 20),
                          isTablet
                              ? Builder(
                                  builder: (context) {
                                    if (earningsProvider.isLoading) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (earningsProvider.earnings !=
                                        null) {
                                      return Row(
                                        children: [
                                          _buildTodaysEarningsSection(
                                            earningsProvider.earnings!,
                                          ),
                                          const SizedBox(width: 20),
                                          Expanded(
                                            child: _buildCashLimitSection(
                                              earningsProvider.earnings!,
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                    return SizedBox.shrink();
                                  },
                                )
                              : Builder(
                                  builder: (context) {
                                    if (earningsProvider.isLoading) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (earningsProvider.earnings !=
                                        null) {
                                      return Column(
                                        children: [
                                          _buildTodaysEarningsSection(
                                            earningsProvider.earnings!,
                                          ),
                                          const SizedBox(height: 20),
                                          _buildCashLimitSection(
                                            earningsProvider.earnings!,
                                          ),
                                        ],
                                      );
                                    }
                                    return SizedBox.shrink();
                                  },
                                ),
                          const SizedBox(height: 20),
                          _buildRideRequestsSection(),
                          const SizedBox(height: 20),
                          Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 500),
                              child: _buildActiveRideCard(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(double width) {
    final driverProfileProvider = Provider.of<DriverProfileProvider>(
      context,
      listen: true,
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width > 600 ? width * 0.1 : 16,
        vertical: 16,
      ),
      color: Colors.white,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage:
                      driverProfileProvider.profileDetails!.profileImage != null
                      ? NetworkImage(
                          driverProfileProvider.profileDetails!.profileImage!,
                        )
                      : null,
                  child:
                      driverProfileProvider.profileDetails!.profileImage == null
                      ? Icon(Icons.person, size: 28, color: Colors.grey[600])
                      : null,
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
                  ],
                ),
              ],
            ),
          ),
          // const Spacer(),
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(Icons.notifications_outlined),
          //   color: Colors.grey[700],
          // ),
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

  Widget _buildTodaysEarningsSection(EarningsNreportModel earnings) {
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
            "Earnings",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      earnings.totalEarnings!.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text('Total', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      earnings.todayEarnings.toString(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text('Today\'s', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      earnings.yesterdayEarnings.toString(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text('Yesterday', style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCashLimitSection(EarningsNreportModel earnings) {
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
                'Cash acceptance limit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              // const Spacer(),
              // Text('Max: \$200', style: TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: (earnings.remainingCashLimit ?? 0).toDouble() / 5,
            backgroundColor: Colors.grey[300],
            color: Colors.black,
            minHeight: 8,
            borderRadius: BorderRadius.circular(12),
          ),
          // const SizedBox(height: 8),
          // const Text(
          //   '\$150 collected - Submit by today',
          //   style: TextStyle(fontSize: 12),
          // ),
        ],
      ),
    );
  }

  Widget _buildRideRequestsSection() {
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
