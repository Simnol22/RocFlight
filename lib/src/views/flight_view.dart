import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:roc_flight/src/model/flight.dart';
import 'package:roc_flight/src/services/sensors.dart';
import 'package:roc_flight/src/viewmodel/flight_view_model.dart';
import 'package:sensors_plus/sensors_plus.dart';

enum FlightMode { operator, launcher }

enum ConnectionStatus { connected, disconnected, pending }

Widget _buildStatusIndicator(Flight? flight, bool? isLauncher) {
  Color color;
  ConnectionStatus status = ConnectionStatus.disconnected;
  FlightMode? mode;

  if (flight != null) {
    if (flight.status == FlightStatus.created || flight.status == FlightStatus.started) {
      status = ConnectionStatus.connected;
    } else if (flight.status == FlightStatus.ended) {
      status = ConnectionStatus.disconnected;
    } else {
      status = ConnectionStatus.pending;
    }
    if (isLauncher != null) {
      mode = isLauncher ? FlightMode.launcher : FlightMode.operator;
    }
  }

  switch (status) {
    case ConnectionStatus.connected:
      color = Colors.green;
      break;
    case ConnectionStatus.disconnected:
      color = Colors.red;
      break;
    case ConnectionStatus.pending:
      color = Colors.yellow;
      break;
  }

  return CustomCard(
      title: "Status",
      children: Column(
        children: [
          Row(
            children: [
              Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  )),
              const SizedBox(width: 5),
              Text(
                '${status.toString().split('.').last.toUpperCase()} ${mode == null ? '' : 'AS ${mode.toString().split('.').last.toUpperCase()}'}',
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ));
}

class FlightView extends StatefulWidget {
  const FlightView({super.key});

  static const routeName = '/flight-view';

  @override
  FlightViewState createState() => FlightViewState();
}

class FlightViewState extends State<FlightView> {
  FlightMode? _selectedFlightMode = FlightMode.operator;

  void _onFlightModeChanged(FlightMode? mode) {
    setState(() {
      _selectedFlightMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          DropdownButton<FlightMode>(
            value: _selectedFlightMode,
            onChanged: _onFlightModeChanged,
            style: const TextStyle(color: Colors.lightGreen),
            items: const [
              DropdownMenuItem(
                value: FlightMode.operator,
                child: Text('Operator Mode'),
              ),
              DropdownMenuItem(value: FlightMode.launcher, child: Text('Launcher Mode')),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: ChangeNotifierProvider<FlightViewModel>(
        create: (context) => FlightViewModel(),
        child: Consumer<FlightViewModel>(
          builder: (context, value, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _selectedFlightMode == FlightMode.operator
                        ? _OperatorModeWidget(
                            flight: value.flight,
                            flightViewModel: value,
                            onConnectPressed: (code) => value.connectToFlightByCode(code),
                          )
                        : _LauncherModeWidget(
                            flight: value.flight,
                            flightViewModel: value,
                          ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Launcher mode view
class _LauncherModeWidget extends StatefulWidget {
  const _LauncherModeWidget({
    required this.flight,
    required this.flightViewModel,
  });

  final Flight? flight;
  final FlightViewModel flightViewModel;

  @override
  _LauncherModeWidgetState createState() => _LauncherModeWidgetState();
}

class _LauncherModeWidgetState extends State<_LauncherModeWidget> {
  bool _hasActiveFlight() {
    return (widget.flight?.isActive ?? false);
  }

  bool _hasStartedFlight() {
    return (!_hasActiveFlight()) || (widget.flight?.iStarted ?? false);
  }

  @override
  Widget build(BuildContext context) {
    SensorService sensorService = SensorService();

    return Column(children: [
      FutureBuilder<bool>(
        future: widget.flightViewModel.amITheFlightLauncher(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildStatusIndicator(widget.flight, null);
          } else {
            return _buildStatusIndicator(widget.flight, snapshot.data ?? false);
          }
        },
      ),
      CustomCard(
        title: "Flight code",
        children: Column(
          children: [
            Text(widget.flight?.flightCode ?? "NO CODE",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w800, fontSize: 18)),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _hasActiveFlight() ? null : () => {widget.flightViewModel.createFlight()},
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                child: const Text('Create flight'),
              ),
            ),
          ],
        ),
      ),
      CustomCard(
        title: "Controls",
        children: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _hasStartedFlight() ? null : () => {widget.flightViewModel.startFlight()},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  disabledBackgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  minimumSize: const Size(double.infinity, 60),
                ),
                child: const Text('Start flight'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: !_hasActiveFlight() ? null : () => {widget.flightViewModel.endFlight()},
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                child: const Text('End flight'),
              ),
            ),
          ],
        ),
      ),

      CustomCard(
        title: "Altitude",
        children: StreamBuilder<double>(
          stream: widget.flightViewModel.getAltitude(),
          builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
            if (snapshot.hasData) {
              double? event = snapshot.data;
              return SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Text('Altitude : ${event?.toStringAsFixed(2)} m')
                  ],
                ),
              );
            }
            return const Text('No data');
          },
        ),
      ),

      //CustomCard(
      //  title: "Accelerometer",
      //  children: StreamBuilder<AccelerometerEvent>(
      //    stream: sensorService.getAccelerometerStream(),
      //    builder: (BuildContext context, AsyncSnapshot<AccelerometerEvent> snapshot) {
      //      if (snapshot.hasData) {
      //        AccelerometerEvent? event = snapshot.data;
      //        return SizedBox(
      //          width: double.infinity,
      //          child: Column(
      //            children: [
      //              Text('x:${event?.x.toStringAsFixed(2)}'),
      //              Text('y:${event?.y.toStringAsFixed(2)}'),
      //              Text('z:${event?.z.toStringAsFixed(2)}'),
      //            ],
      //          ),
      //        );
      //      }
      //      return const Text('No data');
      //    },
      //  ),
      //),
      //CustomCard(
      //  title: "Gyroscope",
      //  children: StreamBuilder<GyroscopeEvent>(
      //    stream: sensorService.getGyroscopeStream(),
      //    builder: (BuildContext context, AsyncSnapshot<GyroscopeEvent> snapshot) {
      //      if (snapshot.hasData) {
      //        GyroscopeEvent? event = snapshot.data;
      //        return SizedBox(
      //          width: double.infinity,
      //          child: Column(
      //            children: [
      //              Text('x:${event?.x.toStringAsFixed(2)}'),
      //              Text('y:${event?.y.toStringAsFixed(2)}'),
      //              Text('z:${event?.z.toStringAsFixed(2)}'),
      //            ],
      //          ),
      //        );
      //      }
      //      return const Text('No data');
      //    },
      //  ),
      //),
      //CustomCard(
      //  title: "Magnometer",
      //  children: StreamBuilder<MagnetometerEvent>(
      //    stream: sensorService.getMagnometerStream(),
      //    builder: (BuildContext context, AsyncSnapshot<MagnetometerEvent> snapshot) {
      //      if (snapshot.hasData) {
      //        MagnetometerEvent? event = snapshot.data;
      //        return SizedBox(
      //          width: double.infinity,
      //          child: Column(
      //            children: [
      //              Text('x:${event?.x.toStringAsFixed(2)}'),
      //              Text('y:${event?.y.toStringAsFixed(2)}'),
      //              Text('z:${event?.z.toStringAsFixed(2)}'),
      //            ],
      //          ),
      //        );
      //      }
      //      return const Text('No data');
      //    },
      //  ),
      //)
    ]);
  }
}

