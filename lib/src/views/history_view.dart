import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roc_flight/src/viewmodel/history_view_model.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  static const routeName = '/history-view';

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HistoryViewModel>(context, listen: false);
    viewModel.fetchFlightHistory();

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Consumer<HistoryViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.flightHistory.isEmpty) {
            return const Center(child: Text('No flight history available.'));
          }
          return ListView.builder(
            itemCount: viewModel.flightHistory.length,
            itemBuilder: (context, index) {
              final flight = viewModel.flightHistory[index];
              return ExpansionTile(
                title: Text(flight.code ?? 'Unknown Flight'),
                subtitle: Text(flight.createdAt.toString()),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Code: ${flight.code}'),
                        Text('Apogee: '),
                        Text('Duration: '),
                        Text('Max Speed: '),
                        Text('Max Altitude: '),
                        Text('Max Acceleration: '),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
