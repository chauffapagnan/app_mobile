import 'dart:convert';
import 'package:chauffagecanette/logic/bloc/on_off/on_off_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class EtatChauffage extends StatefulWidget {
  const EtatChauffage({super.key});

  @override
  State<EtatChauffage> createState() => _EtatChauffageState();
}

class _EtatChauffageState extends State<EtatChauffage> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<OnOffBloc>(context).add(OpenAppOnOffEvent());
  }

  bool etat_btn = false;
  double opaqueLoading = 0.0;
  @override
  Widget build(BuildContext context) {
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Center(
              child: Text(
                  "Etat du chauffage",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  )
              ),
            ),
            BlocBuilder<OnOffBloc, OnOffState>(
              builder: (context, state) {
                if (state is OnOffsErrorState) {
                  //
                } if (state is OnOffsSuccesState) {
                  etat_btn = state.onOff;
                  opaqueLoading = 0.0;
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Transform.scale(
                        scaleX: 0.8,
                        scaleY:0.8,
                        child: CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Color.fromRGBO(135, 206, 235, opaqueLoading)),
                        ),
                      ),
                    ),
                    Transform.scale(
                      scaleX: 1.3,
                      scaleY:1.3,
                      child: Switch(
                        // This bool value toggles the switch.
                        value: etat_btn,
                        activeColor: Colors.blue,
                        inactiveTrackColor: Colors.grey.shade400,
                        inactiveThumbColor: Colors.white,
                        onChanged: (bool value) {
                          opaqueLoading = 1.0;
                          BlocProvider.of<OnOffBloc>(context)
                              .add(OnOffSwitchButtonClick(id: "22", value: value));
                        },
                      ),
                    )

                  ],
                );
              },
            ),

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


