import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../api/api_constants.dart';
import '../../features/weather/models/weather_model.dart';
import '../../features/weather/models/forecast_model.dart';

class WeatherRepository {
  final http.Client _client;

  WeatherRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<Position> getCurrentPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw WeatherRepositoryException('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw WeatherRepositoryException('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw WeatherRepositoryException(
            'Location permissions are permanently denied');
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
    } catch (e) {
      throw WeatherRepositoryException(
          'Failed to get position: ${e.toString()}');
    }
  }

  /// Weather API methods
  Future<WeatherModel> getCurrentWeatherByCity(String city,
      {String units = 'metric', String lang = 'en'}) async {
    final uri = _buildWeatherUri(
      endpoint: ApiConstants.weatherEndpoint,
      queryParams: {'q': city, 'units': units, 'lang': lang},
    );

    final response = await _makeApiCall(uri);
    return WeatherModel.fromJson(json.decode(response.body));
  }

  Future<WeatherModel> getCurrentWeatherByCoordinates(double lat, double lon,
      {String units = 'metric', String lang = 'en'}) async {
    final uri = _buildWeatherUri(
      endpoint: ApiConstants.weatherEndpoint,
      queryParams: {'lat': '$lat', 'lon': '$lon', 'units': units, 'lang': lang},
    );

    final response = await _makeApiCall(uri);
    return WeatherModel.fromJson(json.decode(response.body));
  }

  Future<ForecastModel> getFiveDayForecastByCity(String city,
      {String units = 'metric', String lang = 'en'}) async {
    final uri = _buildWeatherUri(
      endpoint: ApiConstants.forecastEndpoint,
      queryParams: {'q': city, 'units': units, 'lang': lang},
    );

    final response = await _makeApiCall(uri);
    return ForecastModel.fromJson(json.decode(response.body));
  }

  Future<ForecastModel> getFiveDayForecastByCoordinates(double lat, double lon,
      {String units = 'metric', String lang = 'en'}) async {
    final uri = _buildWeatherUri(
      endpoint: ApiConstants.forecastEndpoint,
      queryParams: {'lat': '$lat', 'lon': '$lon', 'units': units, 'lang': lang},
    );

    final response = await _makeApiCall(uri);
    return ForecastModel.fromJson(json.decode(response.body));
  }

  /// Helper methods
  Uri _buildWeatherUri({
    required String endpoint,
    required Map<String, String> queryParams,
  }) {
    if (ApiConstants.apiKey == "YOUR_API_KEY_HERE") {
      throw Exception("API Key not set in ApiConstants.");
    }

    return Uri.parse('${ApiConstants.baseUrl}$endpoint').replace(
      queryParameters: {
        ...queryParams,
        'appid': ApiConstants.apiKey,
      },
    );
  }

  Future<http.Response> _makeApiCall(Uri uri) async {
    try {
      final response = await _client.get(uri);

      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 401) {
        throw WeatherRepositoryException('Invalid API Key');
      } else if (response.statusCode == 404) {
        throw WeatherRepositoryException('Location not found');
      } else {
        throw WeatherRepositoryException(
            'API request failed with status ${response.statusCode}');
      }
    } catch (e) {
      throw WeatherRepositoryException(
          'Failed to make API call: ${e.toString()}');
    }
  }
}

class WeatherRepositoryException implements Exception {
  final String message;
  WeatherRepositoryException(this.message);

  @override
  String toString() => 'WeatherRepositoryException: $message';
}
