import 'package:flutter/material.dart';
import 'package:roc_flight/src/viewmodel/flight_view_model.dart';
import 'package:roc_flight/src/viewmodel/live_data_view_model.dart';
import 'package:roc_flight/src/views/find_view.dart';
import 'package:roc_flight/src/views/flight_view.dart';
import 'package:roc_flight/src/views/history_view.dart';
import 'package:roc_flight/src/views/live_data_view.dart';
import 'package:provider/provider.dart';
import 'package:roc_flight/src/viewmodel/location_view_model.dart';
import 'package:roc_flight/src/services/location_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  static const routeName = '/home-view';

  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission(); // Request location permission on app start
  }

  void _requestLocationPermission() async {
    final prefs = await SharedPreferences.getInstance();
    bool? askedBefore = prefs.getBool('askedForLocationPermission');

    if (askedBefore != true) {
      bool hasPermission =
          await LocationService().checkAndRequestLocationPermissions();
      await prefs.setBool('askedForLocationPermission', true);

      if (!hasPermission) {
        // TODO: Handle the case where location permissions are not granted
      }
    }
  }

  Widget _getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        // Use Provider.of or Consumer to access the existing FlightViewModel instance
        return Consumer<FlightViewModel>(
          builder: (context, flightViewModel, child) => const FlightView(),
        );
      case 1:
        return ChangeNotifierProvider<LiveDataViewModel>(
          create: (context) => LiveDataViewModel(context),
          child: const LiveDataView(),
        );
      case 2:
        return ChangeNotifierProvider<LocationViewModel>(
          create: (context) => LocationViewModel(
              Provider.of<FlightViewModel>(context, listen: false)),
          child: const FindView(),
        );
      case 3:
        return const HistoryView();
      default:
        return ChangeNotifierProvider<FlightViewModel>(
          create: (context) => FlightViewModel(),
          child: const FlightView(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FlightViewModel()),
        // Add other global providers here if necessary
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('RocFlight'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
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
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
