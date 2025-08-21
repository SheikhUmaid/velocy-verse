import 'dart:io';
import 'package:dio/dio.dart';
// import 'package:dio/dio.dart' as dio;
import 'package:velocyverse/networking/apiservices.dart';
import 'package:velocyverse/pages/user_app/ride_share/data/find_sharing_rides_model.dart';
import 'package:velocyverse/pages/user_app/ride_share/data/my_rides_model.dart';
import 'package:velocyverse/pages/user_app/ride_share/data/my_vehicles_model.dart';
import 'package:velocyverse/pages/user_app/ride_share/data/shared_ride_details_model.dart';

class RideShareApiService {
  final ApiService _apiService;

  RideShareApiService(this._apiService);

  Future<FindSharingRidesModel> fetchAvailableRides(
    String fromLocation,
    String toLocation,
    DateTime date,
    int seats,
  ) async {
    try {
      final formattedDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      final response = await _apiService.getRequest(
        "sharing/search/?from=Kengeri&to=Mysuru Palace&date=2025-07-24&seats_required=3",
        // 'sharing/search/?from=$fromLocation&to=$toLocation Palace&date=$formattedDate&seats_required=$seats',
      );
      return FindSharingRidesModel.fromJson(response.data);
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<SharedRideDetailsResponseModel> fetchRideShareDetails(
    int rideId,
    int segmentId,
  ) async {
    try {
      final response = await _apiService.getRequest(
        "sharing/sharing-ride-details/?ride_id=$rideId&segment_id=$segmentId",
      );
      return SharedRideDetailsResponseModel.fromJson(response.data);
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<MyRidesResponseModel> fetchMyRidesRequest() async {
    try {
      final response = await _apiService.getRequest(
        "sharing/my-published-rides/",
      );
      return MyRidesResponseModel.fromJson(response.data);
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<MyVehiclesResponseModel> fetchMyVehiclesRequest() async {
    try {
      final response = await _apiService.getRequest("sharing/my-vehicles/");
      return MyVehiclesResponseModel.fromJson(response.data);
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<void> addVehiclesForRideSharing({
    required String vehicleNumber,
    required String modelName,
    required int seatCapacity,
    required File aadharCard,
    required File drivingLicense,
    required File registrationDoc,
  }) async {
    try {
      final formData = FormData.fromMap({
        'vehicle_number': vehicleNumber,
        'model_name': modelName,
        'seat_capacity': seatCapacity,
        'aadhar_card': await MultipartFile.fromFile(
          aadharCard.path,
          filename: aadharCard.path.split('/').last,
        ),
        'driving_license': await MultipartFile.fromFile(
          drivingLicense.path,
          filename: drivingLicense.path.split('/').last,
        ),
        'registration_doc': await MultipartFile.fromFile(
          registrationDoc.path,
          filename: registrationDoc.path.split('/').last,
        ),
      });

      final response = await _apiService.postRequest(
        "sharing/add-vehicle/",
        data: formData,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Failed to add vehicle");
      }
    } catch (e) {
      throw Exception("Error adding vehicle: $e");
    }
  }
}
