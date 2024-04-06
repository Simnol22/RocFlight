import 'dart:async';

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
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final locationViewModel = Provider.of<LocationViewModel>(context, listen: false);
      locationViewModel.fetchUserLocation();
      locationViewModel.fetchLatestRocketLocation();
      refreshMapAsync();
    });
  }

  Future<void> refreshMapAsync () async {
    final GoogleMapController controller = await _controller.future;

    final viewModel = Provider.of<LocationViewModel>(context, listen: false);

    controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: viewModel.currentLocation ?? viewModel.rocketLocation ?? const LatLng(45.5017, -73.5673),
      zoom: 12,
    )));

    // Check if the rocket location is available and add a marker for it
    if (viewModel.rocketLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('rocket_location'),
          position: viewModel.rocketLocation!,
          infoWindow: InfoWindow(
            title: 'Rocket Location',
            snippet: 'Distance: ${viewModel.distanceToRocket?.toStringAsFixed(2)}m',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    

    return Consumer<LocationViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  title: const Text('Rocket Location'),
                  subtitle: Text(
                    viewModel.rocketLocation != null
                        ? 'Lat: ${viewModel.rocketLocation?.latitude} Lon: ${viewModel.rocketLocation?.longitude}${viewModel.distanceToRocket != null ? '\nDistance: ${viewModel.distanceToRocket!.toStringAsFixed(2)}m' : ''}'
                        : 'Rocket location not available',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      viewModel.fetchUserLocation();
                      viewModel.fetchLatestRocketLocation();
                      refreshMapAsync();
                    },
                  )
                ),
              ),
            ),
            Expanded(
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                initialCameraPosition: const CameraPosition(
                  target: LatLng(45.5017, -73.5673), // Defaults to Montreal if no location
                  zoom: 10,
                ),
                markers: markers,
                myLocationEnabled: true, // Show the blue dot on the map
                myLocationButtonEnabled:
                    true, // Show the button to center the map on the current location
              ),
            ),
          ],
        );
      }
    );
  }
}
