import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EtatChauffage extends StatefulWidget {
  const EtatChauffage({super.key});

  @override
  State<EtatChauffage> createState() => _EtatChauffageState();
}

class _EtatChauffageState extends State<EtatChauffage> {
  bool etat_btn = true;
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
        height: 110,
        child: Stack(
          children: [
            Positioned(
              top: 12.h,
              left: 270,
              child: SizedBox(
                width: 150,
                height: 10,
                child: Center(
                  child: Switch(
                    // This bool value toggles the switch.
                    value: etat_btn,
                    activeColor: Colors.blue,
                    inactiveTrackColor: Colors.grey.shade400,
                    inactiveThumbColor: Colors.white,
                    onChanged: (bool value) {
                      // This is called when the user toggles the switch.
                      setState(() {
                        etat_btn = !etat_btn;
                      });
                    },
                  ),
                )
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                  child: Text(
                      "Etat du chauffage",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      )
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text("Température définie :",
                          style: TextStyle(
                            color: Colors.black,
                          )
                      ),
                      SizedBox(height: 5.w),
                      ToggleButtons2(),


                    ],
                  ),
                )
              ],
            ),
          ],
        )
      ),
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
      Icon(Icons.remove),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
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