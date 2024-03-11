import 'package:flutter/material.dart';
import 'package:roc_flight/src/views/find_view.dart';
import 'package:roc_flight/src/views/flight_view.dart';
import 'package:roc_flight/src/views/history_view.dart';
import 'package:roc_flight/src/views/live_data_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  static const routeName = '/home-view';

  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const FlightView(),
    const LiveDataView(),
    const FindView(),
    const HistoryView(),
  ];

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
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.green,
        type: BottomNavigationBarType.fixed,
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
          )
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
