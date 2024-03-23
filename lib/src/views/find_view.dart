import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:roc_flight/src/viewmodel/location_view_model.dart';

class FindView extends StatefulWidget {
  const FindView({super.key});

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
      locationViewModel.fetchUserLocation();
      locationViewModel.fetchRocketLocation('placeholder_rocket_id');
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationViewModel = Provider.of<LocationViewModel>(context);

    final LatLng? currentLocation = locationViewModel.currentPosition != null
        ? LatLng(locationViewModel.currentPosition!.latitude,
            locationViewModel.currentPosition!.longitude)
        : null;

    final LatLng? rocketLocation = locationViewModel.rocketLocation;

    final double? distanceToRocket =
        (currentLocation != null && rocketLocation != null)
            ? locationViewModel.calculateDistanceToRocket()
            : null;

    Set<Marker> markers = {};

    // Check if the rocket location is available and add a marker for it
    if (rocketLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('rocket_location'),
          position: rocketLocation,
          infoWindow: InfoWindow(
            title: 'Rocket Location',
            snippet: 'Distance: ${distanceToRocket?.toStringAsFixed(2)}m',
          ),
        ),
      );
    }

    LatLng initialCameraPosition = currentLocation ??
        rocketLocation ??
        const LatLng(45.5017, -73.5673); // Defaults to Montreal if no location

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                title: const Text('Rocket Location'),
                subtitle: Text(
                  rocketLocation != null
                      ? 'Lat: ${rocketLocation.latitude} Lon: ${rocketLocation.longitude}${distanceToRocket != null ? '\nDistance: ${distanceToRocket.toStringAsFixed(2)}m' : ''}'
                      : 'Rocket location not available',
                ),
                trailing: const Icon(Icons.rocket),
              ),
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: initialCameraPosition,
                zoom: 10,
              ),
              markers: markers,
              myLocationEnabled: true, // Show the blue dot on the map
              myLocationButtonEnabled:
                  true, // Show the button to center the map on the current location
            ),
          ),
        ],
      ),
    );
  }
}
