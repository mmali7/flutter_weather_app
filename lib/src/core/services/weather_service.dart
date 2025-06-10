import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/api_constants.dart';
import '../../features/weather/models/weather_model.dart';
import '../../features/weather/models/forecast_model.dart';

class WeatherService {
  final http.Client _client;

  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  Future<WeatherModel> getCurrentWeatherByCity(String city,
      {String units = 'metric', String lang = 'en'}) async {
    if (ApiConstants.apiKey == "YOUR_API_KEY_HERE") {
      throw Exception(
          "API Key not set. Please set your OpenWeatherMap API key in ApiConstants.");
    }
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.weatherEndpoint}?q=$city&appid=${ApiConstants.apiKey}&units=$units&lang=$lang');

    try {
      final response = await _client.get(uri);
      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        return WeatherModel.fromJson(decodedJson);
      } else if (response.statusCode == 404) {
        throw Exception('City not found');
      } else if (response.statusCode == 401) {
        throw Exception(
            'Invalid API Key. Please check your API key in ApiConstants.');
      } else {
        throw Exception(
            'Failed to load weather data (Status code: ${response.statusCode})');
      }
    } catch (e) {
      print("Error in getCurrentWeatherByCity: $e");
      throw Exception(
          'Failed to connect or parse weather data: ${e.toString()}');
    }
  }

  Future<WeatherModel> getCurrentWeatherByCoordinates(double lat, double lon,
      {String units = 'metric', String lang = 'en'}) async {
    if (ApiConstants.apiKey == "YOUR_API_KEY_HERE") {
      throw Exception(
          "API Key not set. Please set your OpenWeatherMap API key in ApiConstants.");
    }
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.weatherEndpoint}?lat=$lat&lon=$lon&appid=${ApiConstants.apiKey}&units=$units&lang=$lang');

    try {
      final response = await _client.get(uri);
      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        return WeatherModel.fromJson(decodedJson);
      } else if (response.statusCode == 401) {
        throw Exception(
            'Invalid API Key. Please check your API key in ApiConstants.');
      } else {
        throw Exception(
            'Failed to load weather data (Status code: ${response.statusCode})');
      }
    } catch (e) {
      print("Error in getCurrentWeatherByCoordinates: $e");
      throw Exception(
          'Failed to connect or parse weather data: ${e.toString()}');
    }
  }

  Future<ForecastModel> getFiveDayForecastByCity(String city,
      {String units = 'metric', String lang = 'en'}) async {
    if (ApiConstants.apiKey == "YOUR_API_KEY_HERE") {
      throw Exception(
          "API Key not set. Please set your OpenWeatherMap API key in ApiConstants.");
    }
    // OpenWeatherMap's 5-day forecast provides data every 3 hours.
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.forecastEndpoint}?q=$city&appid=${ApiConstants.apiKey}&units=$units&lang=$lang');

    try {
      final response = await _client.get(uri);
      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        return ForecastModel.fromJson(decodedJson);
      } else if (response.statusCode == 404) {
        throw Exception('City not found for forecast');
      } else if (response.statusCode == 401) {
        throw Exception(
            'Invalid API Key. Please check your API key in ApiConstants.');
      } else {
        throw Exception(
            'Failed to load forecast data (Status code: ${response.statusCode})');
      }
    } catch (e) {
      print("Error in getFiveDayForecastByCity: $e");
      throw Exception(
          'Failed to connect or parse forecast data: ${e.toString()}');
    }
  }

  Future<ForecastModel> getFiveDayForecastByCoordinates(double lat, double lon,
      {String units = 'metric', String lang = 'en'}) async {
    if (ApiConstants.apiKey == "YOUR_API_KEY_HERE") {
      throw Exception(
          "API Key not set. Please set your OpenWeatherMap API key in ApiConstants.");
    }
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.forecastEndpoint}?lat=$lat&lon=$lon&appid=${ApiConstants.apiKey}&units=$units&lang=$lang');

    try {
      final response = await _client.get(uri);
      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        return ForecastModel.fromJson(decodedJson);
      } else if (response.statusCode == 401) {
        throw Exception(
            'Invalid API Key. Please check your API key in ApiConstants.');
      } else {
        throw Exception(
            'Failed to load forecast data (Status code: ${response.statusCode})');
      }
    } catch (e) {
      print("Error in getFiveDayForecastByCoordinates: $e");
      throw Exception(
          'Failed to connect or parse forecast data: ${e.toString()}');
    }
  }
}
