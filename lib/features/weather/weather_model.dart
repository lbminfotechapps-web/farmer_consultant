class HourlyWeather {
  final DateTime time;
  final double temperature;
  final double windSpeed;

  const HourlyWeather({
    required this.time,
    required this.temperature,
    required this.windSpeed,
  });
}

class DailyWeather {
  final DateTime date;
  final double maxTemperature;
  final double minTemperature;
  final int weatherCode;

  const DailyWeather({
    required this.date,
    required this.maxTemperature,
    required this.minTemperature,
    required this.weatherCode,
  });
}

class WeatherModel {
  final String cityName;
  final double latitude;
  final double longitude;
  final String timezone;

  final double currentTemperature;
  final double currentWindSpeed;
  final double humidity;
  final double feelsLike;
  final int weatherCode;
  final bool isDay;

  final List<HourlyWeather> hourly;
  final List<DailyWeather> daily;

  const WeatherModel({
    this.cityName = '',
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.currentTemperature,
    required this.currentWindSpeed,
    required this.humidity,
    required this.feelsLike,
    required this.weatherCode,
    required this.isDay,
    required this.hourly,
    required this.daily,
  });

  factory WeatherModel.fromJson(
    Map<String, dynamic> json, {
    String cityName = '',
  }) {
    final current = json['current'] is Map
        ? Map<String, dynamic>.from(json['current'])
        : <String, dynamic>{};

    final hourlyData = json['hourly'] is Map
        ? Map<String, dynamic>.from(json['hourly'])
        : <String, dynamic>{};

    final dailyData = json['daily'] is Map
        ? Map<String, dynamic>.from(json['daily'])
        : <String, dynamic>{};

    final hourlyTimes = hourlyData['time'] as List? ?? [];
    final temperatures = hourlyData['temperature_2m'] as List? ?? [];
    final winds = hourlyData['wind_speed_10m'] as List? ?? [];

    final hourlyCount = [
      hourlyTimes.length,
      temperatures.length,
      winds.length,
    ].reduce((a, b) => a < b ? a : b);

    final hourly = List<HourlyWeather>.generate(
      hourlyCount,
      (index) => HourlyWeather(
        time: DateTime.parse(hourlyTimes[index].toString()),
        temperature: _toDouble(temperatures[index]),
        windSpeed: _toDouble(winds[index]),
      ),
    );

    final dailyTimes = dailyData['time'] as List? ?? [];
    final dailyMax = dailyData['temperature_2m_max'] as List? ?? [];
    final dailyMin = dailyData['temperature_2m_min'] as List? ?? [];
    final dailyCodes = dailyData['weather_code'] as List? ?? [];

    final dailyCount = [
      dailyTimes.length,
      dailyMax.length,
      dailyMin.length,
      dailyCodes.length,
    ].reduce((a, b) => a < b ? a : b);

    final daily = List<DailyWeather>.generate(
      dailyCount,
      (index) => DailyWeather(
        date: DateTime.parse(dailyTimes[index].toString()),
        maxTemperature: _toDouble(dailyMax[index]),
        minTemperature: _toDouble(dailyMin[index]),
        weatherCode: _toInt(dailyCodes[index]),
      ),
    );

    return WeatherModel(
      cityName: cityName,
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      timezone: json['timezone']?.toString() ?? '',
      currentTemperature: _toDouble(current['temperature_2m']),
      currentWindSpeed: _toDouble(current['wind_speed_10m']),
      humidity: _toDouble(current['relative_humidity_2m']),
      feelsLike: _toDouble(current['apparent_temperature']),
      weatherCode: _toInt(current['weather_code']),
      isDay: _toInt(current['is_day']) == 1,
      hourly: hourly,
      daily: daily,
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
