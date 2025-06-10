import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../providers/weather_provider.dart';
import 'home_screen.dart';
import '../../../l10n/app_localizations.dart'; // For localization

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initializeApp();
      }
    });
  }

  Future<void> _initializeApp() async {
    if (!mounted) return;

    final weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);

    final locale = Localizations.localeOf(context);
    final langCode = locale.languageCode;

    try {
      await weatherProvider.fetchWeatherByLocation(lang: langCode);
    } catch (e) {
      print("SplashScreen: Error fetching weather by location: $e");

      if (mounted) {
        try {
          await weatherProvider.fetchWeatherByCity("London", lang: langCode);
        } catch (e2) {
          print(
              "SplashScreen: Error fetching weather by default city (London): $e2");
        }
      }
    }

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.wb_sunny, size: 100.0, color: Colors.orangeAccent),
            const SizedBox(height: 24.0),
            Text(
              l10n.appTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16.0),
            const CircularProgressIndicator(),
            const SizedBox(height: 16.0),
            Consumer<WeatherProvider>(
              builder: (BuildContext context, WeatherProvider provider,
                  Widget? child) {
                if (provider.weatherState == WeatherState.loading) {
                  return Text(
                      provider.errorMessage?.contains("location") ?? false
                          ? l10n.gettingLocation
                          : l10n.fetchingWeather);
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
