import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

final client = MqttServerClient('3f68ce49b7714ea2ac988e755d35fd99.s1.eu.hivemq.cloud', '');

var lastData = "0"; // Variable pour stocker la dernière donnée reçue

Future<int> init() async {
  client.logging(on: true);
  client.setProtocolV311();
  client.keepAlivePeriod = 20;
  client.connectTimeoutPeriod = 2000;

  client.onDisconnected = onDisconnected;
  client.onConnected = onConnected;
  client.onSubscribed = onSubscribed;

  client.onSubscribed = onSubscribed;

  final connMess = MqttConnectMessage()
      .withClientIdentifier('Mqtt_MyClientUniqueId')
      .startClean()
      .withWillQos(MqttQos.atLeastOnce);
  if (kDebugMode) {
    print('Connecting to MQTT broker....');
  }
  client.connectionMessage = connMess;

  try {
    await client.connect('controlleur', 'Controlleur24');
  } on NoConnectionException catch (e) {
    print('Client exception - $e');
    client.disconnect();
  } on SocketException catch (e) {
    print('Socket exception - $e');
    client.disconnect();
  }

  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    print('Connected to MQTT broker');
  } else {
    print('ERROR Connection to MQTT broker failed - disconnecting, status is ${client.connectionStatus}');
    client.disconnect();
    exit(-1);
  }

  const topic = 'controller/chauffage1';
  client.subscribe(topic, MqttQos.atMostOnce);

  client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
    final recMess = c![0].payload as MqttPublishMessage;
    final pt =
    MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    lastData = pt; // Stocker la dernière donnée reçue
    print('Last data received from $topic: $lastData');
  });

  await MqttUtilities.asyncSleep(60);

  print('Disconnecting');
  client.disconnect();
  print('Exiting normally');
  return 0;
}

void onSubscribed(String topic) {
  print('Subscription confirmed for topic $topic');
}

void onDisconnected() {
  print('OnDisconnected client callback - Client disconnection');
  if (client.connectionStatus!.disconnectionOrigin ==
      MqttDisconnectionOrigin.solicited) {
    print('OnDisconnected callback is solicited, this is correct');
  } else {
    print('OnDisconnected callback is unsolicited or none, this is incorrect - exiting');
    exit(-1);
  }
}

void onConnected() {
  print('OnConnected client callback - Client connection was successful');
}
