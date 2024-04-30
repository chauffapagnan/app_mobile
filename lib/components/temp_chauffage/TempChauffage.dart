import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class TempChauffage extends StatefulWidget {
  const TempChauffage({super.key});

  @override
  State<TempChauffage> createState() => _TempChauffageState();
}

class _TempChauffageState extends State<TempChauffage> {
  bool etat_btn = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.h),
      padding: const EdgeInsets.all(5),
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
        height: 110,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                "Réglage de la temperature",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700
                )
            ),const SizedBox(height: 10,),
           Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 5,
              children: [
                const Text("Température :",
                    style: TextStyle(
                      color: Colors.black,
                    )
                ),
                ToggleButtons2(),
                ElevatedButton(
                    onPressed: () {
                      if (kDebugMode) {
                        print("APPUI sur OK");
                      }
                      createAlbum()
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),

                    ),
                    child: const Text(
                      "OK",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
  Future<http.Response> createAlbum(String temp) {
    return http.post(
      Uri.parse('https://controleur-api.vercel.app/temp_chauffage/$temp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
      }),
    );
  }
}

class ToggleButtons2 extends StatefulWidget {
  int _counter = 0;
  @override
  _ToggleButtons2State createState() => _ToggleButtons2State();
}

class _ToggleButtons2State extends State<ToggleButtons2> {
  List<bool> isSelected = [false, false, false];

  @override
  Widget build(BuildContext context) => ToggleButtons(
    isSelected: isSelected,
    selectedColor: Colors.white,
    color: Colors.black,
    borderRadius: BorderRadius.circular(12),
    fillColor: Colors.lightBlue.shade900,
    children: <Widget>[
      const Icon(Icons.remove),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Text(
          '${widget._counter}',
          style: TextStyle(color: Colors.blue),),
      ),
      Icon(Icons.add),
    ],
    onPressed: (int newIndex) {
      setState(() {
        for (int index = 0; index < isSelected.length; index++) {
          if (index != 1) {
            if (index == newIndex) {
              isSelected[index] = !isSelected[index];
              if (index == 0) {
                if (widget._counter > 0)
                  widget._counter--;
              }
              if (index == 2) {
                if (widget._counter < 100)
                  widget._counter++;
              }
            } else {
              isSelected[index] = false;
            }
          } else {
            isSelected[index] = false;
          }
        }
      });
    },
  );
}


