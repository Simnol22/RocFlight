import 'package:flutter/material.dart';
import 'package:roc_flight/src/views/find_view.dart';
import 'package:roc_flight/src/views/flight_view.dart';
import 'package:roc_flight/src/views/history_view.dart';
import 'package:roc_flight/src/views/live_data_view.dart';
import 'package:provider/provider.dart';
import 'package:roc_flight/src/viewmodel/location_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  static const routeName = '/home-view';

  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  int _currentIndex = 0;

  Widget _getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return const FlightView();
      case 1:
        return const LiveDataView();
      case 2:
        return ChangeNotifierProvider<LocationViewModel>(
          create: (_) => LocationViewModel(),
          child: const FindView(),
        );
      case 3:
        return const HistoryView();
      default:
        return const FlightView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RocFlight'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings screen
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: _getCurrentPage(), // Dynamically get the current page
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.rocket_launch),
            label: 'Flight',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.satellite_alt),
            label: 'LiveData',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Find',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            label: 'History',
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
