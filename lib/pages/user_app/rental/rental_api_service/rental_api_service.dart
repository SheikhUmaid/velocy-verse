import 'package:velocyverse/networking/apiservices.dart';
import 'package:velocyverse/pages/user_app/rental/data/rental_model.dart';

class RentalApiService {
  final ApiService _apiService;

  RentalApiService(this._apiService);

  Future<List<RentalModel>> fetchMyGarageVehicles() async {
    try {
      final response = await _apiService.getRequest('/rent/my-garage/');
      final data = response.data as List;
      return data.map((json) => RentalModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
