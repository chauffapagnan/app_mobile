import 'dart:convert';

import 'package:chauffagecanette/components/energie_produite/EnergieProduite.dart';
import 'package:chauffagecanette/components/etat_chauffage/EtatChauffage.dart';
import 'package:chauffagecanette/components/def_temp_chauffage/TempChauffage.dart';
import 'package:chauffagecanette/components/in_ext_temp/InExtTemperature.dart';
import 'package:chauffagecanette/logic/bloc/on_off/on_off_bloc.dart';
import 'package:chauffagecanette/logic/bloc/temp/temp_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'components/def_sched_chauffage/SchedChauffage.dart';
import 'components/energie_produite/Graph.dart';
import 'mqtt/mqtt_connect.dart';

Future<void> main() async {
  await MQTTConnect.prepareMqttClient();
  await initGraph();
  //initCreneau();
  runApp(const MyApp());
}
Future<void> initGraph() async{
  Response rep=await http.get(
    Uri.parse('https://controleur-api.vercel.app/get_prediction'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }
  );
  debugPrint("reçu : " + rep.body);
  debugPrint("${extraireDoubles(rep.body)}");
  BarChartSample3.setDatasSem(extraireDoubles(rep.body));
}
Future<void> initCreneau() async{
  Response rep=await http.get(
      Uri.parse('https://controleur-api.vercel.app/get_creneau'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }
  );
  debugPrint("bb" + rep.body);
  debugPrint("${extraireDoubles(rep.body)}");
  BarChartSample3.setDatasSem(extraireDoubles(rep.body));
}
List<double> extraireDoubles(String chaine) {
  List<double> resultats = [];

  // Recherche des indices des ':' et des ',' dans la chaîne
  List<int> indices = [];
  for (int i = 0; i < chaine.length; i++) {
    if (chaine[i] == ':' || chaine[i] == ','|| chaine[i] == '}') {
      indices.add(i);
    }
  }

  // Extraction des nombres entre ':' et ','
  for (int i = 0; i < indices.length; i += 2) {
    // Vérification pour éviter le dépassement d'index
    if (i + 1 < indices.length) {
      String sousChaine = chaine.substring(indices[i] + 1, indices[i + 1]).trim();
      resultats.add(double.parse(sousChaine)); // Conversion en double
    }
  }

  return resultats;
  return [20.13,19.82,19.77,18.396,18.586,18.586,20.13];
  }
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> _initializeData() async {

    await MQTTConnect.ensureInitialized();
  }

  @override
  void initState() {
    super.initState();
    _initializeData();

  }
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

    return MultiBlocProvider(
        providers: [

          BlocProvider<OnOffBloc>(
          create: (context) => OnOffBloc(),
          )
        ,
          BlocProvider<TempBloc>(
            create: (context) => TempBloc(),
          ),
      ],
      child: Scaffold(
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
                  //PaddingListCard(InExtTemperature()),
                  PaddingListCard(EtatChauffage()),
                  PaddingListCard(TempChauffage()),
                  PaddingListCard(SchedChauffage()),
                  PaddingListCard(EnergieProduite()),
                  //PaddingListCard(BarChartSample3())
                ]),)
            ],
          )
      ),
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
