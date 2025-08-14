import 'package:flutter/material.dart';

class OngoingRideCard extends StatelessWidget {
  final ActiveRide ride;
  final VoidCallback? onTap;

  const OngoingRideCard({super.key, required this.ride, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildLocationSection(),
            const SizedBox(height: 16),
            _buildStatusSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.directions_car,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Active Ride',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    final statusConfig = _getStatusConfig();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusConfig['backgroundColor'],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusConfig['borderColor']!, width: 1),
      ),
      child: Text(
        statusConfig['text']!,
        style: TextStyle(
          color: statusConfig['textColor'],
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLocationRow(
            icon: Icons.radio_button_checked,
            label: 'From',
            location: ride.fromLocation,
            iconColor: Colors.black,
          ),
          const SizedBox(height: 16),
          _buildDottedLine(),
          const SizedBox(height: 16),
          _buildLocationRow(
            icon: Icons.location_on,
            label: 'To',
            location: ride.toLocation,
            iconColor: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required String label,
    required String location,
    required Color iconColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                location,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDottedLine() {
    return Padding(
      padding: const EdgeInsets.only(left: 9),
      child: Column(
        children: List.generate(
          4,
          (index) => Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            width: 2,
            height: 3,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ride.otpVerified ? Colors.grey[50] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ride.otpVerified ? Colors.grey[200]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ride.otpVerified ? Colors.black : Colors.grey[600],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              ride.otpVerified ? Icons.verified : Icons.pending,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OTP Verification',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  ride.otpVerified ? 'Verified' : 'Pending',
                  style: TextStyle(
                    color: ride.otpVerified ? Colors.black : Colors.grey[700],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null)
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 24),
        ],
      ),
    );
  }

  Map<String, dynamic> _getStatusConfig() {
    switch (ride.status.toLowerCase()) {
      case 'accepted':
        return {
          'text': 'ACCEPTED',
          'backgroundColor': Colors.black,
          'borderColor': Colors.black,
          'textColor': Colors.white,
        };
      case 'pending':
        return {
          'text': 'PENDING',
          'backgroundColor': Colors.white,
          'borderColor': Colors.grey[400],
          'textColor': Colors.grey[700],
        };
      case 'completed':
        return {
          'text': 'COMPLETED',
          'backgroundColor': Colors.grey[800],
          'borderColor': Colors.grey[800],
          'textColor': Colors.white,
        };
      case 'cancelled':
        return {
          'text': 'CANCELLED',
          'backgroundColor': Colors.white,
          'borderColor': Colors.grey[500],
          'textColor': Colors.grey[600],
        };
      default:
        return {
          'text': ride.status.toUpperCase(),
          'backgroundColor': Colors.white,
          'borderColor': Colors.grey[400],
          'textColor': Colors.grey[700],
        };
    }
  }
}

// Demo screen to showcase the active ride card
class ActiveRideDemo extends StatefulWidget {
  const ActiveRideDemo({super.key});

  @override
  State<ActiveRideDemo> createState() => _ActiveRideDemoState();
}

class _ActiveRideDemoState extends State<ActiveRideDemo> {
  late List<ActiveRide> _rides;

  @override
  void initState() {
    super.initState();
    _initializeRides();
  }

  void _initializeRides() {
    _rides = [
      ActiveRide(
        id: 256,
        fromLocation: "J999+JM5, Sector 62, Noida, Uttar Pradesh, India",
        toLocation: "Sector 62 Noida, Sector 62, Noida, Uttar Pradesh, India",
        status: "accepted",
        otpVerified: true,
      ),
      ActiveRide(
        id: 257,
        fromLocation: "DLF Cyber City, Sector 25, Gurugram, Haryana, India",
        toLocation: "IGI Airport, Terminal 3, New Delhi, India",
        status: "pending",
        otpVerified: false,
      ),
      ActiveRide(
        id: 258,
        fromLocation: "Connaught Place, New Delhi, India",
        toLocation: "India Gate, Rajpath, New Delhi, India",
        status: "completed",
        otpVerified: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Active Rides',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: _rides.length,
        itemBuilder: (context, index) {
          return OngoingRideCard(
            ride: _rides[index],
            onTap: () => _showRideDetails(_rides[index]),
          );
        },
      ),
    );
  }

  void _showRideDetails(ActiveRide ride) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Ride Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Ride ID', ride.id.toString()),
            const SizedBox(height: 12),
            _buildDetailRow('Status', ride.status.toUpperCase()),
            const SizedBox(height: 12),
            _buildDetailRow('OTP Verified', ride.otpVerified ? 'Yes' : 'No'),
            const SizedBox(height: 16),
            Text(
              'From:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              ride.fromLocation,
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Text(
              'To:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              ride.toLocation,
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// Data Model
class ActiveRide {
  final int id;
  final String fromLocation;
  final String toLocation;
  final String status;
  final bool otpVerified;

  ActiveRide({
    required this.id,
    required this.fromLocation,
    required this.toLocation,
    required this.status,
    required this.otpVerified,
  });

  factory ActiveRide.fromJson(Map<String, dynamic> json) {
    return ActiveRide(
      id: json['id'],
      fromLocation: json['from_location'],
      toLocation: json['to_location'],
      status: json['status'],
      otpVerified: json['otp_verified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from_location': fromLocation,
      'to_location': toLocation,
      'status': status,
      'otp_verified': otpVerified,
    };
  }
}
