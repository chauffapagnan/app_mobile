import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chauffagecanette/mqtt/mqtt_connect.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../../../constants/config.dart';

part 'temp_event.dart';
part 'temp_state.dart';


class TempBloc extends Bloc<TempEvent, TempState> {

  TempBloc() : super(TempInitialState()) {
    on<TempEvent>((event, emit1) async {


      void subscribeToTopic(String topicName) {
        MQTTConnect.ensureInitialized();
        debugPrint('Subscribing to the $topicName topic');
        MQTTConnect.client.subscribe(topicName, MqttQos.atMostOnce);
        MQTTConnect.initializeTEMP();
        // debugPrint the message when it is received
        MQTTConnect.client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
          if(c[0].topic==mobileTempReceiver) {
            final recMess = c[0].payload as MqttPublishMessage;
            var message = MqttPublishPayload.bytesToStringAsString(
                recMess.payload.message);


            debugPrint('YOU GOT A NEW TEMP :');
            emit(TempsSuccesState(temp: double.parse(message))); //Attention très Attention
            debugPrint(message);
          }
        });
      }

      void publishMessage(String message) {
        MQTTConnect.publishMessage(message, mobileTempSender);
      }

      // callbacks for different events
      void onSubscribed(String topic) {
        MQTTConnect.onSubscribed(topic);
      }

      void prepareMqttClient() async {
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