import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> makePhoneCall(String phoneNumber) async {
  // Clean the phone number (remove spaces, dashes, etc.)
  final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

  final Uri phoneUri = Uri(scheme: 'tel', path: cleanNumber);

  try {
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch phone dialer';
    }
  } catch (e) {
    debugPrint('Error launching phone dialer: $e');
    // You can show a toast or snackbar here if needed
  }
}
