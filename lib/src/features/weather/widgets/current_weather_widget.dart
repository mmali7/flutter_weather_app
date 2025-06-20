import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';
import '../../../core/api/api_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

class CurrentWeatherWidget extends StatefulWidget {
  final WeatherModel weather;

  const CurrentWeatherWidget({super.key, required this.weather});

  @override
  State<CurrentWeatherWidget> createState() => _CurrentWeatherWidgetState();
}

class _CurrentWeatherWidgetState extends State<CurrentWeatherWidget>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final date = widget.weather.date.toLocal();
    final temperature = widget.weather.temperature.toStringAsFixed(0);
    final feelsLike = widget.weather.feelsLike.toStringAsFixed(0);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: AppTheme.elevatedDecoration(context),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Header with city name and date
                _buildHeader(context, l10n, textTheme, date),
                const SizedBox(height: 32),
                
                // Main weather display
                _buildMainWeather(context, l10n, textTheme, colorScheme, temperature),
                const SizedBox(height: 8),
                
                // Feels like temperature
                Text(
                  '${l10n.feelsLike} $feelsLike°',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Weather details grid
                _buildWeatherDetails(context, l10n),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n, 
      TextTheme textTheme, DateTime date) {
    return Column(
      children: [
        Text(
          widget.weather.cityName,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          DateFormat.yMMMMEEEEd(l10n.localeName).format(date),
          style: textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMainWeather(BuildContext context, AppLocalizations l10n,
      TextTheme textTheme, ColorScheme colorScheme, String temperature) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Weather icon
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: colorScheme.primary.withOpacity(0.1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              ApiConstants.weatherIconUrl(widget.weather.iconCode),
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.wb_cloudy_outlined,
                size: 80,
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ),
        ),
        const SizedBox(width: 24),
        
        // Temperature and description
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$temperature°',
                style: textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w300,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _toBeginningOfSentenceCase(widget.weather.description) ?? l10n.unknown,
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherDetails(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    
    final details = [
      _WeatherDetail(
        icon: Icons.water_drop_outlined,
        label: l10n.humidity,
        value: '${widget.weather.humidity}%',
      ),
      _WeatherDetail(
        icon: Icons.air_outlined,
        label: l10n.windSpeed,
        value: '${widget.weather.windSpeed.toStringAsFixed(1)} m/s',
      ),
      _WeatherDetail(
        icon: Icons.compress_outlined,
        label: l10n.pressure,
        value: '${widget.weather.pressure} hPa',
      ),
      _WeatherDetail(
        icon: Icons.visibility_outlined,
        label: l10n.visibility,
        value: '${(widget.weather.visibility / 1000).toStringAsFixed(1)} km',
      ),
      _WeatherDetail(
        icon: Icons.wb_sunny_outlined,
        label: l10n.sunrise,
        value: DateFormat.jm(l10n.localeName).format(widget.weather.sunrise.toLocal()),
      ),
      _WeatherDetail(
        icon: Icons.nights_stay_outlined,
        label: l10n.sunset,
        value: DateFormat.jm(l10n.localeName).format(widget.weather.sunset.toLocal()),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: details.length,
        itemBuilder: (context, index) {
          final detail = details[index];
          return _buildDetailItem(context, detail);
        },
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, _WeatherDetail detail) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            detail.icon,
            size: 20,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                detail.label,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                detail.value,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String? _toBeginningOfSentenceCase(String? input) {
    if (input == null || input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }
}

class _WeatherDetail {
  final IconData icon;
  final String label;
  final String value;

  const _WeatherDetail({
    required this.icon,
    required this.label,
    required this.value,
  });
}