import 'package:farmer_consultant/features/weather/weather_model.dart';
import 'package:farmer_consultant/features/weather/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Import WeatherService and WeatherModel here.

class WeatherCardDialog extends StatefulWidget {
  const WeatherCardDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const WeatherCardDialog(),
    );
  }

  @override
  State<WeatherCardDialog> createState() => _WeatherCardDialogState();
}

class _WeatherCardDialogState extends State<WeatherCardDialog> {
  late Future<WeatherModel> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  void _fetchWeather() {
    _weatherFuture = WeatherService().getWeather();
  }

  void _retry() {
    setState(_fetchWeather);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: 360,
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF365B8B), Color(0xFF5084AE), Color(0xFF83B8D8)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
              child: FutureBuilder<WeatherModel>(
                future: _weatherFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const SizedBox(
                      height: 280,
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  }

                  if (snapshot.hasError || !snapshot.hasData) {
                    return _buildError(
                      snapshot.error?.toString() ?? 'Weather unavailable',
                    );
                  }

                  return _buildWeatherContent(snapshot.data!);
                },
              ),
            ),

            Positioned(
              right: 9,
              top: 8,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherContent(WeatherModel weather) {
    // Daily forecast starts with today.
    // Include today and the following six days.
    final forecast = weather.daily.take(7).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          weather.cityName.isNotEmpty ? weather.cityName : 'Current Location',
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 10),

        Icon(
          _weatherIcon(weather.weatherCode, isDay: weather.isDay),
          size: 64,
          color: _weatherIconColor(weather.weatherCode),
        ),

        const SizedBox(height: 6),

        Text(
          _weatherDescription(weather.weatherCode),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          '${weather.currentTemperature.round()}°',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 62,
            height: 1.15,
            fontWeight: FontWeight.w300,
          ),
        ),

        const SizedBox(height: 5),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Feels like ${weather.feelsLike.round()}°',
              style: const TextStyle(color: Color(0xFFEAF4FF), fontSize: 12),
            ),
            const SizedBox(width: 14),
            Text(
              'Wind ${weather.currentWindSpeed.round()} km/h',
              style: const TextStyle(color: Color(0xFFEAF4FF), fontSize: 12),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(15),
          ),
          child: forecast.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Forecast unavailable',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Column(
                  children: List.generate(forecast.length, (index) {
                    final day = forecast[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              index == 0
                                  ? 'Today'
                                  : DateFormat('EEEE').format(day.date),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Icon(
                            _weatherIcon(day.weatherCode),
                            size: 23,
                            color: _weatherIconColor(day.weatherCode),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 45,
                            child: Text(
                              '${day.maxTemperature.round()}°',
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
        ),

        const SizedBox(height: 8),

        Text(
          'Humidity ${weather.humidity.round()}%',
          style: const TextStyle(color: Color(0xFFE5F2FC), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildError(String message) {
    return SizedBox(
      height: 260,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off_rounded, size: 52, color: Colors.white),
          const SizedBox(height: 15),
          const Text(
            'Unable to load weather',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
          const SizedBox(height: 14),
          FilledButton(onPressed: _retry, child: const Text('Retry')),
        ],
      ),
    );
  }

  static IconData _weatherIcon(int code, {bool isDay = true}) {
    if (code == 0) {
      return isDay ? Icons.wb_sunny_rounded : Icons.nightlight_round;
    }

    if (code == 1 || code == 2) {
      return Icons.wb_cloudy_rounded;
    }

    if (code == 3) {
      return Icons.cloud_rounded;
    }

    if (code == 45 || code == 48) {
      return Icons.foggy;
    }

    if ([51, 53, 55, 56, 57].contains(code)) {
      return Icons.grain_rounded;
    }

    if ([61, 63, 65, 66, 67, 80, 81, 82].contains(code)) {
      return Icons.water_drop_rounded;
    }

    if ([71, 73, 75, 77, 85, 86].contains(code)) {
      return Icons.ac_unit_rounded;
    }

    if ([95, 96, 99].contains(code)) {
      return Icons.thunderstorm_rounded;
    }

    return Icons.cloud_rounded;
  }

  static Color _weatherIconColor(int code) {
    if (code == 0 || code == 1 || code == 2) {
      return const Color(0xFFFFDD62);
    }

    return Colors.white;
  }

  static String _weatherDescription(int code) {
    switch (code) {
      case 0:
        return 'Clear Sky';
      case 1:
        return 'Mostly Sunny';
      case 2:
        return 'Partly Cloudy';
      case 3:
        return 'Overcast';
      case 45:
      case 48:
        return 'Foggy';
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
        return 'Drizzle';
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
        return 'Rainy';
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return 'Snowy';
      case 95:
      case 96:
      case 99:
        return 'Thunderstorm';
      default:
        return 'Weather Update';
    }
  }
}
