import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:velocyverse/app.dart';
import 'package:velocyverse/networking/apiservices.dart';
import 'package:velocyverse/pages/user_app/rental/rental_api_service/rental_api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final apiService = ApiService();
  final rentalApiService = RentalApiService(apiService);
  final signature = await SmsAutoFill().getAppSignature;
  debugPrint("App Signature: $signature");
  runApp(MyApp(rentalApiService: rentalApiService));
}
