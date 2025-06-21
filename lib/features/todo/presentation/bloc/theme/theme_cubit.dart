import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final Box _settingsBox;

  ThemeCubit(this._settingsBox) : super(const ThemeState(ThemeMode.system));

  void loadTheme() {
    final themeIndex = _settingsBox.get('theme_mode', defaultValue: 0) as int;
    final themeMode = ThemeMode.values[themeIndex];
    emit(ThemeState(themeMode));
  }

  void changeTheme(ThemeMode themeMode) {
    _settingsBox.put('theme_mode', themeMode.index);
    emit(ThemeState(themeMode));
  }
}