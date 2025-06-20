import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_localizations.dart';

import 'src/core/theme/app_theme.dart';
import 'src/core/theme/theme_provider.dart';
import 'src/features/weather/providers/weather_provider.dart';
import 'src/features/weather/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(prefs)..loadTheme(),
        ),
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Weather App',
            theme: AppTheme.lightTheme.copyWith(
              textTheme:
                  GoogleFonts.latoTextTheme(AppTheme.lightTheme.textTheme),
            ),
            darkTheme: AppTheme.darkTheme.copyWith(
              textTheme:
                  GoogleFonts.latoTextTheme(AppTheme.darkTheme.textTheme),
            ),
            themeMode: themeProvider.themeMode,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}