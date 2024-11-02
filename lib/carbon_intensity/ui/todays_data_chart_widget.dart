import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../domain/carbon_intensity.dart';

class IntensityDataChartWidget extends StatefulWidget {
  final List<CarbonIntensity> data;

  IntensityDataChartWidget({required this.data});

  @override
  State<IntensityDataChartWidget> createState() =>
      _IntensityDataChartWidgetState();
}

class _IntensityDataChartWidgetState extends State<IntensityDataChartWidget> {
  int? lastTouchedSpotIndex;

  final Color line1Color1 = const Color(0xff4af699);

  final Color line1Color2 = const Color(0xff6f5ce7);

  final Color line2Color1 = const Color(0xffa4a4a4);

  final Color line2Color2 = const Color(0xffdbdbdb);

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
      color: line1Color1,
      fontWeight: FontWeight.bold,
      fontSize: 18,
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

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
      color: line2Color2,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );

    return Text('0', style: style, textAlign: TextAlign.right);
  }

  Widget topTitleWidgets(double value, TitleMeta meta) {
    if (value % 1 != 0) {
      return Container();
    }
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      color: Color(0xff7589a2),
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(value.toInt().toString(), style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = widget.data
        .map((e) => e.actualIntensity != null
            ? FlSpot(e.from.hour.toDouble(), e.actualIntensity!.toDouble())
            : null)
        .where((element) => element != null)
        .cast<FlSpot>()
        .toList();

    LineChartBarData lineChartBarData = LineChartBarData(
      spots: spots,
      gradient: LinearGradient(
        colors: [
          line1Color1,
          line1Color2,
        ],
      ),
      isCurved: true,
      isStrokeCapRound: true,
      barWidth: 10,
      belowBarData: BarAreaData(
        show: false,
      ),
    );

    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(
        LineChartData(
            lineBarsData: [
              lineChartBarData,
            ],
            minY: widget.data
                .where((i) => i.actualIntensity != null)
                .map((i) => i.actualIntensity!)
                .reduce((a, b) => a < b ? a : b)
                .toDouble(),
            maxY: widget.data
                .where((i) => i.actualIntensity != null)
                .map((i) => i.actualIntensity!)
                .reduce((a, b) => a > b ? a : b)
                .toDouble(),
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
                  getTitlesWidget: topTitleWidgets,
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: const Border(
                left: BorderSide(color: Color(0xff4af699)),
                top: BorderSide(color: Color(0xff4af699)),
                bottom: BorderSide(color: Colors.transparent),
                right: BorderSide(color: Colors.transparent),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              drawVerticalLine: false,
              verticalInterval: 20,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: const Color(0xff4af699),
                  strokeWidth: 0.5,
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: const Color(0xff4af699),
                  strokeWidth: 0.5,
                );
              },
            ),
            lineTouchData: LineTouchData(
              touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
                print('event position: ${event.localPosition}');
                if (response != null) {
                  response.lineBarSpots?.forEach((element) {
                    print('spot: ${element.spotIndex}');
                    setState(() {
                      lastTouchedSpotIndex = element.spotIndex;
                    });
                  });
                  return;
                }
              },
              handleBuiltInTouches: false,
            ),
            showingTooltipIndicators: [
              ShowingTooltipIndicators([
                LineBarSpot(
                  lineChartBarData,
                  0,
                  spots[lastTouchedSpotIndex ?? 10],
                ),
              ]),
            ]),
      ),
    );
  }
}
