import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tewke_test/carbon_intensity/ui/carbon_intensity_summary_widget.dart';
import 'package:tewke_test/carbon_intensity/ui/todays_data_chart_widget.dart';

import '../carbon_intensity_module.dart';

class TodaysDataScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todaysIntensity = ref.watch(carbonIntensityControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todays Data'),
      ),
      body: todaysIntensity.when(
          data: (data) => Column(
                children: [
                  IntensityDataChartWidget(data: data),
                  data.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CarbonIntensitySummaryWidget(
                              carbonIntensity: data.last),
                        )
                      : Container(),
                ],
              ),
          error: (error, stackTrace) => Center(
                child: Text('Error: $error'),
              ),
          loading: () => const CircularProgressIndicator()),
    );
  }
}
