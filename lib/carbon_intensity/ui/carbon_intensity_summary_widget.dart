import 'package:flutter/material.dart';

import '../domain/carbon_intensity.dart';

class CarbonIntensitySummaryWidget extends StatelessWidget {
  final CarbonIntensity carbonIntensity;

  const CarbonIntensitySummaryWidget(
      {required this.carbonIntensity, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summary',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.grey[800],
                ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            'Time period',
            '${carbonIntensity.fromTime} - ${carbonIntensity.toTime}',
            context,
          ),
          _buildInfoRow(
            'Actual Intensity',
            '${carbonIntensity.actualIntensity ?? 'N/A'}',
            context,
          ),
          _buildInfoRow(
            'Forecast Intensity',
            '${carbonIntensity.forecastIntensity}',
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.primary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
