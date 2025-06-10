import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../models/weather_model.dart';
import '../../../core/api/api_constants.dart';
import '../../../l10n/app_localizations.dart'; // For localization

class CurrentWeatherWidget extends StatelessWidget {
  final WeatherModel weather;

  const CurrentWeatherWidget({super.key, required this.weather});

  Widget _buildWeatherInfoRow(BuildContext context, AppLocalizations l10n,
      IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              Icon(icon,
                  size: 20.0,
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.8)),
              const SizedBox(width: 10.0),
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final date = weather.date.toLocal();
    final temperature = weather.temperature.toStringAsFixed(1);
    final feelsLike = weather.feelsLike.toStringAsFixed(1);
    final humidity = weather.humidity.toString();
    final windSpeed = weather.windSpeed.toStringAsFixed(1);
    final pressure = weather.pressure.toString();
    final visibility = (weather.visibility) / 1000;
    final sunrise = weather.sunrise.toLocal();
    final sunset = weather.sunset.toLocal();

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              weather.cityName,
              style: textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              DateFormat.yMMMMEEEEd(l10n.localeName).format(date),
              style: textTheme.titleSmall,
            ),
            const SizedBox(height: 16.0),
            Image.network(
              ApiConstants.weatherIconUrl(weather.iconCode),
              width: 100,
              height: 100,
              errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.cloud_off,
                  size: 80,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[700]),
            ),
            const SizedBox(height: 8.0),
            Text(
              temperature,
              style: textTheme.displayMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              toBeginningOfSentenceCase(weather.description) ?? l10n.unknown,
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            Text(
              // ignore: unnecessary_null_comparison
              weather.feelsLike == null
                  ? ''
                  : '${l10n.feelsLike}: $feelsLike°C',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 20.0),
            Divider(color: Theme.of(context).dividerColor.withOpacity(0.5)),
            const SizedBox(height: 12.0),
            _buildWeatherInfoRow(context, l10n, Icons.water_drop_outlined,
                l10n.humidity, humidity),
            _buildWeatherInfoRow(
                context, l10n, Icons.air_outlined, l10n.windSpeed, windSpeed),
            _buildWeatherInfoRow(context, l10n, Icons.compress_outlined,
                l10n.pressure, pressure),
            _buildWeatherInfoRow(context, l10n, Icons.visibility_outlined,
                l10n.visibility, visibility.toStringAsFixed(1)),
            _buildWeatherInfoRow(context, l10n, Icons.wb_sunny_outlined,
                l10n.sunrise, DateFormat.jm(l10n.localeName).format(sunrise)),
            _buildWeatherInfoRow(context, l10n, Icons.nights_stay_outlined,
                l10n.sunset, DateFormat.jm(l10n.localeName).format(sunset)),
          ],
        ),
      ),
    );
  }
}
