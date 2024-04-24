import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import "database.dart";
import "home_page.dart";
import "car.dart";
import "track.dart";
import "racetime.dart";

void main() async {
  Hive.registerAdapter(CarAdapter());
  Hive.registerAdapter(TrackAdapter());
  Hive.registerAdapter(RaceTimeAdapter());
  await Hive.initFlutter();
  await Hive.openBox(DBNAME);

  // DirtDatabase db = DirtDatabase();
  // db.createDefaultData();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  //hide the 'debug' in the top right of the window
      // title: APP_TITLE,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}





