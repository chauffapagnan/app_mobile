import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../../../constants/config.dart';

part 'on_off_event.dart';
part 'on_off_state.dart';

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


class OnOffBloc extends Bloc<OnOffEvent, OnOffState> {

  late MqttServerClient client;

  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;

  OnOffBloc() : super(OnOffInitialState()) {
    on<OnOffEvent>((event, emit1) async {

      // waiting for the connection, if an error occurs, debugPrint it and disconnect
      Future<void> connectClient() async {
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


      void subscribeToTopic(String topicName) {
        debugPrint('Subscribing to the $topicName topic');
        client.subscribe(topicName, MqttQos.atMostOnce);

        // debugPrint the message when it is received
        client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
          final recMess = c[0].payload as MqttPublishMessage;
          var message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

          debugPrint('YOU GOT A NEW MESSAGE:');
          emit(OnOffsSuccesState(onOff: message == "true" ? true : false ));
          debugPrint(message);
        });
      }

      void publishMessage(String message) {
        final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
        builder.addString(message);

        debugPrint('Publishing message "$message" to topic $mobileTopicSender');
        client.publishMessage(mobileTopicSender, MqttQos.exactlyOnce, builder.payload!);
      }

      // callbacks for different events
      void onSubscribed(String topic) {
        debugPrint('Subscription confirmed for topic $topic');
        subscriptionState = MqttSubscriptionState.SUBSCRIBED;
      }

      void onDisconnected() {
        debugPrint('OnDisconnected client callback - Client disconnection');
        connectionState = MqttCurrentConnectionState.DISCONNECTED;
      }

      void onConnected() {
        connectionState = MqttCurrentConnectionState.CONNECTED;
        debugPrint('OnConnected client callback - Client connection was sucessful');
      }

      void setupMqttClient() {
        client = MqttServerClient.withPort(mqttServerURL, mqttName, mqttServerPort);
        // the next 2 lines are necessary to connect with tls, which is used by HiveMQ Cloud
        client.secure = true;
        client.securityContext = SecurityContext.defaultContext;
        client.keepAlivePeriod = 20;
        client.onDisconnected = onDisconnected;
        client.onConnected = onConnected;
        client.onSubscribed = onSubscribed;
      }


      void prepareMqttClient() async {
        setupMqttClient();
        await connectClient();
        subscribeToTopic(mobileTopicReceiver);
      }


      if(event is OpenAppOnOffEvent) { // A l'initialisation de la fenêtre
        prepareMqttClient();
      }

      if(event is OnOffSwitchButtonClick) {
        emit1(LoadingOnOffsState());// on click of the switch button
        try {
          // pushTopic
          debugPrint('VALEUR ON OFF = ${event.value}');
          publishMessage("${event.value}");
          emit1(OnOffsSuccesState(onOff: event.value));// on click of the switch button
        } catch (e) {
          emit1(const OnOffsErrorState(
              message: "Une erreur est survenu lors du switch"
          ));
        }
      }
    });


  }



  @override
  Future<void> close() {
    return super.close();
  }


}