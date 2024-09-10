import 'package:flutter/material.dart';
import 'mqtt_service.dart';
import 'home_screen.dart'; // Import the Home Screen here
import 'package:mqtt_client/mqtt_client.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final MQTTClientWrapper _mqttClientWrapper = MQTTClientWrapper(
    host: 'ce19dd80e2624e5cb12598cbcdd77a45.s1.eu.hivemq.cloud',
    port: 8883,
  );

  bool _isLoading = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator() // Show loader while logging in
                : ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                  _errorMessage = '';
                });
                bool success = await _login();
                setState(() {
                  _isLoading = false;
                });

                if (success) {
                  // Navigate to Home Screen on successful login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen()),
                  );
                } else {
                  setState(() {
                    _errorMessage =
                    'Login failed. Please check your credentials.';
                  });
                }
              },
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                foregroundColor: Colors.white, // Text color
              ),
            ),
            SizedBox(height: 16),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  Future<bool> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      // Set up MQTT Client with the given host and port
      await _mqttClientWrapper.prepareMqttClient();

      // Connect using provided credentials
      await _mqttClientWrapper.client.connect(email, password);

      // Check if the connection was successful
      if (_mqttClientWrapper.client.connectionStatus?.state == MqttConnectionState.connected) {
        return true; // Successful login
      } else {
        print('Login failed. Connection Status: ${_mqttClientWrapper.client.connectionStatus?.state}');
        return false; // Failed login
      }
    } catch (e) {
      print('Login error: $e');
      return false; // Failed login
    }
  }

}
