import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EtatChauffage extends StatefulWidget {
  const EtatChauffage({super.key});

  @override
  State<EtatChauffage> createState() => _EtatChauffageState();
}

class _EtatChauffageState extends State<EtatChauffage> {
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
        height: 90,
        child: Column(
          children: [
            Center(
              child: Text("Etat du chauffage", style: TextStyle(color: Colors.black,)),
            )
          ],
        ),
      ),
    );
  }
}
