import 'package:flutter/material.dart';

enum FlightMode { operatorMode, rocketMode }

enum ConnectionStatus { connected, notConnected, pending }

class FlightView extends StatefulWidget {
  const FlightView({super.key});

  static const routeName = '/flight-view';

  @override
  FlightViewState createState() => FlightViewState();
}

class FlightViewState extends State<FlightView> {
  FlightMode? _selectedFlightMode = FlightMode.operatorMode;
  ConnectionStatus _connectionStatus = ConnectionStatus.connected;

  String _flightCode = '';

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
          Row(
            children: [
              _buildStatusIndicator(_connectionStatus),
              const SizedBox(width: 5),
              Text(
                _connectionStatus.toString().split('.').last,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(width: 16),
          DropdownButton<FlightMode>(
            value: _selectedFlightMode,
            onChanged: _onFlightModeChanged,
            items: const [
              DropdownMenuItem(value: FlightMode.operatorMode, child: Text('Operator Mode')),
              DropdownMenuItem(value: FlightMode.rocketMode, child: Text('Rocket Mode')),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _selectedFlightMode == FlightMode.operatorMode
                ? Column(
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() { _flightCode = value; });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Flight Code',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement connect button functionality
                  },
                  child: const Text('Connect'),
                ),
              ],
            )
                : Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Implement new flight button functionality
                  },
                  child: const Text('New Flight'),
                ),
                const SizedBox(height: 20),
                Text(
                  'Flight Code: $_flightCode',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Implement start flight button functionality
                  },
                  child: const Text('Start Flight'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Implement end flight button functionality
                  },
                  child: const Text('End Flight'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(ConnectionStatus status) {
    Color color;
    switch (status) {
      case ConnectionStatus.connected:
        color = Colors.green;
        break;
      case ConnectionStatus.notConnected:
        color = Colors.red;
        break;
      case ConnectionStatus.pending:
        color = Colors.yellow;
        break;
    }
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}