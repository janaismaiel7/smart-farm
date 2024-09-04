import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/dht_readings_screen.dart';
import 'screens/soil_moisture_actions_screen.dart';
import 'screens/flame_sensor_actions_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Farm App',
      theme: ThemeData(
        primarySwatch: Colors.green, // Changed primary color to green
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false, // Remove the debug banner
      routes: {
        '/home': (context) => HomeScreen(),
        '/dht': (context) => DhtReadingsScreen(),
        '/soil': (context) => SoilMoistureActionsScreen(),
        '/flame': (context) => FlameSensorActionsScreen(),
      },
    );
  }
}



