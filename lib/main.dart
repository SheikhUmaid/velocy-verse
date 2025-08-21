import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:flutter/services.dart';
import 'package:velocyverse/app.dart';
import 'package:velocyverse/networking/apiservices.dart';
import 'package:velocyverse/networking/notification_services.dart';
import 'package:velocyverse/pages/user_app/rental/rental_api_service/rental_api_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("📩 Handling background message: ${message.messageId}");
  debugPrint("Data: ${message.data}");
  if (message.notification != null) {
    debugPrint("Notification Title: ${message.notification!.title}");
    debugPrint("Notification Body: ${message.notification!.body}");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final apiService = ApiService();
  final rentalApiService = RentalApiService(apiService);

  await NotificationService().init();
  final token = await NotificationService().getFcmToken();
  print("fcm token = $token");
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  print('sending token $token');
  NotificationService().fcmToken = token;

  runApp(MyApp(rentalApiService: rentalApiService));
}
