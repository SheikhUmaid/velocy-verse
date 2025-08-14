import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/providers/driver/provider.rideHistory.dart';

class DriverRecentRides extends StatefulWidget {
  const DriverRecentRides({Key? key}) : super(key: key);

  @override
  State<DriverRecentRides> createState() => _DriverRecentRidesState();
}

class _DriverRecentRidesState extends State<DriverRecentRides> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      print("Fetching recent rides");
      bool success = await Provider.of<RecentRidesProvider>(
        context,
        listen: false,
      ).fetchRideHistory();
      if (!success) {
        debugPrint("Failed to fetch ride history");
      }
    });
  }

  Future<bool> _willPop() async {
    context.go('/driverMain');
    print('popping ');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final rideProvider = Provider.of<RecentRidesProvider>(context);

    return WillPopScope(
      onWillPop: _willPop,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Recent',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'History'),
                Tab(text: 'Scheduled'),
                Tab(text: 'Cancelled'),
              ],
            ),
          ),

          body: TabBarView(
            children: [
              //? Completed
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Builder(
                  builder: (context) {
                    if (rideProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (rideProvider.rideHistory == null) {
                      return const Center(child: Text("No rides found"));
                    }

                    final completedRides =
                        rideProvider.rideHistory!.completedRides;

                    if (completedRides.isEmpty) {
                      return const Center(child: Text("No recent rides"));
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemCount: completedRides.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 20),
                      itemBuilder: (context, index) {
                        final ride = completedRides[index];
                        return _buildRideCard(
                          context: context,
                          time:
                              "${ride.date ?? 'N/A'}, ${ride.startTime ?? 'N/A'}",
                          pickupLocation: ride.fromLocation.toString(),
                          dropLocation: ride.toLocation.toString(),
                          payment: "₹${ride.amountReceived ?? 0}",
                          distance: ride.distance!.toInt().toString() + " km",
                          rideId: ride.id ?? 0,
                        );
                      },
                    );
                  },
                ),
              ),
              //  ?Scheduled
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Builder(
                  builder: (context) {
                    if (rideProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (rideProvider.rideHistory == null) {
                      return const Center(child: Text("No rides found"));
                    }

                    final completedRides =
                        rideProvider.rideHistory!.scheduledRides;

                    if (completedRides.isEmpty) {
                      return const Center(child: Text("No recent rides"));
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemCount: completedRides.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 20),
                      itemBuilder: (context, index) {
                        final ride = completedRides[index];
                        return _buildRideCard(
                          context: context,
                          time:
                              "${ride.date ?? 'N/A'}, ${ride.startTime ?? 'N/A'}",
                          pickupLocation: ride.fromLocation.toString(),
                          dropLocation: ride.toLocation.toString(),
                          payment: "₹${ride.amountReceived ?? 0}",
                          distance: ride.distance!.toInt().toString() + " km",
                          rideId: ride.id ?? 0,
                        );
                      },
                    );
                  },
                ),
              ),
              // ? Cancelled
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Builder(
                  builder: (context) {
                    if (rideProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (rideProvider.rideHistory == null) {
                      return const Center(child: Text("No rides found"));
                    }

                    final completedRides =
                        rideProvider.rideHistory!.cancelledRides;

                    if (completedRides.isEmpty) {
                      return const Center(child: Text("No recent rides"));
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemCount: completedRides.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 20),
                      itemBuilder: (context, index) {
                        final ride = completedRides[index];
                        return _buildRideCard(
                          context: context,
                          time:
                              "${ride.date ?? 'N/A'}, ${ride.startTime ?? 'N/A'}",
                          pickupLocation: ride.fromLocation.toString(),
                          dropLocation: ride.toLocation.toString(),
                          payment: "₹${ride.amountReceived ?? 0}",
                          distance: ride.distance!.toInt().toString() + " km",
                          rideId: ride.id ?? 0,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRideCard({
    required BuildContext context,
    required int rideId,
    required String time,
    required String pickupLocation,
    required String dropLocation,
    required String payment,
    required String distance,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          context.push('/recentRideDetails', extra: rideId.toString());
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 50,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: CustomPaint(painter: DottedLinePainter()),
                    ),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              pickupLocation,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Payment',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                payment,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              dropLocation,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Distance',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                distance,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashHeight = 3.0;
    const dashSpace = 2.0;
    double startY = 0;
    final paint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = 2.0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
