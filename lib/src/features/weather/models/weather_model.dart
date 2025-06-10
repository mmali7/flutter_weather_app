class WeatherModel {
  final String cityName;
  final String description;
  final String iconCode;
  final double temperature; // Celsius
  final double feelsLike; // Celsius
  final int humidity; // Percentage
  final double windSpeed; // meter/sec
  final int pressure; // hPa
  final int visibility; // meters
  final DateTime date;
  final DateTime sunrise;
  final DateTime sunset;
  final double lat;
  final double lon;

  WeatherModel({
    required this.cityName,
    required this.description,
    required this.iconCode,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.visibility,
    required this.date,
    required this.sunrise,
    required this.sunset,
    required this.lat,
    required this.lon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0];
    final main = json['main'];
    final wind = json['wind'];
    final sys = json['sys'];

    return WeatherModel(
      cityName: json['name'] ?? 'Unknown City',
      description: weather['description'] ?? 'N/A',
      iconCode: weather['icon'] ?? '01d',
      temperature: (main['temp'] as num?)?.toDouble() ?? 0.0,
      feelsLike: (main['feels_like'] as num?)?.toDouble() ?? 0.0,
      humidity: (main['humidity'] as num?)?.toInt() ?? 0,
      windSpeed: (wind['speed'] as num?)?.toDouble() ?? 0.0,
      pressure: (main['pressure'] as num?)?.toInt() ?? 0,
      visibility: (json['visibility'] as num?)?.toInt() ?? 0,
      date: DateTime.fromMillisecondsSinceEpoch(
          ((json['dt'] as num?)?.toInt() ?? 0) * 1000,
          isUtc: true),
      sunrise: DateTime.fromMillisecondsSinceEpoch(
          ((sys['sunrise'] as num?)?.toInt() ?? 0) * 1000,
          isUtc: true),
      sunset: DateTime.fromMillisecondsSinceEpoch(
          ((sys['sunset'] as num?)?.toInt() ?? 0) * 1000,
          isUtc: true),
      lat: (json['coord']['lat'] as num?)?.toDouble() ?? 0.0,
      lon: (json['coord']['lon'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // For debugging or logging
  @override
  String toString() {
    return 'WeatherModel(cityName: $cityName, description: $description, temperature: $temperature°C)';
  }
}
