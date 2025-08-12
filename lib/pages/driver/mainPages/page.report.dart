import 'package:flutter/material.dart';

class EarningsReportsScreen extends StatelessWidget {
  const EarningsReportsScreen({Key? key}) : super(key: key);

  static const double _horizontalPadding = 16.0;
  static const double _verticalSpacing = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Earnings & Reports"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
        children: [
          const SizedBox(height: _verticalSpacing),
          _EarningsSummary(),
          const SizedBox(height: _verticalSpacing),
          const _EarningsPeriodSelector(),
          const SizedBox(height: 20),
          const _IncentiveTracker(),
          const SizedBox(height: _verticalSpacing),
          const _AvailablePayout(),
          const SizedBox(height: _verticalSpacing),
          const _RecentRides(),
        ],
      ),
    );
  }
}

class _EarningsSummary extends StatelessWidget {
  const _EarningsSummary();

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
              children: const [
                Text(
                  '\$1,248.50',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                ),
                Spacer(),
                Text(
                  'This Week',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _InfoBox(label: "Today", value: "\$245.00"),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoBox(label: "Yesterday", value: "\$198.50"),
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
  const _IncentiveTracker();

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
                  'Incentive Tracker',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                Spacer(),
                Text(
                  '4 days left',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 18 / 25,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Text(
                  'Progress',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(width: 6),
                Text(
                  '18/25 rides',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Complete 7 more rides to earn \$150 bonus',
              style: TextStyle(color: Colors.black87, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvailablePayout extends StatelessWidget {
  const _AvailablePayout();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Available for instant payout',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  '\$245.00',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {},
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
            _RideHistoryTile(
              icon: Icons.directions_car_outlined,
              title: "Downtown - Airport",
              dateTime: "Today, 2:30 PM",
              fare: '\$24.50',
            ),
            const Divider(),
            _RideHistoryTile(
              icon: Icons.directions_car_outlined,
              title: "Westside Mall - Central Station",
              dateTime: "Today, 11:45 AM",
              fare: '\$18.75',
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
      child: Row(
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
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
