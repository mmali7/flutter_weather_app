import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:collection/collection.dart'; // For groupBy

import '../../../core/repositories/weather_repository.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

enum WeatherState { initial, loading, loaded, error }

class WeatherProvider extends ChangeNotifier {
  final WeatherRepository _weatherRepository = WeatherRepository();

  WeatherModel? _currentWeather;
  ForecastModel? _forecast;
  List<DailyForecastSummary> _dailySummaries = [];
  WeatherState _weatherState = WeatherState.initial;
  String? _errorMessage;
  String _currentCityName = "London"; // Default city

  WeatherModel? get currentWeather => _currentWeather;
  ForecastModel? get forecast => _forecast;
  List<DailyForecastSummary> get dailySummaries => _dailySummaries;
  WeatherState get weatherState => _weatherState;
  String? get errorMessage => _errorMessage;
  String get currentCityName => _currentCityName;

  Future<void> fetchWeatherByCity(String city, {String lang = 'en'}) async {
    _weatherState = WeatherState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentWeather =
          await _weatherRepository.getCurrentWeatherByCity(city, lang: lang);
      _forecast =
          await _weatherRepository.getFiveDayForecastByCity(city, lang: lang);
      _currentCityName = _currentWeather?.cityName ?? city;
      _processForecast();
      _weatherState = WeatherState.loaded;
    } catch (e) {
      _weatherState = WeatherState.error;
      if (e is WeatherRepositoryException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'Failed to fetch weather data';
      }
      print("Error fetching weather by city: ${e.toString()}");
    }
    notifyListeners();
  }

  Future<void> fetchWeatherByLocation({String lang = 'en'}) async {
    _weatherState = WeatherState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      Position position = await _weatherRepository.getCurrentPosition();
      _currentWeather = await _weatherRepository.getCurrentWeatherByCoordinates(
          position.latitude, position.longitude,
          lang: lang);
      _forecast = await _weatherRepository.getFiveDayForecastByCoordinates(
          position.latitude, position.longitude,
          lang: lang);
      _currentCityName = _currentWeather?.cityName ?? "Current Location";
      _processForecast();
      _weatherState = WeatherState.loaded;
    } catch (e) {
      _weatherState = WeatherState.error;
      if (e is WeatherRepositoryException) {
        if (e.message.contains("Location services are disabled")) {
          _errorMessage = "Please enable location services.";
        } else if (e.message.contains("Location permissions are denied")) {
          _errorMessage =
              "Location permission denied. Please enable it in settings.";
        } else if (e.message
            .contains("Location permissions are permanently denied")) {
          _errorMessage =
              "Location permission permanently denied. Please enable it in app settings.";
        } else {
          _errorMessage = e.message;
        }
      } else {
        _errorMessage = 'Failed to fetch weather data';
      }
      print("Error fetching weather by location: ${e.toString()}");
    }
    notifyListeners();
  }

  void _processForecast() {
    if (_forecast == null || _forecast!.items.isEmpty) {
      _dailySummaries = [];
      return;
    }

    final groupedByDay = groupBy(
      _forecast!.items,
      (ForecastItem item) =>
          DateTime(item.dateTime.year, item.dateTime.month, item.dateTime.day),
    );

    _dailySummaries = groupedByDay.entries.map((entry) {
      final day = entry.key;
      final itemsForDay = entry.value;

      double minTemp = itemsForDay.first.tempMin;
      double maxTemp = itemsForDay.first.tempMax;
      // Find overall min/max for the day from all 3-hour forecasts for that day
      for (var item in itemsForDay) {
        if (item.tempMin < minTemp) minTemp = item.tempMin;
        if (item.tempMax > maxTemp) maxTemp = item.tempMax;
      }

      ForecastItem representativeItem = itemsForDay.firstWhere(
        (item) => item.dateTime.hour >= 12 && item.dateTime.hour <= 15,
        orElse: () => itemsForDay.first,
      );

      return DailyForecastSummary(
        date: day,
        tempMin: minTemp,
        tempMax: maxTemp,
        description: representativeItem.description,
        iconCode: representativeItem.iconCode,
        hourlyItems: itemsForDay,
      );
    }).toList();

    if (_dailySummaries.length > 6) {
      _dailySummaries = _dailySummaries.sublist(0, 6);
    }
  }

  Future<void> refreshWeatherData({String? city, String lang = 'en'}) async {
    if (_currentWeather != null && city == null) {
      if (_currentWeather!.cityName.isNotEmpty &&
          _currentWeather!.cityName != "Current Location") {
        await fetchWeatherByCity(_currentWeather!.cityName, lang: lang);
      } else {
        await fetchWeatherByLocation(lang: lang);
      }
    } else if (city != null) {
      await fetchWeatherByCity(city, lang: lang);
    } else {
      await fetchWeatherByLocation(lang: lang);
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
