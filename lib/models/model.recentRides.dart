class DriverRecentRidesModel {
  DriverRecentRidesModel({
    required this.status,
    required this.message,
    required this.completedRides,
    required this.cancelledRides,
    required this.scheduledRides,
  });

  final bool? status;
  final String? message;
  final List<EdRide> completedRides;
  final List<EdRide> cancelledRides;
  final List<EdRide> scheduledRides;

  factory DriverRecentRidesModel.fromJson(Map<String, dynamic> json) {
    return DriverRecentRidesModel(
      status: json["status"],
      message: json["message"],
      completedRides: json["completed_rides"] == null
          ? []
          : List<EdRide>.from(
              json["completed_rides"]!.map((x) => EdRide.fromJson(x)),
            ),
      cancelledRides: json["cancelled_rides"] == null
          ? []
          : List<EdRide>.from(
              json["cancelled_rides"]!.map((x) => EdRide.fromJson(x)),
            ),
      scheduledRides: json["upcoming_rides"] == null
          ? []
          : List<EdRide>.from(
              json["upcoming_rides"]!.map((x) => EdRide.fromJson(x)),
            ),
    );
  }
}

class EdRide {
  EdRide({
    required this.id,
    required this.fromLocation,
    required this.toLocation,
    required this.date,
    required this.startTime,
    required this.amountReceived,
    required this.paymentMethod,
    required this.distance,
  });

  final int? id;
  final String? fromLocation;
  final String? toLocation;
  final String? date;
  final String? startTime;
  final double? amountReceived;
  final String? paymentMethod;
  final double? distance;

  factory EdRide.fromJson(Map<String, dynamic> json) {
    return EdRide(
      id: json["id"],
      fromLocation: json["from_location"],
      toLocation: json["to_location"],
      date: json["date"],
      startTime: json["start_time"],
      amountReceived: json["amount_received"],
      paymentMethod: json["payment_method"],
      distance: json["distance"],
    );
  }
}
