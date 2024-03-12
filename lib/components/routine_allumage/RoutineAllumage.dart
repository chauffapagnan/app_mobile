import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoutineAllumage extends StatefulWidget {
  const RoutineAllumage({super.key});

  @override
  State<RoutineAllumage> createState() => _RoutineAllumageState();
}

class _RoutineAllumageState extends State<RoutineAllumage> {
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
        height: 190,
        child: Column(
          children: [
            const Center(
              child: Text(
                  "Routines d'allumage",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  )
              ),
            ),
            Center(
              child: Row(
                  children: [
                    const Text("Température définie :",
                        style: TextStyle(
                            color: Colors.black,
                        )
                    ),
                    SizedBox(height: 5.w),
                    TextModifier(),


                  ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
class TextModifier extends StatefulWidget {
  @override
  _TextModifierState createState() => _TextModifierState();
}

class _TextModifierState extends State<TextModifier> {
  String textValue = '40°C'; // Valeur initiale du texte

  void setTemp(String newText) {
    setState(() {
      textValue = newText; // Modification de la valeur du texte
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          textValue, // Affichage du texte avec la valeur actuelle
          style: TextStyle(fontSize: 12.0,color: Colors.black),
        ),
        SizedBox(height: 20),
        // Vous pouvez appeler setText où vous le souhaitez dans votre application
        // par exemple, setText('Nouveau texte');
      ],
    );
  }
}