class RiderHandoverModel {
  RiderHandoverModel({
    required this.vehicleName,
    required this.registrationNumber,
    required this.totalRentPrice,
    required this.securityDeposite,
    required this.handedOverCarKeys,
    required this.handedOverVehicleDocuments,
    required this.fuelTankFull,
    required this.checklistCompletedAt,
  });

  final String? vehicleName;
  final String? registrationNumber;
  final String? totalRentPrice;
  final String? securityDeposite;
  final bool? handedOverCarKeys;
  final bool? handedOverVehicleDocuments;
  final bool? fuelTankFull;
  final String? checklistCompletedAt;

  factory RiderHandoverModel.fromJson(Map<String, dynamic> json) {
    return RiderHandoverModel(
      vehicleName: json["vehicle_name"],
      registrationNumber: json["registration_number"],
      totalRentPrice: json["total_rent_price"],
      securityDeposite: json["security_deposite"],
      handedOverCarKeys: json["handed_over_car_keys"],
      handedOverVehicleDocuments: json["handed_over_vehicle_documents"],
      fuelTankFull: json["fuel_tank_full"],
      checklistCompletedAt: json["checklist_completed_at"],
    );
  }
}
