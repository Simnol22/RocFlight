import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
            _buildConnectionHeader(liveDataViewModel.mockIsConnected),
            const SizedBox(height: 16),
            _buildRocketStatusHeader(liveDataViewModel.mockRocketStatus),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
            _buildCurrentAltitudeHeader(liveDataViewModel.mockCurrentAltitude),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
            _buildApogeeHeader(liveDataViewModel.mockApogeeAltitude),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
            _buildCurrentVelocityHeader(liveDataViewModel.mockCurrentVelocity),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
            _buildMaxVelocityHeader(liveDataViewModel.mockMaxVelocity),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
            _buildCurrentAccelerationHeader(liveDataViewModel.mockCurrentAcceleration),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
            _buildMaxAccelerationHeader(liveDataViewModel.mockMaxAcceleration),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
            _buildCurrentRollHeader(liveDataViewModel.mockCurrentRollRate),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
            _buildMaxRollHeader(liveDataViewModel.mockMaxRollRate),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
            _buildBatteryHeader(liveDataViewModel.mockBatteryLevel),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Container _buildBatteryHeader(int batteryLevel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Rocket Battery Level:',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$batteryLevel %',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildMaxRollHeader(double maxRollRate) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Max Roll Rate:',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$maxRollRate °/s',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildCurrentRollHeader(double currentRollRate) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Current Roll Rate:',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$currentRollRate °/s',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildMaxAccelerationHeader(double maxAcceleration) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Max Acceleration:',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$maxAcceleration m/s²',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildCurrentAccelerationHeader(double currentAcceleration) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Current Acceleration:',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$currentAcceleration m/s²',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
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

  Container _buildCurrentVelocityHeader(double currentVelocity) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Current Velocity:',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$currentVelocity m/s',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
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

  Container _buildCurrentAltitudeHeader(double currentAltitude) {
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
          Text(
            '$currentAltitude m',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
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

  Row _buildConnectionHeader(bool isConnected) {
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
              padding: const EdgeInsets.all(16.0),
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
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isConnected ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
