import 'package:flutter/material.dart';
import 'package:geotask_mainpage/detail.dart';
import 'package:geotask_mainpage/taskslist.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Task {
  final String? title;
  final String? description;
  final DateTime dateTime;
  final String? location;
  final bool isDone;

  Task({Key? key, this.title, this.description, required this.dateTime, this.location, this.isDone = false});
}

typedef TasksList = Map<DateTime, List<Task>>;

class TaskTile extends StatelessWidget {
  // final int taskIndex;
  // final DateTime taskDate;
  // final int taskIndex;
  final Task task;
  final DateTime taskDate;
  final int taskIndex;

  TaskTile({required this.task, required this.taskDate, required this.taskIndex});

  @override
  Widget build(BuildContext context) {
    // String? formattedTime = task.dateTime?.toLocal().toString();
    var format = DateFormat.Hm();
    String? formattedTime =
        task.dateTime != null ? format.format(task.dateTime!) : null;
    bool isPast = task.dateTime!.isBefore(DateTime.now());

    return Consumer<TasksListModel>(builder: (context, tasksListModel, child) {
      // var task = tasksListModel.tasks[taskIndex]![0];



      return Container(
          margin: EdgeInsets.only(bottom: 8, left: 8, right: 8),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: isPast
                  ? Theme.of(context).primaryColor.withOpacity(0.2)
                  : Theme.of(context).primaryColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailPage(
                        taskDate: taskDate,
                        taskIndex: taskIndex,
                      ),
                    ));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          formattedTime != null
                              ? Text(formattedTime,
                                  style: Theme.of(context).textTheme.labelLarge)
                              : Container(),
                          SizedBox(width: 4),
                          task.location != null
                              ? Icon(Icons.location_on,
                                  size: 16, color: Colors.black)
                              : Container(),
                          task.location != null
                              ? Text(task.location!,
                                  style: Theme.of(context).textTheme.labelLarge)
                              : Container(),
                        ],
                      ),
                      task.title != null
                          ? Text(task.title!,
                              style: Theme.of(context).textTheme.titleLarge)
                          : Container(),
                      task.description != null
                          ? Text(task.description!,
                              style: Theme.of(context).textTheme.bodyLarge)
                          : Container(),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.done),
                onPressed: () {
                  print('Delete task');
                },
              )
            ],
          ));
    });
  }
}
