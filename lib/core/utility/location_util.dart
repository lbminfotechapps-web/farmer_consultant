import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationUtil {
  LocationUtil._();

  static final LocationUtil instance = LocationUtil._();

  final Geocoding _geocoding = Geocoding();

  Future<Position?> getCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (e) {
      return null;
    }
  }

  Future<String> getCityName(double latitude, double longitude) async {
    try {
      final places = await _geocoding.placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (places.isEmpty) return '';
      final place = places.first;
      for (final name in [place.locality, place.subAdministrativeArea]) {
        if (name != null && name.trim().isNotEmpty) return name.trim();
      }
      return '';
    } catch (_) {
      return '';
    }
  }

  Future<String> getAddress(double latitude, double longitude) async {
    try {
      final placemarks = await _geocoding.placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isEmpty) {
        return '';
      }

      final place = placemarks.first;

      final addressParts = <String>[
        place.name ?? '',
        place.street ?? '',
        place.subLocality ?? '',
        place.locality ?? '',
        place.administrativeArea ?? '',
        place.postalCode ?? '',
        place.country ?? '',
      ];

      return formatAddressParts(addressParts);
    } catch (e) {
      return '';
    }
  }
}

String formatAddressParts(Iterable<String> parts) {
  final result = <String>[];
  final normalized = <String>[];

  for (final part in parts.expand((part) => part.split(','))) {
    final value = part.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (value.isEmpty) continue;
    final key = value.toLowerCase();
    // Whole-token matching avoids treating "Nagar" as "Ahmednagar".
    if (normalized.any(
      (existing) => existing == key || ' $existing '.contains(' $key '),
    )) {
      continue;
    }
    result.add(value);
    normalized.add(key);
  }

  return result.join(', ');
}
