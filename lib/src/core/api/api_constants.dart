class ApiConstants {
  static const String apiKey = "3c95a0568e9d1b01497cba9b82f59060";

  static const String baseUrl = "https://api.openweathermap.org/data/2.5/";
  static const String weatherEndpoint = "weather";
  static const String forecastEndpoint = "forecast";

  static String weatherIconUrl(String iconCode) {
    return "https://openweathermap.org/img/wn/$iconCode@2x.png";
  }
}
