import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roc_flight/src/model/rocket.dart';
import 'package:roc_flight/src/viewmodel/live_data_view_model.dart';

class LiveDataView extends StatelessWidget {
  const LiveDataView({super.key});

  static const routeName = '/live-data-view';

  @override
  Widget build(BuildContext context) {
    return Consumer<LiveDataViewModel>(
      builder: (context, liveDataViewModel, child) {
        return ListView(
          children: [
            _buildConnectionHeader(liveDataViewModel.isConnectedStream()),
            const SizedBox(height: 16),
            _buildRocketStatusHeader(liveDataViewModel.mockRocketStatus),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
            _buildCurrentAltitudeHeader(liveDataViewModel.altitudeStream()),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
            _buildCurrentAltitudeGPSHeader(liveDataViewModel.altitudeGPSStream()),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
            _buildApogeeHeader(liveDataViewModel.mockApogeeAltitude),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
            _buildCurrentVerticalVelocityHeader(liveDataViewModel.verticalVelocityStream()),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
            _buildMaxVelocityHeader(liveDataViewModel.mockMaxVelocity),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
            _buildCurrentVelocityHeader(liveDataViewModel.velocityStream()),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
            _buildCurrentAccelerationHeader(liveDataViewModel.accelerationStream()),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
            _buildCurrentGyroHeader(liveDataViewModel.gyroscopeStream()),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
            _buildBatteryHeader(liveDataViewModel.batteryStream()),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
            _buildCurrentGPSHeader(liveDataViewModel.coordinatesStream()),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Container _buildBatteryHeader(Stream<int> batteryLevel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Battery level:',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
           StreamBuilder<int>(
                    stream: batteryLevel,
                    builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    if (snapshot.hasData) {
                      int? event = snapshot.data;
                      if (event != null){
                        return Text(
                          '${event} %',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          )
                        );
                      }
                    }
                    return const Text(
                          'No Data',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          )
                        );
                  }
           )
        ],
      ),
    );
  }

   Container _buildCurrentGPSHeader(Stream<Geopoint> coordinatesStream) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'GPS:',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
           StreamBuilder<Geopoint>(
                    stream: coordinatesStream,
                    builder: (BuildContext context, AsyncSnapshot<Geopoint> snapshot) {
                    if (snapshot.hasData) {
                      Geopoint? event = snapshot.data;
                      if (event != null){
                        return Text(
                          'Lat ${event.latitude?.toStringAsFixed(6)}, Lon ${event.longitude?.toStringAsFixed(6)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          )
                        );
                      }
                    }
                    return const Text(
                          'No Data',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          )
                        );
                  }
           )
        ],
      ),
    );
  }

   Container _buildCurrentGyroHeader(Stream<Vector3> gyroscopeStream) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Gyro:',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
           StreamBuilder<Vector3>(
                    stream: gyroscopeStream,
                    builder: (BuildContext context, AsyncSnapshot<Vector3> snapshot) {
                    if (snapshot.hasData) {
                      Vector3? event = snapshot.data;
                      if (event != null){
                        return Text(
                          '(${event.x.toStringAsFixed(1)}, ${event.y.toStringAsFixed(1)}, ${event.z.toStringAsFixed(1)}) °/s',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          )
                        );
                      }
                    }
                    return const Text(
                          'No Data',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          )
                        );
                  }
           )
        ],
      ),
    );
  }

   Container _buildCurrentAccelerationHeader(Stream<Vector3> accelerationStream) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Acceleration:',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
           StreamBuilder<Vector3>(
                    stream: accelerationStream,
                    builder: (BuildContext context, AsyncSnapshot<Vector3> snapshot) {
                    if (snapshot.hasData) {
                      Vector3? event = snapshot.data;
                      if (event != null){
                        return Text(
                          '(${event.x.toStringAsFixed(1)}, ${event.y.toStringAsFixed(1)}, ${event.z.toStringAsFixed(1)}) m/s²',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          )
                        );
                      }
                    }
                    return const Text(
                          'No Data',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          )
                        );
                  }
           )
        ],
      ),
    );
  }

  Container _buildMaxVelocityHeader(double maxVelocity) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Max Velocity:',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$maxVelocity m/s',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

   Container _buildCurrentVelocityHeader(Stream<Vector3> velocityStream) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Velocity:',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
           StreamBuilder<Vector3>(
                    stream: velocityStream,
                    builder: (BuildContext context, AsyncSnapshot<Vector3> snapshot) {
                    if (snapshot.hasData) {
                      Vector3? event = snapshot.data;
                      if (event != null){
                        return Text(
                          '(${event.x.toStringAsFixed(1)}, ${event.y.toStringAsFixed(1)}, ${event.z.toStringAsFixed(1)}) m/s',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          )
                        );
                      }
                    }
                    return const Text(
                          'No Data',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          )
                        );
                  }
           )
        ],
      ),
    );
  }


    Container _buildCurrentVerticalVelocityHeader(Stream<double> verticalVelocityStream) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Vertical Velocity:',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
           StreamBuilder<double>(
                    stream: verticalVelocityStream,
                    builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                    if (snapshot.hasData) {
                      double? event = snapshot.data;
                      if (event != null){
                        return Text(
                          '${event.toStringAsFixed(2)} m/s',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          )
                        );
                      }
                    }
                    return const Text(
                          'No Data',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          )
                        );
                  }
           )
        ],
      ),
    );
  }

  Container _buildApogeeHeader(double apogeeAltitude) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Apogee Altitude:',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$apogeeAltitude m',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  Container _buildCurrentAltitudeGPSHeader(Stream<double> altitudeGPSStream) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Current Altitude GPS:',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
           StreamBuilder<double>(
                    stream: altitudeGPSStream,
                    builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                    if (snapshot.hasData) {
                      double? event = snapshot.data;
                      if (event != null){
                        return Text(
                          '${event.toStringAsFixed(2)} m',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          )
                        );
                      }
                    }
                    return const Text(
                          'No Data',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          )
                        );
                  }
           )
        ],
      ),
    );
  }
  Container _buildCurrentAltitudeHeader(Stream<double> altitudeStream) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Current Altitude:',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
           StreamBuilder<double>(
                    stream: altitudeStream,
                    builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                    if (snapshot.hasData) {
                      double? event = snapshot.data;
                      if (event != null){
                        return Text(
                          '${event.toStringAsFixed(2)} m',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          )
                        );
                      }
                    }
                    return const Text(
                          'No Data',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          )
                        );
                  }
           )
        ],
      ),
    );
  }

  Container _buildRocketStatusHeader(String rocketStatus) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Rocket Status:',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            rocketStatus,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Row _buildConnectionHeader(Stream<bool> isConnectedStream) {
    return Row(
      children: [
        const Expanded(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Live Data',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  const Text(
                    'Connection',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  StreamBuilder<bool>(
                    stream: isConnectedStream,
                    builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.hasData) {
                      bool? event = snapshot.data;
                      if (event != null){
                        return Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: event ? Colors.green : Colors.red,
                              )
                          );
                      }
                    }
                    return Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,)
                            );
                    }
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
