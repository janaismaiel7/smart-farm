import 'package:flutter/material.dart';
import 'mqtt_service.dart'; // Ensure this path matches your file structure

class DhtReadingsScreen extends StatefulWidget {
  @override
  _DhtReadingsScreenState createState() => _DhtReadingsScreenState();
}

class _DhtReadingsScreenState extends State<DhtReadingsScreen> {
  final MqttService _mqttService = MqttService();
  String _temperature = 'Loading...';
  String _humidity = 'Loading...';

  @override
  void initState() {
    super.initState();
    _mqttService.connect((topic, message) {
      if (topic == 'ESP32/temperature') {
        setState(() {
          _temperature = message;
        });
      } else if (topic == 'ESP32/humidity') {
        setState(() {
          _humidity = message;
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
        title: Text('DHT Readings'),
        centerTitle: true,
        backgroundColor: Colors.green, // Changed AppBar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 5,
              child: ListTile(
                title: Text('Temperature'),
                subtitle: Text(_temperature),
                tileColor: Colors.orange[100], // Background color of the card
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 5,
              child: ListTile(
                title: Text('Humidity'),
                subtitle: Text(_humidity),
                tileColor: Colors.blue[100], // Background color of the card
              ),
            ),
          ],
        ),
      ),
    );
  }
}
