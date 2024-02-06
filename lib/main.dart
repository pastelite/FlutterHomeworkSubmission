import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
  // var _draggableScrollableSheetController = DraggableScrollableController();

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void _testController() {
    print("test");
    // _draggableScrollableSheetController.animateTo(0.1,
    //     duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _testController,
        tooltip: 'Increment',
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
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          BottomSheet(
            child: Container(
              height: 200,
              color: Colors.red,
              child: const Center(
                child: Text('Hello World'),
              ),
            ),
          )
          // DraggableScrollableSheet(
          //   // snapSizes: [0.1, 0.5],
          //   // snap: true,
          //   // expand: true,
          //   minChildSize: 0.5,
          //   initialChildSize: 0.5,
          //   maxChildSize: 1,
          //   // controller: _draggableScrollableSheetController,
          //   builder: (BuildContext context, ScrollController scrollController) {
          //     return Container(
          //       color: Colors.white,
          //       child: ListView.builder(
          //         controller: scrollController,
          //         itemCount: 25,
          //         itemBuilder: (BuildContext context, int index) {
          //           return ListTile(title: Text('Item $index'));
          //         },
          //       ),
          //     );
          //   },
          // ),
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
  final Widget? child ;
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
              child: Container(
                // color: Colors.white,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
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
                        if ((_heightFactor - widget.snapSizes[i]).abs() < widget.snapDistance) {
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
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                    ),
                  ),
                  widget.child ?? Container()
                ]),
              ),
            ));
      },
    );
  }
}
