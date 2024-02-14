import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geotask_mainpage/components/task.dart';
import 'package:geotask_mainpage/store/taskslist.dart';
import 'package:provider/provider.dart';

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
        body: Consumer<TasksListModel>(
          builder: (context, tasksListModel, child ) {
            var task = tasksListModel.tasks[taskDate]![taskIndex];

            return Column(children: [
              // Text('$id', style: Theme.of(context).textTheme.labelSmall),
              Text(task.title ?? '', style: Theme.of(context).textTheme.titleLarge),
              Text(task.description ?? '',
                  style: Theme.of(context).textTheme.bodyLarge),
            ]);
          }
        ));
  }
}
