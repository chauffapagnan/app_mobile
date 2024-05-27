import 'dart:convert';
import 'package:chauffagecanette/logic/bloc/temp/temp_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class TempChauffage extends StatefulWidget {
  const TempChauffage({super.key});

  @override
  State<TempChauffage> createState() => _TempChauffageState();
}

class _TempChauffageState extends State<TempChauffage> {
  bool etat_btn = false;
  ToggleButtons2 button=ToggleButtons2();
  double opaqueLoading = 0.0;


  @override
  void initState() {
    super.initState();
    BlocProvider.of<TempBloc>(context).add(OpenAppTempEvent());
  }

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
            const Padding(
              padding: EdgeInsets.only(left:10,top:5),
                child:Text(
                "Réglage de la température",
                style: TextStyle(
                    fontSize:20,
                    color: Colors.black,
                    fontWeight: FontWeight.w700
                )
            )),const SizedBox(height: 5,),
            BlocBuilder<TempBloc, TempState>(
              builder: (context, state) {
              if (state is TempsErrorState) {
    //
              } if (state is TempsSuccesState) {
                button.counter = state.temp;
                debugPrint("${state.temp}");
                opaqueLoading = 0.0;
              }
              return Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 5,
              children: [
                const Padding(
              padding: EdgeInsets.only(left:10),
                child:Text("Température :",
                    style: TextStyle(
                      color: Colors.black,
                    )
                )),
                button,
                ElevatedButton(
                    onPressed: () {

                        opaqueLoading = 1.0;
                        BlocProvider.of<TempBloc>(context)
                            .add(TempButtonClick(id: "22", value: button.counter));

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
                ),Padding(
                  padding: const EdgeInsets.all(0),
                  child: Transform.scale(
                    scaleX: 0.8,
                    scaleY:0.8,
                    child: CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Color.fromRGBO(135, 206, 235, opaqueLoading)),
                    ),
                  ),
                ),
              ],
            );})
          ],
        ),
      ),
    );
  }

}

class ToggleButtons2 extends StatelessWidget {

  double counter;
  late List<bool> isSelected;

  ToggleButtons2({this.counter = 19});

  @override
  Widget build(BuildContext context) {
    this.isSelected = [false, false, false];
    return BlocBuilder<TempBloc, TempState>(
        builder: (context, state) {
          if (state is TempsErrorState) {
            //
          }
          return ToggleButtons(
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
                  '${counter}',
                  style: TextStyle(color: Colors.blue),),
              ),
              Icon(Icons.add),
            ],
            onPressed: (int newIndex) {
              for (int index = 0; index < isSelected.length; index++) {
                if (index != 1) {
                  if (index == newIndex) {
                    isSelected[index] = !isSelected[index];
                    if (index == 0) {
                      if (counter > 0)
                        counter--;
                    }
                    if (index == 2) {
                      if (counter < 100)
                        counter++;
                    }
                  } else {
                    isSelected[index] = false;
                  }
                } else {
                  isSelected[index] = false;
                }
              }
              BlocProvider.of<TempBloc>(context)
                  .add(TempChangeValueEvent());

            },
          );
        });
  }
}


