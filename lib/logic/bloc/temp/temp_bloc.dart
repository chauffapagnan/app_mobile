import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../../../constants/config.dart';

part 'temp_event.dart';
part 'temp_state.dart';

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


class TempBloc extends Bloc<TempEvent, TempState> {

  late MqttServerClient client;

  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;

  TempBloc() : super(TempInitialState()) {
    on<TempEvent>((event, emit1) async {

      // waiting for the connection, if an error occurs, debugPrint it and disconnect


      void subscribeToTopic(String topicName) {
        debugPrint('Subscribing to the $topicName topic');
        client.subscribe(topicName, MqttQos.atMostOnce);

        // debugPrint the message when it is received
        client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
          final recMess = c[0].payload as MqttPublishMessage;
          var message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

          debugPrint('YOU GOT A NEW TEMP:');
          emit(TempsSuccesState(temp: double.parse(message) ));//Attention
          debugPrint(message);
        });
      }

      void publishMessage(String message) {
        final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
        builder.addString(message);

        debugPrint('Publishing message "$message" to topic $mobileTempSender');
        client.publishMessage(mobileTempSender, MqttQos.exactlyOnce, builder.payload!);
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
        //await connectClient();
        subscribeToTopic(mobileTempReceiver);
      }


      if(event is OpenAppTempEvent) { // A l'initialisation de la fenêtre
        prepareMqttClient();
      }

      if(event is TempChangeValueEvent) { // A l'initialisation de la fenêtre
        var now = DateTime.now();

        emit1(TempsChangeValueState(
            dateNow: now.toString()
        ));
      }

      if(event is TempButtonClick) {
        emit1(LoadingTempsState());// on click of the switch button
        try {
          // pushTopic
          debugPrint('VALEUR TEMP = ${event.value}');
          publishMessage("${event.value}");
        } catch (e) {
          emit1(const TempsErrorState(
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