import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geotask_mainpage/components/date.dart';
import 'package:geotask_mainpage/main.dart';
import 'package:geotask_mainpage/components/task.dart';
import 'package:geotask_mainpage/store/taskslist.dart';
import 'package:geotask_mainpage/components/bottom_sheet.dart' as componentBottomSheet;
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  num _heightFactor = 0.5;

  void _incrementCounter() {
    print("increment");
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  TasksList loadTasks() {
    // final Map<DateTime,
    final TasksList tasks = {
      DateTime.now().add(const Duration(days: -1)): [
        Task(
          title: 'Passed Task',
          description: 'Task Description',
          dateTime: DateTime.now().add(const Duration(days: -1)),
        ),
      ],
      DateTime.now(): [
        Task(
          title: 'Task 1',
          description: 'Description 1',
          dateTime: DateTime.now().add(const Duration(hours: 1)),
          location: 'ICT Mahidol University',
        ),
        Task(
          title: 'Task 2',
          description: 'Description 2',
          dateTime: DateTime.now().add(const Duration(hours: 2)),
        ),
        Task(
          description: 'Try no title',
          dateTime: DateTime.now().add(const Duration(hours: 3)),
        ),
      ],
      DateTime.now().add(const Duration(days: 1)): [
        Task(
          title: 'Task 3',
          description: 'Description 3',
          dateTime: DateTime.now().add(const Duration(days: 1)),
        ),
      ],
    };

    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TasksListModel>(context, listen: false);
    provider.addTasksList(loadTasks());
    // var _tasks = loadTasks();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(
              right: 10,
            ),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  _incrementCounter();
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Consumer<TasksListModel>(builder: (a, b, c) {
        return FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          onPressed: () => {
            b.addTask(
              Task(
                title: 'Task 4',
                description: 'Description 4',
                dateTime: DateTime.now().add(const Duration(days: 2)),
              ),
            )
          }, // for now
          tooltip: 'Add Task',
          child: const Icon(Icons.add),
        );
      }),
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(51.509364, -0.128928),
              initialZoom: 3.2,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
            ],
          ),
          SafeArea(
            child: componentBottomSheet.BottomSheet(
              child: Consumer<TasksListModel>(
                  builder: (context, tasksModel, child) {
                // tasksModel.addTasksList(loadTasks());
                var tasks = tasksModel.tasks;

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    print(tasks.values.elementAt(index));
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DateHeader(tasks.keys.elementAt(index)),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: tasks.values.elementAt(index).length,
                          itemBuilder: (BuildContext context, int index2) {
                            return TaskTile(
                              task: tasks.values.elementAt(index)[index2],
                              taskDate: tasks.keys.elementAt(index),
                              taskIndex: index2,
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
