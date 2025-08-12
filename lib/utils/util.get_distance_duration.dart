import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:velocyverse/credentials.dart';
import 'package:velocyverse/providers/user/provider.ride.dart';

Future<void> getDistanceAndDuration({
  required double? originLat,
  required double? originLng,
  required double? destLat,
  required double? destLng,
  required BuildContext context,
}) async {
  final apiKey = Credentials.googleMapsAPIKey;

  final origin = "$originLat,$originLng";
  final destination = "$destLat,$destLng";

  final url =
      "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$origin&destinations=$destination&key=$apiKey";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    debugPrint(data.toString());

    final element = data["rows"][0]["elements"][0];
    if (element["status"] == "OK") {
      final distanceMeters = element["distance"]["value"]; // in meters
      final durationText = element["duration"]["text"];

      final rideProvider = Provider.of<RideProvider>(context, listen: false);
      rideProvider.distance = distanceMeters / 1000; // convert to km

      print("Distance (km): ${rideProvider.distance}");
      print("Duration: $durationText");
    } else {
      print("No route found between the given points.");
    }
  } else {
    print("Error: ${response.reasonPhrase}");
  }
}
