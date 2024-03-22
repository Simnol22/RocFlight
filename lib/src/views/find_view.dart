import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:roc_flight/src/viewmodel/location_view_model.dart';

class FindView extends StatefulWidget {
  const FindView({Key? key}) : super(key: key);

  static const routeName = '/find-view';

  @override
  State<FindView> createState() => _FindViewState();
}

class _FindViewState extends State<FindView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final locationViewModel =
          Provider.of<LocationViewModel>(context, listen: false);
      locationViewModel.fetchCurrentLocation();
      locationViewModel.fetchRocketLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationViewModel = Provider.of<LocationViewModel>(context);

    // Use the current and rocket locations from the ViewModel
    final currentLocation = locationViewModel.currentPosition != null
        ? LatLng(locationViewModel.currentPosition!.latitude,
            locationViewModel.currentPosition!.longitude)
        : LatLng(0, 0); // Default or loading state
    final rocketLocation = locationViewModel.rocketLocation ??
        LatLng(0, 0); // Default or loading state
    final distanceToFlight = locationViewModel.calculateDistanceToRocket();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                title: const Text('Flight Location'),
                subtitle: Text(
                  'Lat: ${rocketLocation.latitude} Lon: ${rocketLocation.longitude}\nDistance: ${distanceToFlight.toStringAsFixed(2)}m',
                ),
                trailing: const Icon(Icons.rocket),
              ),
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentLocation.latitude != 0 &&
                        currentLocation.longitude != 0
                    ? currentLocation
                    : rocketLocation,
                zoom: 14,
              ),
              markers: {
                if (locationViewModel.currentPosition != null)
                  Marker(
                    // Marker for Current location
                    markerId: const MarkerId('current_location'),
                    position: currentLocation,
                  ),
                Marker(
                  // Marker for Rocket's location
                  markerId: const MarkerId('rocket_location'),
                  position: rocketLocation,
                ),
              },
              polylines: {
                if (locationViewModel.currentPosition != null &&
                    locationViewModel.rocketLocation != null)
                  Polyline(
                    polylineId: const PolylineId('route'),
                    points: [currentLocation, rocketLocation],
                    color: Colors.blue,
                    width: 5,
                  ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
