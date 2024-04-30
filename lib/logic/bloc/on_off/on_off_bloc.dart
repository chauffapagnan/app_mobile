import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chauffagecanette/mqtt/mqtt_connect.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../../../constants/config.dart';

part 'on_off_event.dart';
part 'on_off_state.dart';


class OnOffBloc extends Bloc<OnOffEvent, OnOffState> {

  OnOffBloc() : super(OnOffInitialState()) {
    on<OnOffEvent>((event, emit1) async {

      void subscribeToTopic(String topicName) {
        debugPrint('Subscribing to the $topicName topic');
        MQTTConnect.client.subscribe(topicName, MqttQos.atMostOnce);

        // debugPrint the message when it is received
        MQTTConnect.client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
          if(c[0].topic==mobileTopicReceiver) {
            final recMess = c[0].payload as MqttPublishMessage;
            var message = MqttPublishPayload.bytesToStringAsString(
                recMess.payload.message);

            debugPrint('YOU GOT A NEW ONOFF :');
            emit(OnOffsSuccesState(onOff: message == "true" ? true : false));
            debugPrint(message);
          }
        });

      }


      void publishMessage(String message) {
        MQTTConnect.publishMessage(message, mobileTopicSender);
      }

      // callbacks for different events
      void onSubscribed(String topic) {
        MQTTConnect.onSubscribed(topic);
      }


      void prepareMqttClient() async {
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
          publishMessage("${event.value == true ? 1 : 0}");
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