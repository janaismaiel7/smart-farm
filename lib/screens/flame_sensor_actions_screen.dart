import 'package:flutter/material.dart';
import 'mqtt_service.dart'; // Ensure this path matches your file structure

class FlameSensorActionsScreen extends StatefulWidget {
  @override
  _FlameSensorActionsScreenState createState() => _FlameSensorActionsScreenState();
}

class _FlameSensorActionsScreenState extends State<FlameSensorActionsScreen> {
  final MqttService _mqttService = MqttService();
  String _flameReading = 'Loading...';

  @override
  void initState() {
    super.initState();
    _mqttService.connect((topic, message) {
      if (topic == 'ESP32/flame') {
        setState(() {
          _flameReading = message;
        });
      }
    });
  }

  @override
  void dispose() {
    _mqttService.disconnect(); // Disconnect when the screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flame Sensor Actions'),
        centerTitle: true,
        backgroundColor: Colors.green, // Changed AppBar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Flame Reading: $_flameReading',
              style: TextStyle(fontSize: 24, color: Colors.red), // Changed text color
            ),
          ],
        ),
      ),
    );
  }
}
