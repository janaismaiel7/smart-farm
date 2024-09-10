import 'package:flutter/material.dart';
import 'mqtt_service.dart';

class SoilMoistureScreen extends StatefulWidget {
  @override
  _SoilMoistureActionsScreenState createState() => _SoilMoistureActionsScreenState();
}

class _SoilMoistureActionsScreenState extends State<SoilMoistureScreen> {
  final MQTTClientWrapper _mqttClientWrapper = MQTTClientWrapper(
    host: 'ce19dd80e2624e5cb12598cbcdd77a45.s1.eu.hivemq.cloud',
    port: 8883,
  );

  String _soilMoisture = 'Loading...';

  @override
  void initState() {
    super.initState();
    _setupMqttClient();
  }

  Future<void> _setupMqttClient() async {
    await _mqttClientWrapper.prepareMqttClient();
    _mqttClientWrapper.subscribeToTopic('ESP32/soil', (message, topic) {
      setState(() {
        _soilMoisture = message;
      });
    });
  }

  @override
  void dispose() {
    _mqttClientWrapper.disconnectMQTT();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Soil Moisture Actions'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: _buildReadingCard('Soil Moisture', _soilMoisture, Colors.brown),
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
          mainAxisSize: MainAxisSize.min,
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
