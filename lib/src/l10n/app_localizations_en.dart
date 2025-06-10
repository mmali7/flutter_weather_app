// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Weather App';

  @override
  String get searchCityHint => 'Search for a city';

  @override
  String get currentWeather => 'Current Weather';

  @override
  String get temperature => 'Temperature';

  @override
  String get feelsLike => 'Feels Like';

  @override
  String get humidity => 'Humidity';

  @override
  String get windSpeed => 'Wind Speed';

  @override
  String get forecast => '5-Day Forecast';

  @override
  String get today => 'Today';

  @override
  String get errorFetchingWeather => 'Error fetching weather data';

  @override
  String get errorFetchingLocation => 'Error fetching location';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get noWeatherFound => 'No weather data found for this city.';

  @override
  String get enableLocationServices => 'Please enable location services.';

  @override
  String get locationPermissionDenied =>
      'Location permission denied. Please enable it in settings.';

  @override
  String get locationPermissionPermanentlyDenied =>
      'Location permission permanently denied. Please enable it in app settings.';

  @override
  String get gettingLocation => 'Getting your location...';

  @override
  String get fetchingWeather => 'Fetching weather...';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get systemMode => 'System Default';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get weatherConditions => 'Weather Conditions';

  @override
  String get sunrise => 'Sunrise';

  @override
  String get sunset => 'Sunset';

  @override
  String get pressure => 'Pressure';

  @override
  String get visibility => 'Visibility';

  @override
  String get updated => 'Updated';

  @override
  String get high => 'High';

  @override
  String get low => 'Low';

  @override
  String get sunday => 'Sunday';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get unknown => 'Unknown';
}
