import 'package:chauffagecanette/components/energie_produite/EnergieProduite.dart';
import 'package:chauffagecanette/components/etat_chauffage/EtatChauffage.dart';
import 'package:chauffagecanette/components/RoutineOuverture.dart';
import 'package:chauffagecanette/components/temp_chauffage/TempChauffage.dart';
import 'package:chauffagecanette/components/mqtt/MQTTClientWrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:chauffagecanette/components/mqtt/MQTTClientWrapper.dart';
import 'components/energie_produite/Graph.dart';
import 'mqtt/mqtt_client_wrapper.dart';

Future<void> main() async {
  initMqtt();

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
    BarChartSample3.setDatasSem([16.0,11.0,5.0,14.0,12.0,15.0,14.0]);
    return Scaffold(
      backgroundColor: Colors.blue,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Center( child: HomePageText("CHAUFFAGE CANETTE"),),
            expandedHeight: 40.0,
            stretch: false,
            backgroundColor: Colors.blue,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 5.h),
              PaddingListCard(EtatChauffage()),
              PaddingListCard(TempChauffage()),
              PaddingListCard(EnergieProduite()),
              //PaddingListCard(BarChartSample3())
            ]),)
        ],
      )
      /*Center(
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
                  RoutineAllumage(),
                  SizedBox(height: 5.h),
                  EnergieProduite(),

                ],
              ),
            )
          ],
        ),
      ),*/
    );
  }
}

Widget HomePageText(String text,) {
  return Container(
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

Widget PaddingListCard(Widget my_widget) {
  return Container(
    margin: EdgeInsets.only(left: 8, right: 8, top: 20),
    child: my_widget,

  );
}
