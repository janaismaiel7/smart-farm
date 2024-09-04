import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  late MqttServerClient client;

  MqttService() {
    client = MqttServerClient('844e7aeba1714307a9f7ff556dd377a0.s1.eu.hivemq.cloud', '');
    client.port = 8883; // Standard port for MQTT over TLS/SSL
    client.secure = true; // Enable SSL/TLS
    client.logging(on: true);
    client.keepAlivePeriod = 20;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .startClean()
        .withWillQos(MqttQos.atMostOnce)
        .authenticateAs('finalproject', '123455678fP');
    client.connectionMessage = connMessage;
  }

  Future<void> connect(Function(String topic, String message) onMessage) async {
    try {
      await client.connect();
      client.subscribe('ESP32/soil', MqttQos.atMostOnce);
      client.subscribe('ESP32/temperature', MqttQos.atMostOnce);
      client.subscribe('ESP32/humidity', MqttQos.atMostOnce);
      client.subscribe('ESP32/actions', MqttQos.atMostOnce);

      client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        onMessage(c[0].topic, payload);
      });
    } catch (e) {
      print('Connection failed: $e');
    }
  }

  void disconnect() {
    client.disconnect();
  }

  void onConnected() {
    print('Connected');
  }

  void onDisconnected() {
    print('Disconnected');
  }

  void onSubscribed(String topic) {
    print('Subscribed to $topic');
  }

  void pong() {
    print('Ping response received');
  }
}
