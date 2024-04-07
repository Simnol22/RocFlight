import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:roc_flight/src/components/custom_card.dart';

class LineChartItem {
  final Color color;
  final bool? fill;
  final String label;
  final List<double> values;

  LineChartItem({
    required this.color,
    required this.label,
    required this.values,
    this.fill = false
  });
}

// Source code inspired from
// https://github.com/imaNNeo/fl_chart/blob/main/example/lib/presentation/samples/line/line_chart_sample10.dart
class AnimatedLineChart extends StatefulWidget {
  AnimatedLineChart({
    super.key,
    required this.title,
    required this.firstLine,
    this.limit = 100,
    this.secondLine,
    this.thirdLine
  });

  final String title;
  final int limit;
  final LineChartItem firstLine;
  final LineChartItem? secondLine;
  final LineChartItem? thirdLine;

  @override
  State<AnimatedLineChart> createState() => _AnimatedLineChartState();
}

class _AnimatedLineChartState extends State<AnimatedLineChart> {
  double xValue = 0;
  double step = 0.05;
  Timer? timer;
  double minY = 0;
  double maxY = 0;

  final firstLinePoints = <FlSpot>[];
  final secondLinePoints = <FlSpot>[];
  final thirdLinePoints = <FlSpot>[];

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      while (firstLinePoints.length > widget.limit) {
        if (firstLinePoints.isNotEmpty) { firstLinePoints.removeAt(0); }
        if (secondLinePoints.isNotEmpty) { secondLinePoints.removeAt(0); }
        if (thirdLinePoints.isNotEmpty) { thirdLinePoints.removeAt(0); }
      }
      
      setState(() {
        if (widget.firstLine.values.isNotEmpty) {
          firstLinePoints.add(FlSpot(xValue, widget.firstLine.values.last));

          for (FlSpot spot in firstLinePoints) {
            if (spot.y < minY) { minY = spot.y; }
            if (spot.y > maxY) { maxY = spot.y; }
          }
        }

        if (widget.secondLine != null && widget.secondLine!.values.isNotEmpty) {
          secondLinePoints.add(FlSpot(xValue, widget.secondLine!.values.last));

          for (FlSpot spot in secondLinePoints) {
            if (spot.y < minY) { minY = spot.y; }
            if (spot.y > maxY) { maxY = spot.y; }
          }
        }

        if (widget.thirdLine != null && widget.thirdLine!.values.isNotEmpty) {
          thirdLinePoints.add(FlSpot(xValue, widget.thirdLine!.values.last));

          for (FlSpot spot in thirdLinePoints) {
            if (spot.y < minY) { minY = spot.y; }
            if (spot.y > maxY) { maxY = spot.y; }
          }
        }
      });

      xValue += step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: widget.title, 
      children: firstLinePoints.isEmpty ? Container() :
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 6),
            AspectRatio(
              aspectRatio: 1.5,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: LineChart(
                  LineChartData(
                    minY: minY.round().toDouble()-2,
                    maxY: maxY.round().toDouble()+2,
                    lineTouchData: const LineTouchData(enabled: false),
                    clipData: const FlClipData.all(),
                    gridData: const FlGridData(
                      show: true,
                      drawVerticalLine: true,
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      lineDataDefault(widget.firstLine, firstLinePoints),
                      if (widget.secondLine != null)
                        lineDataDefault(widget.secondLine!, secondLinePoints),
                      if (widget.thirdLine != null)
                        lineDataDefault(widget.thirdLine!, thirdLinePoints),
                    ],
                    titlesData: const FlTitlesData(
                      show: true,
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              '${widget.firstLine.label}: ${firstLinePoints.last.y.toStringAsFixed(2)}',
              style: TextStyle(color: widget.firstLine.color, fontSize: 15),
            ),
            if (widget.secondLine != null)
              Text(
                '${widget.secondLine!.label}: ${secondLinePoints.isNotEmpty ? secondLinePoints.last.y.toStringAsFixed(2) : 0}',
                style: TextStyle(color: widget.secondLine!.color, fontSize: 15),
              ),
            if (widget.thirdLine != null)
              Text(
                '${widget.thirdLine!.label}: ${thirdLinePoints.isNotEmpty ? thirdLinePoints.last.y.toStringAsFixed(2) : 0}',
                style: TextStyle(color: widget.thirdLine!.color, fontSize: 15),
              ),
          ],
        )
    );
  }

  LineChartBarData lineDataFilled(LineChartItem item, List<FlSpot> points) {
    List<Color> gradientColors = [item.color.withOpacity(0.6), item.color];
    
    return LineChartBarData(
      spots: points,
      isCurved: true,
      gradient: LinearGradient(colors: gradientColors),
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
        ),
      ),
    );
  }

  LineChartBarData lineDataDefault(LineChartItem item, List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: const FlDotData(show: false),
      isCurved: true,
      isStrokeCapRound: true,
      gradient: LinearGradient(
        colors: [item.color.withOpacity(0.6), item.color],
        stops: const [0.1, 1.0],
      ),
      belowBarData: item.fill??false ? BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [item.color.withOpacity(0.6), item.color].map((color) => color.withOpacity(0.3)).toList(),
        ),
      ) : null,
      barWidth: 4,
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}