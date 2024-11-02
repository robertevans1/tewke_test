import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
          data: (data) => ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final intensity = data[index];
                return ListTile(
                  title: Text(
                      (intensity.actualIntensity ?? intensity.forecastIntensity)
                          .toString()),
                  subtitle: Text(DateFormat('HH:mm').format(intensity.from)),
                  trailing: Text(DateFormat('HH:mm').format(intensity.to)),
                );
              }),
          error: (error, stackTrace) => Center(
                child: Text('Error: $error'),
              ),
          loading: () => const CircularProgressIndicator()),
    );
  }
}
