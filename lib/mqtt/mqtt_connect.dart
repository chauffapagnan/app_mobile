import 'dart:async';
import 'dart:io';

import 'package:chauffagecanette/logic/bloc/on_off/on_off_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../../../constants/config.dart';
import '../logic/bloc/temp/temp_bloc.dart';

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

class MQTTConnect {
  static late MqttServerClient client;
  static MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
  static MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;
  static Completer<void> _initializationCompleter = Completer<void>();
  static Completer<void> _initializationCompleterONOFF = Completer<void>();
  static Completer<void> _initializationCompleterTEMP = Completer<void>();
  static bool connected=false;
  static Future<void> connectClient() async {
    try {
      debugPrint('client connecting....');
      connectionState = MqttCurrentConnectionState.CONNECTING;
      await client.connect(mqttUsername, mqttPassword);
      debugPrint("4");
    } on Exception catch (e) {
      debugPrint('client exception - $e');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
    }

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      connectionState = MqttCurrentConnectionState.CONNECTED;
      if (!_initializationCompleter.isCompleted) {
        _initializationCompleter.complete();
      }
      debugPrint('client connected');
    } else {
      debugPrint(
          'ERROR client connection failed - disconnecting, status is ${client.connectionStatus}');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
    }
    connected=true;

  }

  static Future<void> publishMessage(String message, String topic) async {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    debugPrint('Publishing message "$message" to topic $topic');
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

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
    debugPrint('OnConnected client callback - Client connection was successful');
  }

  static void setupMqttClient() {
    client = MqttServerClient.withPort(mqttServerURL, mqttName, mqttServerPort);
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

  static Future<void> initializeONOFF() async {
    if (!_initializationCompleterONOFF.isCompleted) {
      _initializationCompleterONOFF.complete();
    }
  }
  static Future<void> initializeTEMP() async {
    if (!_initializationCompleterTEMP.isCompleted) {
      _initializationCompleterTEMP.complete();
    }
  }
  static Future<void> ensureInitialized({Duration timeout = const Duration(seconds: 40)}) async {
    await _initializationCompleter.future.timeout(timeout, onTimeout: () {
      if (!_initializationCompleter.isCompleted) {
        _initializationCompleter.completeError(TimeoutException("Initialization timed out"));
      }
    });
    /*await _initializationCompleterONOFF.future.timeout(timeout, onTimeout: () {
      if (!_initializationCompleterONOFF.isCompleted) {
        _initializationCompleterONOFF.completeError(TimeoutException("Initialization timed out"));
      }
    });
    await _initializationCompleterTEMP.future.timeout(timeout, onTimeout: () {
      if (!_initializationCompleterTEMP.isCompleted) {
        _initializationCompleterTEMP.completeError(TimeoutException("Initialization timed out"));
      }
    });*/
  }
}
