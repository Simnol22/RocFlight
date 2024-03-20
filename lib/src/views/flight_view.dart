import 'package:flutter/material.dart';

enum FlightMode { operatorMode, launcherMode }

enum ConnectionStatus { connected, disconnected, pending }

Widget _buildStatusIndicator(ConnectionStatus status) {
  Color color;
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
              status.toString().split('.').last.toUpperCase(),
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
  FlightMode? _selectedFlightMode = FlightMode.operatorMode;
  final ConnectionStatus _connectionStatus = ConnectionStatus.disconnected;
  final String _flightCode = '0T0E0M0P0';

  void _onTryConnectToFlight(String flightCode) {
    print(flightCode);
  }

  void _onFlightModeChanged(FlightMode? mode) {
    setState(() { _selectedFlightMode = mode; });
  }

  void _onCreateNewFlight() { }

  void _onStartFlight() { }

  void _onEndFlight() { }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          DropdownButton<FlightMode>(
            value: _selectedFlightMode,
            onChanged: _onFlightModeChanged,
            items: const [
              DropdownMenuItem(value: FlightMode.operatorMode, child: Text('Operator Mode')),
              DropdownMenuItem(value: FlightMode.launcherMode, child: Text('Launcher Mode')),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_selectedFlightMode == FlightMode.operatorMode ?
              _OperatorModeWidget(
                connectionStatus: _connectionStatus,
                onConnectPressed: _onTryConnectToFlight,
              )
            :
              _LauncherModeWidget(
                flightCode: _flightCode,
                connectionStatus: _connectionStatus,
                onCreateFlightPressed: _onCreateNewFlight,
                onStartFlightPressed: _onStartFlight,
                onEndFlightPressed: _onEndFlight,
              ),
            ]
          ),
        ),
      ),
    );
  }
}

// Launcher mode view
class _LauncherModeWidget extends StatefulWidget {
  const _LauncherModeWidget({
    this.flightCode = '',
    required this.onCreateFlightPressed,
    required this.onStartFlightPressed,
    required this.onEndFlightPressed,
    required this.connectionStatus
  });

  final String flightCode;
  final ConnectionStatus connectionStatus;
  final Function onCreateFlightPressed;
  final Function onStartFlightPressed;
  final Function onEndFlightPressed;

  @override
  _LauncherModeWidgetState createState() => _LauncherModeWidgetState();
}

class _LauncherModeWidgetState extends State<_LauncherModeWidget> {
  late String flightCode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStatusIndicator(widget.connectionStatus),
        CustomCard(
          title: "Flight code",
          children: Column(
            children: [
              Text(
                widget.flightCode,
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
                  onPressed: () => { widget.onCreateFlightPressed() },
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
                  onPressed: () => { widget.onStartFlightPressed() },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    minimumSize: const Size(double.infinity, 60),
                  ),
                  child: const Text('Start flight'),
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => { widget.onEndFlightPressed() },
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
    required this.onConnectPressed,
    required this.connectionStatus
  });

  final ConnectionStatus connectionStatus;
  final Function(String flightCode) onConnectPressed;

  @override
  _OperatorModeWidgetState createState() => _OperatorModeWidgetState();
}

class _OperatorModeWidgetState extends State<_OperatorModeWidget> {
  late String flightCode = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStatusIndicator(widget.connectionStatus),

        CustomCard(
          title: "Enter flight code",
          children: Column(
            children: [
              TextField(
                onChanged: (value) { setState(() { flightCode = value; }); },
                decoration: const InputDecoration( labelText: 'Code' ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () { widget.onConnectPressed(flightCode); },
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