// Operator mode view
class _OperatorModeWidget extends StatefulWidget {
  const _OperatorModeWidget({
    required this.flight,
    required this.flightViewModel,
    required this.onConnectPressed,
  });

  final Flight? flight;
  final FlightViewModel flightViewModel;
  final bool Function(String flightCode) onConnectPressed;

  @override
  _OperatorModeWidgetState createState() => _OperatorModeWidgetState();
}

class _OperatorModeWidgetState extends State<_OperatorModeWidget> {
  late String flightCode = "";

  bool _hasActiveFlight() {
    return (widget.flight?.isActive ?? false);
  }

  void _onTryConnectToFlight() {
    widget.onConnectPressed(flightCode);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<bool>(
          future: widget.flightViewModel.amITheFlightLauncher(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildStatusIndicator(widget.flight, null);
            } else {
              return _buildStatusIndicator(widget.flight, snapshot.data ?? false);
            }
          },
        ),
        CustomCard(
          title: "Enter flight code",
          children: Column(
            children: [
              TextField(
                enabled: !_hasActiveFlight(),
                onChanged: (value) {
                  setState(() {
                    flightCode = value;
                  });
                },
                inputFormatters: [LengthLimitingTextInputFormatter(6)],
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(labelText: 'Code'),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _hasActiveFlight() ? null : () => {_onTryConnectToFlight()},
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  child: const Text('Connect'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final Widget children;

  const CustomCard({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              children,
            ],
          ),
        ),
      ),
    );
  }
}
