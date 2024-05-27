import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'Graph.dart';
class EnergieProduite extends StatefulWidget {
  const EnergieProduite({super.key});

  @override
  State<EnergieProduite> createState() => _EnergieProduiteState();
}

class _EnergieProduiteState extends State<EnergieProduite> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.h),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child:  SizedBox(
        width: double.infinity,
        height: 270,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
        padding: EdgeInsets.only(top:15),
          child:Text("Prédiction", style: TextStyle(
            fontSize:20,
            color: Colors.black,
            fontWeight: FontWeight.w700
        ),))
            ),
            SizedBox(height: 20),
            Padding(padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text("Visualiser la prédiction de l'énergie produite en Watt, de la semaine",
                style: TextStyle(color: Colors.black,)),),
            SizedBox(height: 20),
            Center(child : BarChartSample3(),),

          ],
        ),
      ),
    );
  }
}
