import 'package:flutter/material.dart';
import 'package:velocyverse/app.dart';
import 'package:velocyverse/networking/apiservices.dart';
import 'package:velocyverse/pages/user_app/rental/rental_api_service/rental_api_service.dart';

void main() {
  final apiService = ApiService();
  final rentalApiService = RentalApiService(apiService);
  runApp(MyApp(rentalApiService: rentalApiService));
}
