import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:roc_flight/src/model/flight.dart';
import 'package:roc_flight/src/viewmodel/flight_view_model.dart';

enum FlightMode { operator, launcher }
enum ConnectionStatus { connected, disconnected, pending }

Widget _buildStatusIndicator(Flight? flight) {
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

    mode = flight.amILauncher ? FlightMode.launcher : FlightMode.operator; 
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
              )
            ),
            const SizedBox(width: 5),
            Text(
              '${status.toString().split('.').last.toUpperCase()} ${mode == null ? '' : 'AS ${mode.toString().split('.').last.toUpperCase()}'}',
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    )
  );
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
    setState(() { _selectedFlightMode = mode; });
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
                            onConnectPressed: (code) => value.connectToFlightByCode(code),
                          )
                        : _LauncherModeWidget(
                            flight: value.flight,
                            onCreateFlightPressed: value.createFlight,
                            onStartFlightPressed: value.startFlight,
                            onEndFlightPressed: value.endFlight,
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
    required this.onCreateFlightPressed,
    required this.onStartFlightPressed,
    required this.onEndFlightPressed,
  });

  final Flight? flight;
  final Function onCreateFlightPressed;
  final Function onStartFlightPressed;
  final Function onEndFlightPressed;

  @override
  _LauncherModeWidgetState createState() => _LauncherModeWidgetState();
}

class _LauncherModeWidgetState extends State<_LauncherModeWidget> {

  bool _hasActiveFlight() {
    return (widget.flight?.isActive??false);
  }

  bool _hasStartedFlight() {
    return (!_hasActiveFlight()) || (widget.flight?.iStarted??false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStatusIndicator(widget.flight),
        
        CustomCard(
          title: "Flight code",
          children: Column(
            children: [
              Text(
                widget.flight?.flightCode??"NO CODE",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w800, 
                  fontSize: 18
                )
              ),
              
              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _hasActiveFlight() ? null : () => { widget.onCreateFlightPressed() },
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
                  onPressed: _hasStartedFlight() ? null : () => { widget.onStartFlightPressed() },
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
                  onPressed: !_hasActiveFlight() ? null : () => { widget.onEndFlightPressed() },
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  child: const Text('End flight'),
                ),
              ),
            ],
          ),
        ),
      ]
    );
  }
}

// Operator mode view
class _OperatorModeWidget extends StatefulWidget {
  const _OperatorModeWidget({
    required this.flight,
    required this.onConnectPressed,
  });

  final Flight? flight;
  final bool Function(String flightCode) onConnectPressed;

  @override
  _OperatorModeWidgetState createState() => _OperatorModeWidgetState();
}

class _OperatorModeWidgetState extends State<_OperatorModeWidget> {
  late String flightCode = "";

  bool _hasActiveFlight() {
    return (widget.flight?.isActive??false);
  }

  void _onTryConnectToFlight() {
    widget.onConnectPressed(flightCode); 
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStatusIndicator(widget.flight),

        CustomCard(
          title: "Enter flight code",
          children: Column(
            children: [
              TextField(
                enabled: !_hasActiveFlight(),
                onChanged: (value) { setState(() { flightCode = value; }); },
                inputFormatters: [ LengthLimitingTextInputFormatter(6) ],
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration( labelText: 'Code' ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                
                child: ElevatedButton(
                  onPressed: _hasActiveFlight() ? null : () => { _onTryConnectToFlight() },
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