import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:roc_flight/src/viewmodel/live_data_view_model.dart';

class LiveDataView extends StatelessWidget {
  const LiveDataView({super.key});

  static const routeName = '/live-data-view';

  @override
  Widget build(BuildContext context) {
    return Consumer<LiveDataViewModel>(
      builder: (context, liveDataViewModel, child) {
        return GridView.count(
          crossAxisCount: 2,
          children: [
            Card(child: LineChartWidget(data: liveDataViewModel.getMockAltitudeData(), title: 'Altitude over Time')),
            const Card(child: Center(child: Text('Altitude: '))),
            Card(child: LineChartWidget(data: liveDataViewModel.getMockVelocityData(), title: 'Velocity over Time')),
            Card(
                child: LineChartWidget(
                    data: liveDataViewModel.getMockAccelerationData(), title: 'Acceleration over Time')),
            Card(
                child: LineChartWidget(
                    data: liveDataViewModel.getMockAngularVelocityData(), title: 'Angular Velocity over Time')),
          ],
        );
      },
    );
  }
}

class LineChartWidget extends StatelessWidget {
  final List<double> data;
  final String title;

  const LineChartWidget({super.key, required this.data, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true),
                titlesData: const FlTitlesData(show: true),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                    isCurved: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
