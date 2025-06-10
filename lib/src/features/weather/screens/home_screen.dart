import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:logger/logger.dart';

import '../providers/weather_provider.dart';
import '../widgets/current_weather_widget.dart';
import '../widgets/daily_forecast_widget.dart';
import '../widgets/search_bar_widget.dart'; // We'll create this
import '../../../core/theme/theme_provider.dart';
import '../../../l10n/app_localizations.dart'; // For localization

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Logger _logger = Logger();
  @override
  void initState() {
    super.initState();
  }

  Future<void> _refreshWeather() async {
    final weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);
    final locale = Localizations.localeOf(context);
    await weatherProvider.refreshWeatherData(lang: locale.languageCode);
  }

  void _showSearchDialog(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final WeatherProvider weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);
    final Locale locale = Localizations.localeOf(context);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.searchCityHint),
          content: SearchBarWidget(
            searchController: _searchController,
            onSearch: (city) {
              if (city.isNotEmpty) {
                try {
                  weatherProvider.fetchWeatherByCity(city,
                      lang: locale.languageCode);
                } on Exception catch (e) {
                  // Handle potential errors in fetching weather
                  _logger.e("Error during city search: $e");
                }
                _searchController.clear();
                Navigator.of(dialogContext).pop();
              }
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                MaterialLocalizations.of(context).cancelButtonLabel,
              ),
              onPressed: () {
                _searchController.clear();
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSettingsDialog(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final AppLocalizations l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.settings),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(l10n.theme, style: Theme.of(context).textTheme.titleMedium),
              RadioListTile<ThemeMode>(
                title: Text(l10n.lightMode),
                value: ThemeMode.light,
                groupValue: themeProvider.themeMode,
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    try {
                      themeProvider.setTheme(value);
                    } on Exception catch (e) {
                      // Handle potential errors in setting theme
                      _logger.e("Error during theme change: $e");
                    }
                    Navigator.of(dialogContext).pop();
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                title: Text(l10n.darkMode),
                value: ThemeMode.dark,
                groupValue: themeProvider.themeMode,
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    try {
                      themeProvider.setTheme(value);
                    } on Exception catch (e) {
                      // Handle potential errors in setting theme
                      _logger.e("Error during theme change: $e");
                    }
                    Navigator.of(dialogContext).pop();
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                title: Text(l10n.systemMode),
                value: ThemeMode.system,
                groupValue: themeProvider.themeMode,
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    try {
                      themeProvider.setTheme(value);
                    } on Exception catch (e) {
                      // Handle potential errors in setting theme
                      _logger.e("Error during theme change: $e");
                    }
                    Navigator.of(dialogContext).pop();
                  }
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(MaterialLocalizations.of(context).okButtonLabel),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(weatherProvider.currentWeather?.cityName ?? l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
            tooltip: l10n.searchCityHint,
          ),
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              final locale = Localizations.localeOf(context);
              weatherProvider.fetchWeatherByLocation(lang: locale.languageCode);
            },
            tooltip: l10n.gettingLocation,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsDialog(context),
            tooltip: l10n.settings,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshWeather,
        child: Center(
          child: _buildWeatherContent(weatherProvider, l10n),
        ),
      ),
    );
  }

  Widget _buildWeatherContent(WeatherProvider provider, AppLocalizations l10n) {
    switch (provider.weatherState) {
      case WeatherState.initial:
        return Text(l10n.searchCityHint);
      case WeatherState.loading:
        return const Center(child: CircularProgressIndicator());
      case WeatherState.error:
        String displayError =
            provider.errorMessage ?? l10n.errorFetchingWeather;
        if (displayError.toLowerCase().contains("api key")) {
          displayError = "Invalid API Key. Please check your configuration.";
        } else if (displayError.toLowerCase().contains("city not found")) {
          displayError = l10n.noWeatherFound;
        } else if (displayError
            .toLowerCase()
            .contains("location services are disabled")) {
          displayError = l10n.enableLocationServices;
        } else if (displayError
            .toLowerCase()
            .contains("location permissions are denied")) {
          displayError = l10n.locationPermissionDenied;
        } else if (displayError
            .toLowerCase()
            .contains("location permissions are permanently denied")) {
          displayError = l10n.locationPermissionPermanentlyDenied;
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline,
                  color: Theme.of(context).colorScheme.error, size: 60),
              const SizedBox(height: 16),
              Text(
                displayError,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16, color: Theme.of(context).colorScheme.error),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: Text(l10n.tryAgain),
                onPressed: () {
                  final locale = Localizations.localeOf(context);

                  if (provider.currentCityName.isNotEmpty &&
                      provider.currentCityName != "Current Location" &&
                      provider.currentCityName != "London") {
                    provider.fetchWeatherByCity(provider.currentCityName,
                        lang: locale.languageCode);
                  } else {
                    provider.fetchWeatherByLocation(lang: locale.languageCode);
                  }
                },
              ),
            ],
          ),
        );
      case WeatherState.loaded:
        if (provider.currentWeather == null ||
            provider.dailySummaries.isEmpty) {
          return Text(l10n.noWeatherFound);
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CurrentWeatherWidget(weather: provider.currentWeather!),
              const SizedBox(height: 24.0),
              Text(
                l10n.forecast,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8.0),
              DailyForecastWidget(dailySummaries: provider.dailySummaries),
              const SizedBox(height: 10),
              Text(
                "${l10n.updated}: ${DateFormat.yMd(l10n.localeName).add_jm().format(provider.currentWeather!.date.toLocal())}",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
