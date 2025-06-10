import 'package:flutter/material.dart';
import '../models/forecast_model.dart'; // For DailyForecastSummary
import 'forecast_item_widget.dart'; // We'll create this next

class DailyForecastWidget extends StatelessWidget {
  final List<DailyForecastSummary> dailySummaries;

  const DailyForecastWidget({super.key, required this.dailySummaries});

  @override
  Widget build(BuildContext context) {
    if (dailySummaries.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dailySummaries.length,
      itemBuilder: (context, index) {
        final summary = dailySummaries[index];
        return ForecastItemWidget(summary: summary);
      },
    );
  }
}
