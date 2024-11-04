import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../carbon_intensity_module.dart';
import '../domain/carbon_intensity.dart';

class IntensityDataChartWidget extends ConsumerStatefulWidget {
  final List<CarbonIntensity> data;

  IntensityDataChartWidget({required this.data}) : assert(data.isNotEmpty);

  @override
  ConsumerState<IntensityDataChartWidget> createState() =>
      _IntensityDataChartWidgetState();
}

class _IntensityDataChartWidgetState
    extends ConsumerState<IntensityDataChartWidget> {
  int? lastTouchedSpotIndex;

  final Color actualIntensityLineColor = const Color(0xff6f5ce7);
  final Color line2Color1 = const Color(0xffa4a4a4);
  final Color line2Color2 = const Color(0xffdbdbdb);
  final Color sideTitleColor = const Color(0xff7589a2);
  final Color gridLineColor = const Color(0xffb7ceeb);

  int getMinY(List<CarbonIntensity> data) {
    int? minActual;
    try {
      minActual = data
          .where((i) => i.actualIntensity != null)
          .map((i) => i.actualIntensity!)
          .reduce((a, b) => a < b ? a : b)
          .toInt();
    } catch (e) {
      // For days in future this could be empty and that is ok
    }

    int minForecast = data
        .map((i) => i.forecastIntensity)
        .reduce((a, b) => a < b ? a : b)
        .toInt();

    int minBoth = minActual != null ? min(minActual, minForecast) : minForecast;

    // nearest multiple of 20 rounded down
    return minBoth - minBoth % 20;
  }

  int getMaxY(List<CarbonIntensity> data) {
    int? maxActual;
    try {
      maxActual = data
          .where((i) => i.actualIntensity != null)
          .map((i) => i.actualIntensity!)
          .reduce((a, b) => a > b ? a : b)
          .toInt();
    } catch (e) {
      // For days in future this could be empty and that is ok
    }

    int maxForecast = data
        .map((i) => i.forecastIntensity)
        .reduce((a, b) => a > b ? a : b)
        .toInt();

    int maxBoth = maxActual != null ? max(maxActual, maxForecast) : maxForecast;

    // nearest multiple of 20 rounded up
    return maxBoth + 20 - maxBoth % 20;
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      fontSize: 16,
      color: sideTitleColor,
    );

    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Text(
        value.toInt().toString(),
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    if (value % 5 != 0) {
      return Container();
    }
    var style = TextStyle(
      fontWeight: FontWeight.bold,
      color: sideTitleColor,
    );

    // convert double value hours and minutes back into datetime
    int hours = value.toInt();
    int minutes = ((value - value.toInt()) * 60).toInt();
    String timeText =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(timeText, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<FlSpot> actualSpots = widget.data
        .map((e) => e.actualIntensity != null
            ? FlSpot(e.from.hour.toDouble() + e.from.minute.toDouble() / 60,
                e.actualIntensity!.toDouble())
            : null)
        .where((element) => element != null)
        .cast<FlSpot>()
        .toList();

    LineChartBarData actualLineChartBarData = LineChartBarData(
      spots: actualSpots,
      color: actualIntensityLineColor,
      isCurved: true,
      isStrokeCapRound: true,
      barWidth: 3,
      belowBarData: BarAreaData(
        show: false,
      ),
      dotData: const FlDotData(show: false),
    );

    List<FlSpot> forecastSpots = widget.data
        .map((e) => FlSpot(
            e.from.hour.toDouble() + e.from.minute.toDouble() / 60,
            e.forecastIntensity.toDouble()))
        .toList();

    LineChartBarData forecastLineChartBarData = LineChartBarData(
      spots: forecastSpots,
      gradient: LinearGradient(
        colors: [
          line2Color1,
          line2Color2,
        ],
      ),
      isCurved: true,
      isStrokeCapRound: true,
      barWidth: 3,
      belowBarData: BarAreaData(
        show: false,
      ),
      dotData: const FlDotData(show: false),
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text(
            'Forecasted vs Actual Intensity of carbon in the UK on the selected date. Tap the chart for a detailed summary at a particular time. Intensity is measured in gCO2/kWh.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 2,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  actualLineChartBarData,
                  forecastLineChartBarData,
                ],
                minY: getMinY(widget.data).toDouble(),
                maxY: getMaxY(widget.data).toDouble(),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: leftTitleWidgets,
                      reservedSize: 38,
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: bottomTitleWidgets,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.fromBorderSide(
                    BorderSide(color: gridLineColor),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: false,
                  verticalInterval: null,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: gridLineColor,
                      strokeWidth: 0.5,
                    );
                  },
                ),
                lineTouchData: LineTouchData(
                  touchCallback:
                      (FlTouchEvent event, LineTouchResponse? response) {
                    print('event position: ${event.localPosition}');
                    if (response != null) {
                      response.lineBarSpots?.forEach((element) {
                        setState(() {
                          lastTouchedSpotIndex = element.spotIndex;
                          ref
                              .read(historicCarbonIntensityControllerProvider
                                  .notifier)
                              .setSelectedData(
                                  widget.data[element.spotIndex.toInt()]);
                        });
                      });
                      return;
                    }
                  },
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (LineBarSpot barSpot) => line2Color1,
                    getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                      return lineBarsSpot.map((barSpot) {
                        return LineTooltipItem(
                          barSpot.y.toString(),
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                    fitInsideVertically: true,
                  ),
                  handleBuiltInTouches: false,
                ),
                showingTooltipIndicators: [
                  ShowingTooltipIndicators(
                    [
                      if (lastTouchedSpotIndex != null)
                        LineBarSpot(
                          actualLineChartBarData,
                          0,
                          forecastSpots[lastTouchedSpotIndex!],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _Legend(
            actualColor: actualIntensityLineColor,
            forecastColor: line2Color1,
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color actualColor;
  final Color forecastColor;

  const _Legend({required this.actualColor, required this.forecastColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              width: 20,
              height: 20,
              color: actualColor,
            ),
            const SizedBox(width: 4),
            const Text('Actual'),
          ],
        ),
        const SizedBox(width: 16),
        Row(
          children: [
            Container(
              width: 20,
              height: 20,
              color: forecastColor,
            ),
            const SizedBox(width: 4),
            const Text('Forecast'),
          ],
        ),
      ],
    );
  }
}
