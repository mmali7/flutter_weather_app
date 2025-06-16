import 'package:flutter/material.dart';
import '../models/forecast_model.dart';
import 'forecast_item_widget.dart';

class DailyForecastWidget extends StatelessWidget {
  final List<DailyForecastSummary> dailySummaries;

  const DailyForecastWidget({super.key, required this.dailySummaries});

  @override
  Widget build(BuildContext context) {
    if (dailySummaries.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        for (int i = 0; i < dailySummaries.length; i++)
          ForecastItemWidget(
            summary: dailySummaries[i],
            index: i,
          ),
      ],
    );
  }
}