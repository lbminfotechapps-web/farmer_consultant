import 'package:dio/dio.dart';
import 'package:farmer_consultant/core/utility/location_util.dart';
import 'package:farmer_consultant/features/weather/weather_model.dart';
import 'package:flutter/foundation.dart';

// Add your WeatherModel and LocationUtil imports.

class WeatherService {
  final Dio _dio = Dio();

  Future<WeatherModel> getWeather() async {
    final position = await LocationUtil.instance.getCurrentLocation();

    if (position == null) {
      throw Exception(
        'Unable to get current location. Please enable location permission and GPS.',
      );
    }

    final latitude = position.latitude;
    final longitude = position.longitude;

    debugPrint('Weather latitude: $latitude');
    debugPrint('Weather longitude: $longitude');

    try {
      final response = await _dio.get(
        'https://api.open-meteo.com/v1/forecast',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'current':
              'temperature_2m,relative_humidity_2m,'
              'apparent_temperature,weather_code,wind_speed_10m',
          'hourly': 'temperature_2m,wind_speed_10m',
          'daily': 'weather_code,temperature_2m_max,temperature_2m_min',
          'temperature_unit': 'celsius',
          'wind_speed_unit': 'kmh',
          'timezone': 'auto',
          'forecast_days': 7,
        },
      );

      if (response.statusCode != 200 || response.data is! Map) {
        throw Exception('Invalid weather response');
      }

      return WeatherModel.fromJson(
        Map<String, dynamic>.from(response.data as Map),
        cityName: await LocationUtil.instance.getCityName(latitude, longitude),
      );
    } on DioException catch (e) {
      throw Exception('Weather request failed: ${e.message}');
    }
  }
}
