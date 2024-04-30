import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../../../constants/config.dart';


// connection states for easy identification
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


class MQTTConnect{

  static late MqttServerClient client;

  static MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
  static MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;

      // waiting for the connection, if an error occurs, debugPrint it and disconnect
  static Future<void> connectClient() async {
    try {
      debugPrint('client connecting....');
      connectionState = MqttCurrentConnectionState.CONNECTING;
      await client.connect(mqttUsername, mqttPassword);
    } on Exception catch (e) {
      debugPrint('client exception - $e');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
    }

    // when connected, debugPrint a confirmation, else debugPrint an error
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      connectionState = MqttCurrentConnectionState.CONNECTED;
      debugPrint('client connected');
    } else {
      debugPrint(
          'ERROR client connection failed - disconnecting, status is ${client.connectionStatus}');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
    }
  }



  static void publishMessage(String message, String topic) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    debugPrint('Publishing message "$message" to topic $topic');
    client.publishMessage(mobileTopicSender, MqttQos.exactlyOnce, builder.payload!);
  }

  // callbacks for different events
  static void onSubscribed(String topic) {
    debugPrint('Subscription confirmed for topic $topic');
    subscriptionState = MqttSubscriptionState.SUBSCRIBED;
  }

  static void onDisconnected() {
    debugPrint('OnDisconnected client callback - Client disconnection');
    connectionState = MqttCurrentConnectionState.DISCONNECTED;
  }

  static void onConnected() {
    connectionState = MqttCurrentConnectionState.CONNECTED;
    debugPrint('OnConnected client callback - Client connection was sucessful');
  }

  static void setupMqttClient() {
    client = MqttServerClient.withPort(mqttServerURL, mqttName, mqttServerPort);
    // the next 2 lines are necessary to connect with tls, which is used by HiveMQ Cloud
    client.secure = true;
    client.securityContext = SecurityContext.defaultContext;
    client.keepAlivePeriod = 20;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
  }


  static Future<String> prepareMqttClient() async {
    setupMqttClient();
    await connectClient();
    return "OK";
  }
}