import 'dart:convert';
import 'package:chauffagecanette/logic/bloc/on_off/on_off_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class InExtTemperature extends StatelessWidget {


  double temperature_in = 0.0;
  double temperature_ext = 0.0;
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<OnOffBloc>(context).add(OpenAppOnOffEvent());

    return Container(
      margin: EdgeInsets.only(top: 30.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
          BlocBuilder<OnOffBloc, OnOffState>(
            builder: (context, state) {
    if (state is OnOffsErrorState) {
    //
    } if (state is OnOffsSuccesState) {

    }
    return
    Center(
    child: Text(
    "Températures intérieur du chauffage : ${temperature_in}",
    style: const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold
    )
    ),
    );
    },),
                          BlocBuilder<OnOffBloc, OnOffState>(
    builder: (context, state) {
    if (state is OnOffsErrorState) {
    //
    } if (state is OnOffsSuccesState) {

    }
    return
                    Center(
                      child: Text(
                          "Températures extérieur du chauffage : ${temperature_ext}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          )
                      ),
                    );}
                          )

                  ],
                )
      ),

      );

  }
  Future<http.Response> createAlbum(String state) {
    return http.post(
      Uri.parse('https://controleur-api.vercel.app/etat_chauffage/$state'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
      }),
    );
  }
}


