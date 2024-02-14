import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geotask_mainpage/components/date.dart';
import 'package:geotask_mainpage/pages/detail.dart';
import 'package:geotask_mainpage/components/task.dart';
import 'package:geotask_mainpage/store/taskslist.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => TasksListModel(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF70AAA7)),
        textTheme: Typography.blackHelsinki,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page Lol'),
    );
  }
}
