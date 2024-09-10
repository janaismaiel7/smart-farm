import 'package:flutter/material.dart';
import 'mqtt_service.dart';

class FlameSensorActionsScreen extends StatefulWidget {
  @override
  _FlameSensorActionsScreenState createState() => _FlameSensorActionsScreenState();
}

class _FlameSensorActionsScreenState extends State<FlameSensorActionsScreen> {
  final MQTTClientWrapper _mqttClientWrapper = MQTTClientWrapper(
    host: 'ce19dd80e2624e5cb12598cbcdd77a45.s1.eu.hivemq.cloud',
    port: 8883,
  );

  String _flameStatus = 'Loading...';

  @override
  void initState() {
    super.initState();
    _setupMqttClient();
  }

  Future<void> _setupMqttClient() async {
    await _mqttClientWrapper.prepareMqttClient();
    _mqttClientWrapper.subscribeToTopic('ESP32/flameStatus', (message, topic) {
      setState(() {
        _flameStatus = message;
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
        title: Text('Flame Sensor Actions'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: _buildReadingCard('Flame Status', _flameStatus, Colors.red),
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
