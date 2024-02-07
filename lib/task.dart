import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Task {
  final String? title;
  final String? description;
  final DateTime? dateTime;

  Task({this.title, this.description, this.dateTime});
}

typedef TasksList = Map<DateTime, List<Task>>;

class TaskTile extends StatelessWidget {
  final Task task;

  TaskTile({required this.task});

  @override
  Widget build(BuildContext context) {
    // String? formattedTime = task.dateTime?.toLocal().toString();
    var format = DateFormat.Hm();
    String? formattedTime =
        task.dateTime != null ? format.format(task.dateTime!) : null;

    return Container(
        margin: EdgeInsets.only(bottom: 8, left: 8, right: 8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            formattedTime != null
                ? Text(formattedTime,
                    style: Theme.of(context).textTheme.labelLarge)
                : Container(),
            task.title != null
                ? Text(task.title!,
                    style: Theme.of(context).textTheme.titleLarge)
                : Container(),
            task.description != null
                ? Text(task.description!,
                    style: Theme.of(context).textTheme.bodyLarge)
                : Container(),
          ],
        ));
  }
}
