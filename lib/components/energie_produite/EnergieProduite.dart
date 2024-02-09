import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      child: const SizedBox(
        width: double.infinity,
        height: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Center(
              child: Text("Energie produite", style: TextStyle(color: Colors.black,)),
            ),
            SizedBox(height: 20),
            Padding(padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text("Visualiser l'énergie produite de la semaine et la prédiction du jour", style: TextStyle(color: Colors.black,)),),
            SizedBox(height: 20),
            Center(child : BarChartSample3(),),

          ],
        ),
      ),
    );
  }
}
