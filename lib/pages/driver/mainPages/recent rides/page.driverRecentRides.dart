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
      debugPrint("Fetching recent rides");
      bool success = await Provider.of<RecentRidesProvider>(
        context,
        listen: false,
      ).fetchRideHistory();
      if (!success) debugPrint("Failed to fetch ride history");
    });
  }

  Future<bool> _willPop() async {
    context.go('/driverMain');
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
            bottom: const TabBar(
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'History'),
                Tab(text: 'Scheduled'),
                Tab(text: 'Cancelled'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildRideList(rideProvider, RideType.completed),
              _buildRideList(rideProvider, RideType.scheduled),
              _buildRideList(rideProvider, RideType.cancelled),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRideList(RecentRidesProvider provider, RideType type) {
    if (provider.isLoading)
      return const Center(child: CircularProgressIndicator());
    if (provider.rideHistory == null)
      return const Center(child: Text("No rides found"));

    final rides = switch (type) {
      RideType.completed => provider.rideHistory!.completedRides,
      RideType.scheduled => provider.rideHistory!.scheduledRides,
      RideType.cancelled => provider.rideHistory!.cancelledRides,
    };

    if (rides.isEmpty) return const Center(child: Text("No recent rides"));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: rides.length,
        separatorBuilder: (_, __) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          final ride = rides[index];
          return _buildRideCard(
            context: context,
            time: "${ride.date ?? 'N/A'}, ${ride.startTime ?? 'N/A'}",
            pickupLocation: ride.fromLocation.toString(),
            dropLocation: ride.toLocation.toString(),
            payment: "₹${ride.amountReceived ?? 0}",
            distance: "${ride.distance?.toInt() ?? 0} km",
            rideId: ride.id ?? 0,
          );
        },
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
        onTap: () =>
            context.push('/recentRideDetails', extra: rideId.toString()),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRideInfoRow(pickupLocation, 'Payment', payment),
                      const SizedBox(height: 24),
                      _buildRideInfoRow(dropLocation, 'Distance', distance),
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

  Widget _buildRideInfoRow(String location, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            location,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}

enum RideType { completed, scheduled, cancelled }

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashHeight = 3.0;
    const dashSpace = 2.0;
    double startY = 0;
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
