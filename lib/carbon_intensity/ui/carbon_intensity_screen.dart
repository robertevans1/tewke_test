import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tewke_test/carbon_intensity/domain/carbon_intensity_screen_state.dart';
import 'package:tewke_test/carbon_intensity/ui/carbon_intensity_summary_widget.dart';
import 'package:tewke_test/carbon_intensity/ui/intensity_data_chart_widget.dart';

import '../carbon_intensity_module.dart';

class CarbonIntensityScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(carbonIntensityControllerProvider);

    Widget getBody(CarbonIntensityScreenState state) {
      if (state.isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state.error != null) {
        return const Text('Data Unavailable');
      } else {
        return Column(
          children: [
            if (state.data.isNotEmpty)
              IntensityDataChartWidget(data: state.data),
            if (state.data.isEmpty)
              const Center(child: Text('No data available for date')),
            if (state.selectedData != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CarbonIntensitySummaryWidget(
                  carbonIntensity: state.selectedData!,
                ),
              ),
          ],
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('UK Carbon Intensity '),
      ),
      body: Column(
        children: [
          _DaySelector(),
          getBody(state),
        ],
      ),
    );
  }
}

class _DaySelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(carbonIntensityControllerProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref
                .read(carbonIntensityControllerProvider.notifier)
                .loadPreviousDay();
          },
        ),
        Text(
          '${state.date.day}/${state.date.month}/${state.date.year}',
          style: const TextStyle(fontSize: 16),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () {
            ref.read(carbonIntensityControllerProvider.notifier).loadNextDay();
          },
        ),
      ],
    );
  }
}
