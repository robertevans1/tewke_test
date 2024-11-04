import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../carbon_intensity_module.dart';

class CurrentIntensityWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(currentCarbonIntensityControllerProvider);

    return state.when(
      data: (data) {
        final intensity = data.actualIntensity ?? data.forecastIntensity;
        return Column(
          children: [
            Text(
              'Current Carbon Intensity',
              style: TextStyle(fontSize: 24, color: Colors.grey[800]),
            ),
            Text(intensity.toString(),
                style: TextStyle(
                    fontSize: 36, color: textColorForIntensity(intensity))),
            // unit with the 2 subscript
            Text(
              'gCO₂/kWh',
              style: TextStyle(fontSize: 24, color: Colors.grey[600]),
            ),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Data Unavailable'),
    );
  }

  Color textColorForIntensity(int intensity) {
    if (intensity < 180) {
      return Colors.green;
    } else if (intensity < 280) {
      return Colors.yellow[800] ?? Colors.yellow;
    } else {
      return Colors.red;
    }
  }
}
