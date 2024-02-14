import 'package:flutter/material.dart';
import 'package:geotask_mainpage/components/task.dart';

class TasksListModel extends ChangeNotifier {
  TasksList _tasks = {};

  TasksList get tasks => _tasks;

  void addTask(Task task) {
    DateTime dateOnly = DateTime(task.dateTime.year, task.dateTime.month, task.dateTime.day);

    if (_tasks[dateOnly] == null) {
      _tasks[dateOnly] = [];
    }

    _tasks[dateOnly]!.add(task);
    
    print('Adding task: $task to date: $dateOnly');
    notifyListeners();
  }
  
  /// Remove a task from the list, please make sure that the task is in the list before calling this method
  void removeTask(Task task) {
    DateTime dateOnly = DateTime(task.dateTime.year, task.dateTime.month, task.dateTime.day);

    if (_tasks[dateOnly] != null) {
      _tasks[dateOnly]!.remove(task);
      if (_tasks[dateOnly]!.isEmpty) {
        _tasks.remove(dateOnly);
      }
      notifyListeners();
    }
  }

  void addTasksList(TasksList tasksList) {
    for (var date in tasksList.keys) {
      for (var task in tasksList[date]!) {
        addTask(task);
      }
    }
  }
}

