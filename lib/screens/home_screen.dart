import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNavigationCard(
              context,
              'DHT Readings',
              'View temperature and humidity readings',
              Icons.thermostat_outlined,
              '/dht',
            ),
            SizedBox(height: 16),
            _buildNavigationCard(
              context,
              'Soil Moisture Actions',
              'Manage soil moisture levels',
              Icons.grass,
              '/soil',
            ),
            SizedBox(height: 16),
            _buildNavigationCard(
              context,
              'Flame Sensor Actions',
              'Monitor and manage flame sensor data',
              Icons.local_fire_department,
              '/flame',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationCard(
      BuildContext context,
      String title,
      String subtitle,
      IconData icon,
      String route,
      ) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.teal),
        onTap: () {
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }
}
