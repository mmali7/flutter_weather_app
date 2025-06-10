class ForecastItem {
  final DateTime dateTime;
  final double temp;
  final double tempMin;
  final double tempMax;
  final String description;
  final String iconCode;
  final int humidity;
  final double windSpeed;

  ForecastItem({
    required this.dateTime,
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.description,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    final main = json['main'];
    final weather = json['weather'][0];
    final wind = json['wind'];

    return ForecastItem(
      dateTime: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000,
          isUtc: true),
      temp: (main['temp'] as num).toDouble(),
      tempMin: (main['temp_min'] as num).toDouble(),
      tempMax: (main['temp_max'] as num).toDouble(),
      description: weather['description'] ?? 'N/A',
      iconCode: weather['icon'] ?? '01d',
      humidity: (main['humidity'] as num).toInt(),
      windSpeed: (wind['speed'] as num).toDouble(),
    );
  }
}

class ForecastModel {
  final List<ForecastItem> items;
  final String cityName;

  ForecastModel({required this.items, required this.cityName});

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> list = json['list'];
    final List<ForecastItem> forecastItems = list.map((itemJson) {
      return ForecastItem.fromJson(itemJson);
    }).toList();

    final String city = json['city']?['name'] ?? 'Unknown City';

    return ForecastModel(items: forecastItems, cityName: city);
  }
}

class DailyForecastSummary {
  final DateTime date;
  final double tempMin;
  final double tempMax;
  final String description;
  final String iconCode;
  final List<ForecastItem> hourlyItems;

  DailyForecastSummary({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.description,
    required this.iconCode,
    required this.hourlyItems,
  });
}
