import 'package:sensors_plus/sensors_plus.dart';
import 'package:environment_sensors/environment_sensors.dart';

class SensorService {
  // Stream of accelerometer events
  Stream<AccelerometerEvent>? _accelerometerEvents;
  Stream<GyroscopeEvent>? _gyroscopeEvents;
  Stream<MagnetometerEvent>? _magnometerEvents;
  Stream<double>? _pressureEvents;
  Stream<double>? _temperatureEvents;
  final environmentSensors = EnvironmentSensors();


  SensorService() {
    // Initialize the stream
    _accelerometerEvents = accelerometerEventStream();
    _gyroscopeEvents = gyroscopeEventStream();
    _magnometerEvents = magnetometerEventStream();
    _pressureEvents = environmentSensors.pressure;
    _temperatureEvents = environmentSensors.temperature;
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
  Stream<double>? getPressureStream() {
    return _pressureEvents;
  }
  Stream<double>? getTemperatureStream() {
    return _temperatureEvents;
  }
}
