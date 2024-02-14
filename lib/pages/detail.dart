import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geotask_mainpage/components/task.dart';
import 'package:geotask_mainpage/store/taskslist.dart';
import 'package:geotask_mainpage/components/map.dart';
import 'package:provider/provider.dart';
import 'package:weather_icons/weather_icons.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({Key? key, required this.taskDate, required this.taskIndex})
      : super(key: key);
  final DateTime taskDate;
  final int taskIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Page'),
        ),
        body:
            Consumer<TasksListModel>(builder: (context, tasksListModel, child) {
          var task = tasksListModel.tasks[taskDate]![taskIndex];

          return LayoutBuilder(
            builder: (context,constraint) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: constraint.maxHeight * 0.5,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(task.title ?? '',
                            style: Theme.of(context).textTheme.headlineLarge),
                        Text(task.description ?? '',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraint.maxHeight * 0.2,
                    ),

                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.3),
                      ),
                      child: Column(children: [
                        Text("Weather Forecast", style: Theme.of(context).textTheme.titleMedium ),
                        Row(
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.wb_sunny,
                              size: 50,
                            ),
                            Column(
                              children: [
                                Text("Bangkok", style: Theme.of(context).textTheme.titleMedium),
                                Text("30°C", style: Theme.of(context).textTheme.bodyLarge),
                              ],
                            ),
                            Column(children: [
                              Text("Mostly Sunny", style: Theme.of(context).textTheme.bodySmall),
                              Text("Humidity: 60%", style: Theme.of(context).textTheme.bodySmall),
                              Text("Precipitation: 0%", style: Theme.of(context).textTheme.bodySmall),
                              Text("Wind: 10 km/h", style: Theme.of(context).textTheme.bodySmall),
                            ],)
                          ],
                        ),
                      ],)
                    )
                  ),
                  Expanded(child: StreetMap()),
                  // Expanded(
                  //   child: Container(
                  //     // height: constraint.maxHeight * 0.5,
                  //     child: StreetMap(),
                  //   ),
                  // ),
                ],
              );
              // return Column(children: [
              //   Expanded(
              //     child: Container(
              //       padding: const EdgeInsets.all(16),
              //       child: Column(
              //         children: [
              //           Text(task.title ?? '',
              //               style: Theme.of(context).textTheme.titleLarge),
              //           Text(task.description ?? '',
              //               style: Theme.of(context).textTheme.bodyLarge),
              //         ],
              //       ),
              //     ),
              //   ),
              //   Expanded(child: Container(
                  
              //   )),
              //   Expanded(child: StreetMap())
              // ]);
            }
          );
        }));
  }
}
