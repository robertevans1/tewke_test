import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../carbon_intensity_module.dart';
import '../domain/carbon_intensity_screen_state.dart';
import 'carbon_intensity_summary_widget.dart';
import 'intensity_data_chart_widget.dart';

class HistoricDataWidget extends ConsumerWidget {
  Widget getContent(CarbonIntensityScreenState state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (state.error != null) {
      return const Text('Data Unavailable');
    } else {
      return Column(
        children: [
          if (state.data.isNotEmpty) IntensityDataChartWidget(data: state.data),
          if (state.data.isEmpty) const Center(child: Text('Data Unavailable')),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historicCarbonIntensityControllerProvider);

    return Visibility(
      visible: state.display,
      child: Column(
        children: [
          _DaySelector(),
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Forecasted vs Actual carbon intensity in the UK on the selected date. Tap the chart for a detailed summary at a particular time.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.5,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              getContent(state),
            ],
          ),
        ],
      ),
    );
  }
}

class _DaySelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historicCarbonIntensityControllerProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref
                .read(historicCarbonIntensityControllerProvider.notifier)
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
            ref
                .read(historicCarbonIntensityControllerProvider.notifier)
                .loadNextDay();
          },
        ),
      ],
    );
  }
}
