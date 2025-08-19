import 'package:velocyverse/networking/apiservices.dart';
import 'package:velocyverse/pages/user_app/ride_share/data/find_sharing_rides_model.dart';
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
}
