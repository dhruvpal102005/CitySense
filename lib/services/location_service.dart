import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<Placemark?> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (placemarks.isNotEmpty) {
        return placemarks.first;
      }
    } catch (e) {
      debugPrint(
        'Native geocoding failed: $e. Trying OSM Nominatim fallback...',
      );
    }

    // If native failed or returned no results, try OSM
    return await _getAddressFromOSM(latitude, longitude);
  }

  Future<Placemark?> _getAddressFromOSM(double lat, double lon) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon&zoom=18&addressdetails=1',
      );

      final response = await http.get(
        url,
        headers: {'User-Agent': 'CitySense/1.0.0 (com.citysense.app)'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final address = data['address'] as Map<String, dynamic>?;

        if (address != null) {
          return Placemark(
            name: data['display_name']?.split(',').first ?? '',
            street: address['road'] ?? '',
            isoCountryCode: address['country_code']?.toUpperCase() ?? '',
            country: address['country'] ?? '',
            postalCode: address['postcode'] ?? '',
            administrativeArea: address['state'] ?? '',
            subAdministrativeArea: address['county'] ?? '',
            locality:
                address['city'] ?? address['town'] ?? address['village'] ?? '',
            subLocality: address['suburb'] ?? address['neighbourhood'] ?? '',
            thoroughfare: address['road'] ?? '',
            subThoroughfare: address['house_number'] ?? '',
          );
        }
      }
    } catch (e) {
      debugPrint('OSM fallback failed: $e');
    }
    return null;
  }
}
