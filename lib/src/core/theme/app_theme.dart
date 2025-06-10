import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Private constructor
  AppTheme._();

  static final Color _lightPrimaryColor = Colors.blue.shade600;
  static final Color _lightPrimaryVariantColor = Colors.blue.shade800;
  static const Color _lightOnPrimaryColor = Colors.white;
  static const Color _lightTextColorPrimary = Colors.black87;
  static const Color _lightBackgroundColor = Color(0xFFF5F5F5); // Off-white
  static final Color _lightAppBarColor = Colors.blue.shade600;
  static const Color _lightIconColor = Colors.black54;
  static const Color _lightCardColor = Colors.white;

  static final Color _darkPrimaryColor = Colors.blueGrey.shade700;
  static final Color _darkPrimaryVariantColor = Colors.blueGrey.shade900;
  static const Color _darkOnPrimaryColor = Colors.white;
  static const Color _darkTextColorPrimary = Colors.white;
  static const Color _darkBackgroundColor = Color(0xFF121212); // Very dark grey
  static final Color _darkAppBarColor = Colors.blueGrey.shade800;
  static const Color _darkIconColor = Colors.white70;
  static const Color _darkCardColor =
      Color(0xFF1E1E1E); // Slightly lighter dark grey

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: _lightBackgroundColor,
    primaryColor: _lightPrimaryColor,
    appBarTheme: AppBarTheme(
      color: _lightAppBarColor,
      iconTheme: const IconThemeData(color: _lightOnPrimaryColor),
      toolbarTextStyle: GoogleFonts.latoTextTheme()
          .copyWith(
            titleLarge: const TextStyle(
                color: _lightOnPrimaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          )
          .bodyMedium,
      titleTextStyle: GoogleFonts.latoTextTheme()
          .copyWith(
            titleLarge: const TextStyle(
                color: _lightOnPrimaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          )
          .titleLarge,
    ),
    colorScheme: ColorScheme.light(
      primary: _lightPrimaryColor,
      primaryContainer: _lightPrimaryVariantColor,
      secondary: _lightPrimaryColor, // Can be different
      onPrimary: _lightOnPrimaryColor,
      surface: _lightBackgroundColor,
      onSurface: _lightTextColorPrimary,
      error: Colors.redAccent,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    iconTheme: const IconThemeData(
      color: _lightIconColor,
    ),
    textTheme: GoogleFonts.latoTextTheme().copyWith(
      displayLarge: const TextStyle(color: _lightTextColorPrimary),
      displayMedium: const TextStyle(color: _lightTextColorPrimary),
      displaySmall: const TextStyle(color: _lightTextColorPrimary),
      headlineLarge: const TextStyle(color: _lightTextColorPrimary),
      headlineMedium: const TextStyle(color: _lightTextColorPrimary),
      headlineSmall: const TextStyle(color: _lightTextColorPrimary),
      titleLarge: const TextStyle(
          color: _lightTextColorPrimary, fontWeight: FontWeight.bold),
      titleMedium: const TextStyle(color: _lightTextColorPrimary),
      titleSmall: const TextStyle(color: _lightTextColorPrimary),
      bodyLarge: const TextStyle(color: _lightTextColorPrimary),
      bodyMedium: const TextStyle(color: _lightTextColorPrimary),
      bodySmall: const TextStyle(color: _lightTextColorPrimary),
      labelLarge: TextStyle(
          color: _lightPrimaryColor,
          fontWeight: FontWeight.bold), // For buttons
      labelMedium: const TextStyle(color: _lightTextColorPrimary),
      labelSmall: const TextStyle(color: _lightTextColorPrimary),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: _lightPrimaryColor,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _lightPrimaryColor,
        foregroundColor: _lightOnPrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: GoogleFonts.lato(fontWeight: FontWeight.bold),
      ),
    ),
    cardTheme: CardThemeData(
      color: _lightCardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: _lightPrimaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: _lightPrimaryVariantColor, width: 2.0),
      ),
      labelStyle: const TextStyle(color: _lightTextColorPrimary),
      hintStyle: const TextStyle(color: _lightIconColor),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _lightPrimaryColor,
      foregroundColor: _lightOnPrimaryColor,
    ),
    listTileTheme: ListTileThemeData(
      iconColor: _lightPrimaryColor,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: _lightBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: _darkBackgroundColor,
    primaryColor: _darkPrimaryColor,
    appBarTheme: AppBarTheme(
      color: _darkAppBarColor,
      iconTheme: const IconThemeData(color: _darkOnPrimaryColor),
      toolbarTextStyle: GoogleFonts.latoTextTheme()
          .copyWith(
            titleLarge: const TextStyle(
                color: _darkOnPrimaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          )
          .bodyMedium,
      titleTextStyle: GoogleFonts.latoTextTheme()
          .copyWith(
            titleLarge: const TextStyle(
                color: _darkOnPrimaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          )
          .titleLarge,
    ),
    colorScheme: ColorScheme.dark(
      primary: _darkPrimaryColor,
      primaryContainer: _darkPrimaryVariantColor,
      secondary: _darkPrimaryColor, // Can be different
      onPrimary: _darkOnPrimaryColor,
      surface: _darkBackgroundColor,
      onSurface: _darkTextColorPrimary,
      error: Colors.red,
      onError: Colors.black,
      brightness: Brightness.dark,
    ),
    iconTheme: const IconThemeData(
      color: _darkIconColor,
    ),
    textTheme: GoogleFonts.latoTextTheme().copyWith(
      displayLarge: const TextStyle(color: _darkTextColorPrimary),
      displayMedium: const TextStyle(color: _darkTextColorPrimary),
      displaySmall: const TextStyle(color: _darkTextColorPrimary),
      headlineLarge: const TextStyle(color: _darkTextColorPrimary),
      headlineMedium: const TextStyle(color: _darkTextColorPrimary),
      headlineSmall: const TextStyle(color: _darkTextColorPrimary),
      titleLarge: const TextStyle(
          color: _darkTextColorPrimary, fontWeight: FontWeight.bold),
      titleMedium: const TextStyle(color: _darkTextColorPrimary),
      titleSmall: const TextStyle(color: _darkTextColorPrimary),
      bodyLarge: const TextStyle(color: _darkTextColorPrimary),
      bodyMedium: const TextStyle(color: _darkTextColorPrimary),
      bodySmall: const TextStyle(color: _darkTextColorPrimary),
      labelLarge: TextStyle(
          color: _darkPrimaryColor, fontWeight: FontWeight.bold), // For buttons
      labelMedium: const TextStyle(color: _darkTextColorPrimary),
      labelSmall: const TextStyle(color: _darkTextColorPrimary),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: _darkPrimaryColor,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _darkPrimaryColor,
        foregroundColor: _darkOnPrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: GoogleFonts.lato(fontWeight: FontWeight.bold),
      ),
    ),
    cardTheme: CardThemeData(
      color: _darkCardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: _darkPrimaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: _darkPrimaryVariantColor, width: 2.0),
      ),
      labelStyle: const TextStyle(color: _darkTextColorPrimary),
      hintStyle: const TextStyle(color: _darkIconColor),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _darkPrimaryColor,
      foregroundColor: _darkOnPrimaryColor,
    ),
    listTileTheme: ListTileThemeData(
      iconColor: _darkPrimaryColor,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: _darkBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    ),
  );
}
