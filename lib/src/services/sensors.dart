import 'package:sensors_plus/sensors_plus.dart';

class SensorService {
  // Stream of accelerometer events
  Stream<AccelerometerEvent>? _accelerometerEvents;
  Stream<GyroscopeEvent>? _gyroscopeEvents;
  Stream<MagnetometerEvent>? _magnometerEvents;

  SensorService() {
    // Initialize the stream
    _accelerometerEvents = accelerometerEventStream();
    _gyroscopeEvents = gyroscopeEventStream();
    _magnometerEvents = magnetometerEventStream();
  }

  Stream<AccelerometerEvent>? getAccelerometerStream() {
    return _accelerometerEvents;
  }

  Stream<GyroscopeEvent>? getGyroscopeStream() {
    return _gyroscopeEvents;
  }

  Stream<MagnetometerEvent>? getMagnometerStream() {
    return _magnometerEvents;
  }
}
