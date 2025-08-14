import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/models/model.earningsNreport.dart';
import 'package:velocyverse/providers/driver/provider.earningNreport.dart';
import 'package:velocyverse/providers/driver/provider.rideHistory.dart';
import 'package:velocyverse/providers/payment/provider.payment.dart';

class DriverReports extends StatefulWidget {
  const DriverReports({Key? key}) : super(key: key);

  static const double _horizontalPadding = 16.0;
  static const double _verticalSpacing = 16.0;

  @override
  State<DriverReports> createState() => _DriverReportsState();
}

class _DriverReportsState extends State<DriverReports> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      print("Fetching recent rides");
      bool success = await Provider.of<RaningsNreportsProvider>(
        context,
        listen: false,
      ).fetchEarningsNReport();
      if (!success) {
        debugPrint("Failed to fetch earnings");
      }
    });
    //
    Future.microtask(() async {
      print("Fetching recent rides");
      bool success = await Provider.of<RecentRidesProvider>(
        context,
        listen: false,
      ).fetchRideHistory();
      if (!success) {
        debugPrint("Failed to fetch earnings");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final earningsProvider = Provider.of<RaningsNreportsProvider>(context);
    final paymentProvider = Provider.of<PaymentProvider>(
      context,
      listen: false,
    );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Earnings & Reports"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () => Navigator.pop(context),
        // ),
      ),
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context) {
          if (earningsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (earningsProvider.earnings == null) {
            return const Center(child: Text("No earnings data available"));
          }
          final earnings = earningsProvider.earnings!;
          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: DriverReports._horizontalPadding,
            ),
            children: [
              const SizedBox(height: DriverReports._verticalSpacing),
              _EarningsSummary(earnings),
              const SizedBox(height: DriverReports._verticalSpacing),
              // const _EarningsPeriodSelector(),
              const SizedBox(height: 20),
              _IncentiveTracker(earnings),
              const SizedBox(height: DriverReports._verticalSpacing),
              _AvailablePayout(earnings),
              const SizedBox(height: DriverReports._verticalSpacing),
              _RecentRides(),
            ],
          );
        },
      ),
    );
  }
}

class _EarningsSummary extends StatelessWidget {
  final EarningsNreportModel earnings;
  const _EarningsSummary(this.earnings);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: const Color(0xFFF6F6F7),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '₹${earnings.totalEarnings}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                ),
                Spacer(),
                Text(
                  'Total Earnings',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _InfoBox(
                    label: "Today",
                    value: "₹${earnings.todayEarnings}",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoBox(
                    label: "Yesterday",
                    value: "₹${earnings.yesterdayEarnings}",
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

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;
  const _InfoBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 15, color: Colors.grey)),
        ],
      ),
    );
  }
}

class _EarningsPeriodSelector extends StatelessWidget {
  const _EarningsPeriodSelector();

  @override
  Widget build(BuildContext context) {
    // Illustrative only, hard coded on Daily as in image
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _PeriodButton(label: "Daily", isActive: true),
        const SizedBox(width: 14),
        _PeriodButton(label: "Weekly"),
        const SizedBox(width: 14),
        _PeriodButton(label: "Monthly"),
      ],
    );
  }
}

class _PeriodButton extends StatelessWidget {
  final String label;
  final bool isActive;
  const _PeriodButton({required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.black : const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black87,
          fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
    );
  }
}

class _IncentiveTracker extends StatelessWidget {
  final EarningsNreportModel earnings;
  const _IncentiveTracker(this.earnings);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Text(
                  'Cash acceptance limit',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                // Spacer(),
                // Text(
                //   '4 days left',
                //   style: TextStyle(color: Colors.grey, fontSize: 14),
                // ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: (earnings.remainingCashLimit ?? 0).toDouble() / 5,
              backgroundColor: Colors.grey[300],
              color: Colors.black,
              minHeight: 8,
              borderRadius: BorderRadius.circular(12),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class _AvailablePayout extends StatelessWidget {
  final EarningsNreportModel earnings;
  const _AvailablePayout(this.earnings);

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(
      context,
      listen: false,
    );
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available for payout',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '₹${earnings.totalEarnings}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                paymentProvider.openCheckout(
                  amount: 500,
                  name: "John Doe",
                  contact: "9999999999",
                  email: "john@example.com",
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Text('Cash Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentRides extends StatelessWidget {
  const _RecentRides();

  @override
  Widget build(BuildContext context) {
    final recentRidesProvider = Provider.of<RecentRidesProvider>(context);
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Rides',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Builder(
              builder: (context) {
                if (recentRidesProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (recentRidesProvider.rideHistory?.completedRides ==
                    null) {
                  return Center(child: Text("No recent rides"));
                }
                final rides = recentRidesProvider.rideHistory?.completedRides;
                return ListView.builder(
                  itemCount: rides?.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var ride = rides![index];
                    return _RideHistoryTile(
                      icon: Icons.directions_car_outlined,
                      title: "${ride.fromLocation} - ${ride.toLocation}",
                      dateTime: "${ride.date} ${ride.startTime}",
                      fare: '₹${ride.amountReceived}',
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RideHistoryTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String dateTime;
  final String fare;

  const _RideHistoryTile({
    required this.icon,
    required this.title,
    required this.dateTime,
    required this.fare,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 26, color: Colors.black54),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dateTime,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Text(
                fare,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
