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
      locationViewModel.fetchUserLocation();
      locationViewModel.fetchRocketLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationViewModel = Provider.of<LocationViewModel>(context);

    // Determine the current user's location; null if not available
    final LatLng? currentLocation = locationViewModel.currentPosition != null
        ? LatLng(locationViewModel.currentPosition!.latitude,
            locationViewModel.currentPosition!.longitude)
        : null;

    // Determine the rocket's location; null if not available
    final LatLng? rocketLocation = locationViewModel.rocketLocation;

    // Calculate distance only if both current and rocket locations are available
    final double? distanceToRocket =
        (currentLocation != null && rocketLocation != null)
            ? locationViewModel.calculateDistanceToRocket()
            : null;

    Set<Marker> markers = {};
    Set<Polyline> polylines = {};

    // Add marker for current location if available
    if (currentLocation != null) {
      markers.add(Marker(
        markerId: const MarkerId('current_location'),
        position: currentLocation,
      ));
    }

    // Add marker for rocket location if available
    if (rocketLocation != null) {
      markers.add(Marker(
        markerId: const MarkerId('rocket_location'),
        position: rocketLocation,
      ));
    }

    // Add polyline only if both locations are available
    if (currentLocation != null && rocketLocation != null) {
      polylines.add(Polyline(
        polylineId: const PolylineId('route'),
        points: [currentLocation, rocketLocation],
        color: Colors.blue,
        width: 5,
      ));
    }

    // Decide the initial camera position based on available locations
    LatLng initialCameraPosition = currentLocation ??
        rocketLocation ??
        const LatLng(45.5017, -73.5673); // Montreal

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
                zoom: 5, // Adjusted for a broader view of Canada
              ),
              markers: markers,
              polylines: polylines,
            ),
          ),
        ],
      ),
    );
  }
}
