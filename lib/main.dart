import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geotask_mainpage/date.dart';
import 'package:geotask_mainpage/task.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
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
      DateTime.now(): [
        Task(
          title: 'Task 1',
          description: 'Description 1',
          dateTime: DateTime.now(),
          location: 'ICT Mahidol University',
        ),
        Task(
          title: 'Task 2',
          description: 'Description 2',
          dateTime: DateTime.now(),
        ),
        Task(
          description: 'Try no title',
          dateTime: DateTime.now(),
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
    var _tasks = loadTasks();

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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        onPressed: () => {}, // for now
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
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
            child: BottomSheet(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DateHeader(_tasks.keys.elementAt(index)),
                      // Text(
                      //   _tasks.keys.elementAt(index).toString(),
                      //   style: const TextStyle(
                      //     fontSize: 20,
                      //     fontWeight: FontWeight.bold,
                      //   )
                      // ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: _tasks.values.elementAt(index).length,
                        itemBuilder: (BuildContext context, int index2) {
                          return TaskTile(
                              task: _tasks.values.elementAt(index)[index2]);
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BottomSheet extends StatefulWidget {
  const BottomSheet({
    super.key,
    this.minSize = 0.1,
    this.maxSize = 1,
    this.child,
    this.snapSizes = const [0.1, 0.5, 1],
    this.snapDistance = 0.1,
  });

  final double minSize;
  final double maxSize;
  final Widget? child;
  final List<num> snapSizes;
  final num snapDistance;

  @override
  State<BottomSheet> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  double _heightFactor = 0.5;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedFractionallySizedBox(
              duration: Duration(milliseconds: _isDragging ? 0 : 250),
              curve: Curves.easeInOut,
              heightFactor: _heightFactor,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: _heightFactor < 1
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )
                      : BorderRadius.zero,
                  boxShadow: [
                    BoxShadow(
                      color: _heightFactor < 1
                          ? Colors.black.withOpacity(0.2)
                          : Colors.transparent,
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onVerticalDragUpdate: (details) {
                          var change = details.delta.dy / constraints.maxHeight;
                          var factor = (_heightFactor - change);

                          setState(() {
                            _isDragging = true;
                            _heightFactor =
                                factor.clamp(widget.minSize, widget.maxSize);
                          });
                        },
                        onVerticalDragEnd: (details) {
                          // Snap to the nearest value
                          for (int i = 0; i < widget.snapSizes.length; i++) {
                            if ((_heightFactor - widget.snapSizes[i]).abs() <
                                widget.snapDistance) {
                              setState(() {
                                _heightFactor = widget.snapSizes[i].toDouble();
                              });
                            }
                          }

                          setState(() {
                            _isDragging = false;
                          });
                        },
                        child: Container(
                          // margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.all(10),
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                                height: 6,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                        ),
                      ),
                      Expanded(child: widget.child ?? Container()),
                    ]),
              ),
            ));
      },
    );
  }
}
