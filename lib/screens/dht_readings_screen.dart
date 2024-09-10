import 'package:flutter/material.dart';
import 'mqtt_service.dart';

class DhtReadingsScreen extends StatefulWidget {
  @override
  _DhtReadingsScreenState createState() => _DhtReadingsScreenState();
}

class _DhtReadingsScreenState extends State<DhtReadingsScreen> {
  final MQTTClientWrapper _mqttClientWrapper = MQTTClientWrapper(
    host: 'ce19dd80e2624e5cb12598cbcdd77a45.s1.eu.hivemq.cloud',
    port: 8883,
  );

  String _temperature = 'Loading...';
  String _humidity = 'Loading...';

  @override
  void initState() {
    super.initState();
    _setupMqttClient();
  }

  Future<void> _setupMqttClient() async {
    await _mqttClientWrapper.prepareMqttClient();

    _mqttClientWrapper.subscribeToTopic('ESP32/temperature', (message, topic) {
      setState(() {
        _temperature = message;
      });
    });

    _mqttClientWrapper.subscribeToTopic('ESP32/humidity', (message, topic) {
      setState(() {
        _humidity = message;
      });
    });
  }

  @override
  void dispose() {
    _mqttClientWrapper.disconnectMQTT(); // Disconnect when the screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DHT Readings'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildReadingCard('Temperature', _temperature, Colors.orange),
            SizedBox(height: 16),
            _buildReadingCard('Humidity', _humidity, Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingCard(String title, String value, Color color) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
