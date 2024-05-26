import 'dart:convert';
import 'package:chauffagecanette/logic/bloc/temp/temp_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';


class SchedChauffage extends StatefulWidget {
  const SchedChauffage({super.key});

  @override
  State<SchedChauffage> createState() => _SchedChauffageState();
}

class _SchedChauffageState extends State<SchedChauffage> {
  bool etat_btn = false;

  final GlobalKey<_ToggleButtons2State> hour1Key = GlobalKey<_ToggleButtons2State>();
  final GlobalKey<_ToggleButtons2State> minute1Key = GlobalKey<_ToggleButtons2State>();
  final GlobalKey<_ToggleButtons2State> hour2Key = GlobalKey<_ToggleButtons2State>();
  final GlobalKey<_ToggleButtons2State> minute2Key = GlobalKey<_ToggleButtons2State>();

  double opaqueLoading = 0.0;

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
        height: 220.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
                padding: EdgeInsets.only(left:10,top:5),
                child: Text(
                  "Créneau d'allumage",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w700
                  ),
                )),
            const SizedBox(height: 10),
            Center(
              child: Column(
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 5,
                    children: [
                      ToggleButtons2(key: hour1Key, max: 24),
                      const Text(
                          ':',
                          style: TextStyle(fontSize: 30, color: Colors.blue)
                      ),
                      ToggleButtons2(key: minute1Key, max: 60),
                      const Text(
                          '-',
                          style: TextStyle(fontSize: 30, color: Colors.blue)
                      ),
                      ToggleButtons2(key: hour2Key, max: 24),
                      const Text(
                          ':',
                          style: TextStyle(fontSize: 30, color: Colors.blue)
                      ),
                      ToggleButtons2(key: minute2Key, max: 60),
                    ],
                  ),
                  const SizedBox(height: 10), // Adding space between wraps
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            opaqueLoading = 1.0;
                          });
                          debugPrint("${hour1Key.currentState?.getCounter()}:${minute1Key.currentState?.getCounter()}-${hour2Key.currentState?.getCounter()}:${minute2Key.currentState?.getCounter()}");
                          http.Response rep=await sendCreneau("${hour1Key.currentState?.getCounter()}:${minute1Key.currentState?.getCounter()}-${hour2Key.currentState?.getCounter()}:${minute2Key.currentState?.getCounter()}");
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Modification effectuée"),
                          ));
                          setState(() {
                            opaqueLoading = 0.0;
                          });
                          },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(140, 25),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        child: const Text(
                          "OK",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 120.h,
                        child: Transform.scale(
                          scaleX: 0.8,
                          scaleY: 0.8,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromRGBO(135, 206, 235, opaqueLoading),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<http.Response> sendCreneau(String creneau) {
    return http.post(
      Uri.parse('https://controleur-api.vercel.app/creneau/$creneau'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{}),
    );
  }
}



class ToggleButtons2 extends StatefulWidget {
  final int max;

  ToggleButtons2({
    Key? key,
    this.max = 23,
  }) : super(key: key);


  @override
  _ToggleButtons2State createState() => _ToggleButtons2State();
}

class _ToggleButtons2State extends State<ToggleButtons2> {
  late int counter;
  late List<bool> isSelected;

  @override
  void initState() {
    super.initState();
    counter = 0;
    isSelected = [false, false, false];
  }

  // Ajouter cette méthode
  int getCounter() {
    return counter;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ToggleButton(
          icon: Icons.add,
          isSelected: isSelected[2],
          onPressed: () {
            setState(() {
              int incr = (widget.max == 24 ? 1 : 10);
              if (counter + incr < widget.max) counter = counter + incr;
              isSelected[2] = !isSelected[2];
              isSelected[0] = false;
            });
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          child: Text(
            '$counter',
            style: TextStyle(fontSize: 30, color: Colors.blue),
          ),
        ),
        ToggleButton(
          icon: Icons.remove,
          isSelected: isSelected[0],
          onPressed: () {
            setState(() {
              int decr = (widget.max == 24 ? 1 : 10);
              if (counter - decr > -1) counter = counter - decr;
              isSelected[0] = !isSelected[0];
              isSelected[2] = false;
            });
          },
        ),
      ],
    );
  }
}



class ToggleButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onPressed;

  ToggleButton({
    required this.icon,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(

      style: ElevatedButton.styleFrom(
        fixedSize: Size(70, 15),
        backgroundColor: isSelected ? Colors.lightBlue.shade900 : Colors.white54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onPressed,
      child: Icon(icon, color: isSelected ? Colors.white : Colors.black),
    );
  }
}

// Assurez-vous de définir et d'importer les classes TempBloc, TempState, TempChangeValueEvent, et TempsErrorState appropriées.



