import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTClientWrapper {
  late MqttServerClient client;
  Function(String, String)? onMessageReceived;
  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;
  final String host;
  final int port;

  MQTTClientWrapper({
    required this.host,
    required this.port,
  });

  Future<void> prepareMqttClient() async {
    _setupMqttClient();
    await _connectClient();
  }

  Future<void> _connectClient() async {
    try {
      print('Client connecting....');
      connectionState = MqttCurrentConnectionState.CONNECTING;
      await client.connect('finalproject', '123455678fP');
    } on Exception catch (e) {
      print('Client exception - $e');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
    }

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      connectionState = MqttCurrentConnectionState.CONNECTED;
      print('Client connected');
    } else {
      print(
          'ERROR client connection failed - disconnecting, status is ${client.connectionStatus}');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
    }
  }

  void _setupMqttClient() {
    client = MqttServerClient.withPort(host, 'clientId', port);
    client.secure = true;
    client.securityContext = SecurityContext.defaultContext;
    client.keepAlivePeriod = 20;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
  }

  void subscribeToTopic(String topicName, Function(String, String) onMessageReceived) {
    print('Subscribing to the $topicName topic');
    client.subscribe(topicName, MqttQos.atMostOnce);

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      for (var message in messages) {
        final MqttPublishMessage recMess = message.payload as MqttPublishMessage;
        final String receivedTopic = message.topic;
        final String receivedMessage =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        print('Received message: $receivedMessage from topic: $receivedTopic');

        if (receivedTopic == topicName) {
          onMessageReceived(receivedMessage, receivedTopic);
        }
      }
    });
  }


  void _onSubscribed(String topic) {
    print('Subscription confirmed for topic $topic');
    subscriptionState = MqttSubscriptionState.SUBSCRIBED;
  }

  void _onDisconnected() {
    print('OnDisconnected client callback - Client disconnection');
    connectionState = MqttCurrentConnectionState.DISCONNECTED;
  }

  void _onConnected() {
    connectionState = MqttCurrentConnectionState.CONNECTED;
    print('OnConnected client callback - Client connection was successful');
  }

  void disconnectMQTT() {
    try {
      client.disconnect();
    } catch (e) {
      print('Disconnection error: $e');
    }
  }
}

enum MqttCurrentConnectionState {
  IDLE,
  CONNECTING,
  CONNECTED,
  DISCONNECTED,
  ERROR_WHEN_CONNECTING
}

enum MqttSubscriptionState {
  IDLE,
  SUBSCRIBED
}
