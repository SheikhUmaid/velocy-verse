import 'package:flutter/material.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:velocyverse/credentials.dart';

class LocationSearch extends StatefulWidget {
  const LocationSearch({super.key});

  @override
  State<LocationSearch> createState() => _LocationSearchState();
}

class _LocationSearchState extends State<LocationSearch> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GooglePlacesAutoCompleteTextFormField(
      textEditingController: controller,
      config: GoogleApiConfig(
        apiKey: Credentials.googleMapsAPIKey,
        // only needed if you build for the web
        countries: const [
          'in',
        ], // optional, by default the list is empty (no restrictions)
        fetchPlaceDetailsWithCoordinates:
            true, // if you require the coordinates from the place details
        debounceTime: 400, // defaults to 600 ms
        locationRestriction: LocationConfig.circle(
          circleCenter: const Coordinates(
            latitude: 52.5200,
            longitude: 13.4050,
          ),
          circleRadiusInKilometers: 1000,
        ), // either this or locationBias (or nothing)
        placeTypeRestriction:
            PlaceType.city, // if you want specific place types
      ),
      // onPlaceDetailsWithCoordinatesReceived: (prediction) {
      //   // this method will return latlng with place detail
      // }, // this callback is called when fetchCoordinates is true
      onPredictionWithCoordinatesReceived: (prediction) {
        debugPrint("Coordinates: (${prediction.lat},${prediction.lng})");
      },
      onSuggestionClicked: (prediction) {
        controller.text = prediction.description!;
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: prediction.description!.length),
        );
      },
    );
  }
}
