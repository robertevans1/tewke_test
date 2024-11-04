import 'package:flutter/material.dart';

import '../domain/carbon_intensity.dart';

class CarbonIntensitySummaryWidget extends StatelessWidget {
  final CarbonIntensity carbonIntensity;

  const CarbonIntensitySummaryWidget(
      {required this.carbonIntensity, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Carbon Intensity Summary',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Time period',
                '${carbonIntensity.fromTime} - ${carbonIntensity.toTime}'),
            _buildInfoRow('Actual Intensity',
                '${carbonIntensity.actualIntensity ?? 'N/A'}'),
            _buildInfoRow(
                'Forecast Intensity', '${carbonIntensity.forecastIntensity}'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value),
        ],
      ),
    );
  }
}
