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
            _buildConnectionHeader(liveDataViewModel),
            const SizedBox(height: 16),
            _buildRocketStatusHeader(liveDataViewModel),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
            _buildCurrentAltitudeHeader(liveDataViewModel),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
            _buildApogeeHeader(liveDataViewModel),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
            _buildCurrentVelocityHeader(liveDataViewModel),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
            _buildMaxVelocityHeader(liveDataViewModel),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
            _buildCurrentAccelerationHeader(liveDataViewModel),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
            _buildMaxAccelerationHeader(liveDataViewModel),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
            _buildCurrentRollHeader(liveDataViewModel),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
            _buildMaxRollHeader(liveDataViewModel),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
            _buildBatteryHeader(liveDataViewModel),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Container _buildBatteryHeader(LiveDataViewModel liveDataViewModel) {
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
            '${liveDataViewModel.mockMaxRollRate} %',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildMaxRollHeader(LiveDataViewModel liveDataViewModel) {
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
            '${liveDataViewModel.mockMaxRollRate} °/s',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildCurrentRollHeader(LiveDataViewModel liveDataViewModel) {
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
            '${liveDataViewModel.mockCurrentRollRate} °/s',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildMaxAccelerationHeader(LiveDataViewModel liveDataViewModel) {
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
            '${liveDataViewModel.mockMaxAcceleration} m/s²',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildCurrentAccelerationHeader(LiveDataViewModel liveDataViewModel) {
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
            '${liveDataViewModel.mockCurrentAcceleration} m/s²',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildMaxVelocityHeader(LiveDataViewModel liveDataViewModel) {
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
            '${liveDataViewModel.mockMaxVelocity} m/s',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildCurrentVelocityHeader(LiveDataViewModel liveDataViewModel) {
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
            '${liveDataViewModel.mockCurrentVelocity} m/s',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildApogeeHeader(LiveDataViewModel liveDataViewModel) {
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
            '${liveDataViewModel.mockApogeeAltitude} m',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildCurrentAltitudeHeader(LiveDataViewModel liveDataViewModel) {
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
            '${liveDataViewModel.mockCurrentAltitude} m',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildRocketStatusHeader(LiveDataViewModel liveDataViewModel) {
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
            liveDataViewModel.mockRocketStatus,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Row _buildConnectionHeader(LiveDataViewModel liveDataViewModel) {
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
                      color: liveDataViewModel.mockIsConnected ? Colors.green : Colors.red,
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
