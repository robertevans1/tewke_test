import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tewke_test/carbon_intensity/ui/current_intensity_widget.dart';

import '../carbon_intensity_module.dart';
import 'historic_data_widget.dart';

class CarbonIntensityScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool displayHistoricData =
        ref.watch(historicCarbonIntensityControllerProvider).display;

    return Scaffold(
      // app button with button to quit app
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CurrentIntensityWidget(),
            const SizedBox(height: 16),
            const Divider(
              indent: 32,
              endIndent: 32,
            ),
            TextButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Explore historic data',
                      style: TextStyle(fontSize: 16, color: Colors.grey[800])),
                  displayHistoricData
                      ? const Icon(Icons.keyboard_arrow_up)
                      : const Icon(Icons.keyboard_arrow_down)
                ],
              ),
              onPressed: () {
                ref
                    .read(historicCarbonIntensityControllerProvider.notifier)
                    .toggleDisplay();
              },
            ),
            HistoricDataWidget(),
          ],
        ),
      ),
    );
  }
}
