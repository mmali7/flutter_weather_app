import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../providers/weather_provider.dart';
import '../widgets/current_weather_widget.dart';
import '../widgets/daily_forecast_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final Logger _logger = Logger();
  late AnimationController _refreshController;
  late Animation<double> _refreshAnimation;

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _refreshAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _refreshController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _refreshWeather() async {
    HapticFeedback.lightImpact();
    _refreshController.forward().then((_) {
      _refreshController.reset();
    });
    
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    final locale = Localizations.localeOf(context);
    await weatherProvider.refreshWeatherData(lang: locale.languageCode);
  }

  void _showSearchDialog(BuildContext context) {
    HapticFeedback.lightImpact();
    final AppLocalizations l10n = AppLocalizations.of(context);
    final WeatherProvider weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);
    final Locale locale = Localizations.localeOf(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bottomSheetContext) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                Text(
                  l10n.searchCityHint,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                
                SearchBarWidget(
                  searchController: _searchController,
                  onSearch: (city) {
                    if (city.isNotEmpty) {
                      try {
                        weatherProvider.fetchWeatherByCity(city,
                            lang: locale.languageCode);
                      } on Exception catch (e) {
                        _logger.e("Error during city search: $e");
                      }
                      _searchController.clear();
                      Navigator.of(bottomSheetContext).pop();
                    }
                  },
                ),
                const SizedBox(height: 16),
                
                ElevatedButton(
                  onPressed: () {
                    _searchController.clear();
                    Navigator.of(bottomSheetContext).pop();
                  },
                  child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSettingsDialog(BuildContext context) {
    HapticFeedback.lightImpact();
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final AppLocalizations l10n = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bottomSheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                Text(
                  l10n.settings,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                
                Text(
                  l10n.theme,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                
                _buildThemeOption(
                  context,
                  themeProvider,
                  l10n.lightMode,
                  ThemeMode.light,
                  Icons.light_mode_outlined,
                ),
                _buildThemeOption(
                  context,
                  themeProvider,
                  l10n.darkMode,
                  ThemeMode.dark,
                  Icons.dark_mode_outlined,
                ),
                _buildThemeOption(
                  context,
                  themeProvider,
                  l10n.systemMode,
                  ThemeMode.system,
                  Icons.settings_outlined,
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    ThemeProvider themeProvider,
    String title,
    ThemeMode mode,
    IconData icon,
  ) {
    final isSelected = themeProvider.themeMode == mode;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).dividerColor,
          width: isSelected ? 2 : 1,
        ),
        color: isSelected
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
            : Colors.transparent,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              )
            : null,
        onTap: () {
          HapticFeedback.selectionClick();
          try {
            themeProvider.setTheme(mode);
          } on Exception catch (e) {
            _logger.e("Error during theme change: $e");
          }
          Navigator.of(context).pop();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern app bar
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                weatherProvider.currentWeather?.cityName ?? l10n.appTitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
            ),
            actions: [
              // Search button
              IconButton(
                icon: const Icon(Icons.search_rounded),
                onPressed: () => _showSearchDialog(context),
                tooltip: l10n.searchCityHint,
              ),
              
              // Location button
              RotationTransition(
                turns: _refreshAnimation,
                child: IconButton(
                  icon: const Icon(Icons.my_location_rounded),
                  onPressed: () {
                    final locale = Localizations.localeOf(context);
                    weatherProvider.fetchWeatherByLocation(lang: locale.languageCode);
                  },
                  tooltip: l10n.gettingLocation,
                ),
              ),
              
              // Settings button
              IconButton(
                icon: const Icon(Icons.settings_rounded),
                onPressed: () => _showSettingsDialog(context),
                tooltip: l10n.settings,
              ),
              
              const SizedBox(width: 8),
            ],
          ),
          
          // Content
          SliverToBoxAdapter(
            child: RefreshIndicator(
              onRefresh: _refreshWeather,
              child: _buildWeatherContent(weatherProvider, l10n),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherContent(WeatherProvider provider, AppLocalizations l10n) {
    switch (provider.weatherState) {
      case WeatherState.initial:
        return _buildInitialState(l10n);
      case WeatherState.loading:
        return _buildLoadingState(l10n);
      case WeatherState.error:
        return _buildErrorState(provider, l10n);
      case WeatherState.loaded:
        return _buildLoadedState(provider, l10n);
    }
  }

  Widget _buildInitialState(AppLocalizations l10n) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wb_sunny_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'Welcome to Weather App',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.searchCityHint,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(AppLocalizations l10n) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            l10n.fetchingWeather,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(WeatherProvider provider, AppLocalizations l10n) {
    String displayError = provider.errorMessage ?? l10n.errorFetchingWeather;
    
    if (displayError.toLowerCase().contains("api key")) {
      displayError = "Invalid API Key. Please check your configuration.";
    } else if (displayError.toLowerCase().contains("city not found")) {
      displayError = l10n.noWeatherFound;
    } else if (displayError.toLowerCase().contains("location services are disabled")) {
      displayError = l10n.enableLocationServices;
    } else if (displayError.toLowerCase().contains("location permissions are denied")) {
      displayError = l10n.locationPermissionDenied;
    } else if (displayError.toLowerCase().contains("location permissions are permanently denied")) {
      displayError = l10n.locationPermissionPermanentlyDenied;
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: Theme.of(context).colorScheme.error,
            size: 80,
          ),
          const SizedBox(height: 24),
          Text(
            'Oops!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            displayError,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh_rounded),
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
  }

  Widget _buildLoadedState(WeatherProvider provider, AppLocalizations l10n) {
    if (provider.currentWeather == null || provider.dailySummaries.isEmpty) {
      return _buildErrorState(provider, l10n);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Current weather
        CurrentWeatherWidget(weather: provider.currentWeather!),
        
        const SizedBox(height: 32),
        
        // Forecast section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.forecast,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Daily forecast
        DailyForecastWidget(dailySummaries: provider.dailySummaries),
        
        const SizedBox(height: 24),
        
        // Last updated
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "${l10n.updated}: ${DateFormat.yMd(l10n.localeName).add_jm().format(provider.currentWeather!.date.toLocal())}",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ),
        
        const SizedBox(height: 32),
      ],
    );
  }
}