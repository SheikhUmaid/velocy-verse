class HandoverModel {
  final int? id;
  final String? vehicleName;
  final String? vehicleImage;
  final String? licenseDocument;
  final String? totalRentPrice;
  final String? securityDeposite;
  final bool? handedOverCarKeys;
  final bool? handedOverVehicleDocuments;
  final bool? fuelTankFull;
  HandoverModel({
    required this.id,
    required this.vehicleName,
    required this.vehicleImage,
    required this.licenseDocument,
    required this.totalRentPrice,
    required this.securityDeposite,
    required this.handedOverCarKeys,
    required this.handedOverVehicleDocuments,
    required this.fuelTankFull,
  });

  factory HandoverModel.fromJson(Map<String, dynamic> json) {
    return HandoverModel(
      id: json["id"],
      vehicleName: json["vehicle_name"],
      vehicleImage: json["vehicle_image"],
      licenseDocument: json["license_document"],
      totalRentPrice: json["total_rent_price"],
      securityDeposite: json["security_deposite"],
      handedOverCarKeys: json["handed_over_car_keys"],
      handedOverVehicleDocuments: json["handed_over_vehicle_documents"],
      fuelTankFull: json["fuel_tank_full"],
    );
  }
}
