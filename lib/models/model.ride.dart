// lib/models/ride_history.dart

class Ride {
  final int id;
  final String fromLocation;
  final String toLocation;
  final String date;
  final String startTime;
  final double amountPaid;

  Ride({
    required this.id,
    required this.fromLocation,
    required this.toLocation,
    required this.date,
    required this.startTime,
    required this.amountPaid,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'] ?? 0,
      fromLocation: json['from_location'] ?? '',
      toLocation: json['to_location'] ?? '',
      date: json['date'] ?? '',
      startTime: json['start_time'] ?? '',
      amountPaid: (json['amount_paid'] ?? 0).toDouble(),
    );
  }
}

class RideHistory {
  final List<Ride> completedRides;
  final List<Ride> scheduledRides;
  final List<Ride> cancelledRides;

  RideHistory({
    required this.completedRides,
    required this.scheduledRides,
    required this.cancelledRides,
  });

  factory RideHistory.fromJson(Map<String, dynamic> json) {
    return RideHistory(
      completedRides: (json['completed_rides'] as List<dynamic>)
          .map((ride) => Ride.fromJson(ride))
          .toList(),
      scheduledRides: (json['scheduled_rides'] ?? [])
          .map<Ride>((ride) => Ride.fromJson(ride))
          .toList(),
      cancelledRides: (json['cancelled_rides'] ?? [])
          .map<Ride>((ride) => Ride.fromJson(ride))
          .toList(),
    );
  }
}
