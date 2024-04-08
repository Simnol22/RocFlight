import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roc_flight/src/components/custom_card.dart';
import 'package:roc_flight/src/components/animated_line_chart.dart';
import 'package:roc_flight/src/viewmodel/live_data_view_model.dart';

class LiveDataView extends StatelessWidget {
  const LiveDataView({super.key});

  static const routeName = '/live-data-view';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Container(
              color: Theme.of(context).primaryColor,
              child: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.clear_all)),
                  Tab(icon: Icon(Icons.insights_outlined)),
                ],
              ),
            ),
          ),
        ),
        //Fetching all the data from the LiveDataViewModel
        body: Consumer<LiveDataViewModel>(
          builder: (context, viewModel, child) {
            return TabBarView(
              children: [
                ListView(
                  children: [
                    _buildViewHeader(viewModel.isConnected),

                    _buildListTile(
                      'Rocket status ', 
                      viewModel.status
                    ),

                    _buildListTile(
                      'Current altitude ', 
                      '${viewModel.altitude.toStringAsFixed(2)} m', 
                      anim: viewModel.isValueDifferent((r) => r.altitude)
                    ),

                    _buildListTile(
                      'Current GPS altitude ', 
                      '${viewModel.altitudeGPS.toStringAsFixed(2)} m', 
                      anim: viewModel.isValueDifferent((r) => r.altitudeGPS)
                    ),

                    _buildListTile(
                      'Max altitude ', 
                      '${viewModel.maxAltitude} m',
                      anim: viewModel.isValueDifferent((r) => r.maxAltitude)
                    ),

                    _buildListTile(
                      'Vertical velocity ', 
                      '${viewModel.verticalVelocity.toStringAsFixed(3)} m/s', 
                      anim: viewModel.isValueDifferent((r) => r.verticalVelocity)
                    ),

                    _buildListTile(
                      'Max velocity ', 
                      '${viewModel.maxVelocity.toStringAsFixed(3)} m/s', 
                      anim: viewModel.isValueDifferent((r) => r.maxSpeed)
                    ),

                    _buildListTile(
                      'Velocity ', 
                      '(${viewModel.velocity.x.toStringAsFixed(1)}, ${viewModel.velocity.y.toStringAsFixed(1)}, ${viewModel.velocity.z.toStringAsFixed(1)}) m/s',
                      anim: viewModel.isValueDifferent((r) => r.velocity)
                    ),
                    
                    _buildListTile(
                      'Acceleration ',  
                      '(${viewModel.acceleration.x.toStringAsFixed(1)}, ${viewModel.acceleration.y.toStringAsFixed(1)}, ${viewModel.acceleration.z.toStringAsFixed(1)}) m/s²',
                      anim: viewModel.isValueDifferent((r) => r.acceleration)
                    ),
                    
                    _buildListTile(
                      'Gyroscope ', 
                      '(${viewModel.gyroscope.x.toStringAsFixed(1)}, ${viewModel.gyroscope.y.toStringAsFixed(1)}, ${viewModel.gyroscope.z.toStringAsFixed(1)}) °/s',
                      anim: viewModel.isValueDifferent((r) => r.gyroscope)
                    ),
                    
                    _buildListTile(
                      'Battery level ', 
                      '${viewModel.batteryLevel} %',
                      anim: viewModel.isValueDifferent((r) => r.batteryLevel)
                    ),
                  
                    _buildListTile(
                      'GPS coordinates ',  
                      'Lat ${viewModel.coordinates.latitude?.toStringAsFixed(6)}, Lon ${viewModel.coordinates.longitude?.toStringAsFixed(6)}',
                      anim: viewModel.isValueDifferent((r) => r.coordinates)
                    ),
                  ],
                ),

                ListView(
                  children: [
                    _buildViewHeader(viewModel.isConnected),

                    AnimatedLineChart(
                      title: "Altitude",
                      limit: 50,
                      firstLine: LineChartItem(
                        color: Colors.pink, 
                        label: "GPS altitude", 
                        values: viewModel.altitudeGPSBuffer,
                        fill: true
                      ),

                      secondLine: LineChartItem(
                        color: Colors.lightBlueAccent, 
                        label: "Altitude", 
                        values: viewModel.altitudeBuffer,
                        fill: true
                      ),
                    ),

                    AnimatedLineChart(
                      title: "Acceleration",
                      limit: 50,
                      firstLine: LineChartItem(
                        color: Colors.redAccent, 
                        label: "x: ", 
                        values: viewModel.accelerationXBuffer
                      ),

                      secondLine: LineChartItem(
                        color: Colors.greenAccent, 
                        label: "y: ", 
                        values: viewModel.accelerationYBuffer
                      ),

                      thirdLine: LineChartItem(
                        color: Colors.blueAccent, 
                        label: "z: ", 
                        values: viewModel.accelerationZBuffer
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        )
      ),
    );
  }

  Widget _buildViewHeader(bool isConnected) {
    return CustomCard(
      title: "Live data",
      children: Column(
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration( shape: BoxShape.circle,
                  color: isConnected ? Colors.green : Colors.red,
                )
              ),
              const SizedBox(width: 5),
              Text(isConnected ? "CONNECTED" : "DISCONNECTED", overflow: TextOverflow.ellipsis),
            ],
          ),
        ],
      ));
  }

  Widget _buildListTile(String label, String value, {bool anim = false}) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: anim ? _AnimatedText(
          duration: const Duration(milliseconds: 300),
          color: Colors.lightGreen,
          value: value,
        ) : Text(value),
      ),
    );
  }
}

class _AnimatedText extends StatefulWidget {
  final Duration duration;
  final Color? color;
  final String value;

  const _AnimatedText({
    required this.duration,
    required this.color,
    required this.value,
  });

  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<_AnimatedText> {
  Color? _currentColor;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  @override
  void didUpdateWidget(covariant _AnimatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _startAnimation();
    }
  }
  //Little animation for new values
  void _startAnimation() {

    try {
      setState(() { _currentColor = widget.color; });

      if (_currentColor != null) {
        timer = Timer(widget.duration, () { 
          timer.isActive ? setState(() { _currentColor = null; }) : null; 
        });
      }
    } catch(e) {}
    
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.value,
      style: TextStyle(
        color: _currentColor,
      ),
    );
  }
}