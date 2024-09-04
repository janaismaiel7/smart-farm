import 'package:flutter/material.dart';
import 'mqtt_service.dart'; // Ensure this path matches your file structure

class SoilMoistureActionsScreen extends StatefulWidget {
  @override
  _SoilMoistureActionsScreenState createState() => _SoilMoistureActionsScreenState();
}

class _SoilMoistureActionsScreenState extends State<SoilMoistureActionsScreen> {
  final MqttService _mqttService = MqttService();
  String _soilMoisture = 'Loading...';

  @override
  void initState() {
    super.initState();
    _mqttService.connect((topic, message) {
      if (topic == 'ESP32/soil') {
        setState(() {
          _soilMoisture = message;
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
        title: Text('Soil Moisture Actions'),
        centerTitle: true,
        backgroundColor: Colors.green, // Changed AppBar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Soil Moisture Level: $_soilMoisture',
              style: TextStyle(fontSize: 24, color: Colors.blue), // Changed text color
            ),
          ],
        ),
      ),
    );
  }
}
