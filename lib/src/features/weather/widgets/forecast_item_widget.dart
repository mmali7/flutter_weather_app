import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/forecast_model.dart'; // For DailyForecastSummary
import '../../../core/api/api_constants.dart';
import '../../../l10n/app_localizations.dart'; // For localization

class ForecastItemWidget extends StatelessWidget {
  final DailyForecastSummary summary;

  const ForecastItemWidget({super.key, required this.summary});

  String? _getDayName(BuildContext context, DateTime date) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final summaryDate = DateTime(date.year, date.month, date.day);

    if (summaryDate == today) {
      return l10n.today;
    } else if (summaryDate == tomorrow) {
      return DateFormat.EEEE(l10n.localeName).format(date);
    } else {
      return DateFormat.EEEE(l10n.localeName).format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getDayName(context, summary.date.toLocal()) ?? '',
                    style: textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    DateFormat.MMMd(l10n.localeName)
                        .format(summary.date.toLocal()),
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Image.network(
                ApiConstants.weatherIconUrl(summary.iconCode),
                width: 40,
                height: 40,
                errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.cloud_off,
                    size: 30,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[700]),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  toBeginningOfSentenceCase(summary.description) ??
                      l10n.unknown,
                  style: textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '${summary.tempMax.toStringAsFixed(0)} / ${summary.tempMin.toStringAsFixed(0)}',
                style: textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w500),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
