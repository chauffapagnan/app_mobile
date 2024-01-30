import 'package:chauffagecanette/components/EnergieProduite.dart';
import 'package:chauffagecanette/components/etat_chauffage/EtatChauffage.dart';
import 'package:chauffagecanette/components/RoutineAllumage.dart';
import 'package:chauffagecanette/components/RoutineOuverture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';

import 'components/Graph.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_ , child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Chauffage Canette',
          // You can use the library anywhere in the app even in theme
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          home: child,
        );
      },
      child: const MyHomePage(title: 'CHAUFFAGE CANETTE'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20.h),
              padding: EdgeInsets.only(left: 25.w, right: 25.w),
              child: Column(
                children: [
                  HomePageText("CHAUFFAGE SALON"),
                  SizedBox(height: 5.h),
                  EtatChauffage(),
                  SizedBox(height: 5.h),
                  EnergieProduite(),
                  SizedBox(height: 5.h),
                  BarChartSample3()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget HomePageText(String text,) {
  return Container(
    margin: EdgeInsets.only(top: 30.h),
    child: Text(
      text,
      style: TextStyle(
          color: Colors.white,
          fontSize: 30.sp,
          fontWeight: FontWeight.bold
      ),
    ),
  );
}
