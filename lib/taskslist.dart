import 'package:flutter/material.dart';
import 'package:geotask_mainpage/task.dart';

class TasksListModel extends ChangeNotifier {
  TasksList _tasks = {};

  TasksList get tasks => _tasks;

  // TasksList getTasksList() {
  //   TasksList list = {};

  //   for (var task in _tasks) {
  //     DateTime dateOnly = DateTime(task.dateTime.year, task.dateTime.month, task.dateTime.day);

  //     if (list[dateOnly] == null) {
  //       list[dateOnly] = [];
  //     }

  //     list[task.dateTime]!.add(task);
  //   }

  //   return list;
  // }

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

  // // Map<DateTime, List<Task>> get tasks => _tasks;

  // void addTask(DateTime date, Task task) {
  //   if (_tasks[date] == null) {
  //     _tasks[date] = [];
  //   }

  //   _tasks[date]!.add(task);
  //   notifyListeners();
  // }

  // void setTasksList(TasksList tasksList) {
  //   _tasks = tasksList;
  //   notifyListeners();
  // }

  // void addTasksList(TasksList tasksList) {
  //   _tasks = {
  //     ..._tasks,
  //     ...tasksList,
  //   };
  //   notifyListeners();
  // }

  // void removeTask(DateTime date, Task task) {
  //   if (_tasks[date] != null) {
  //     _tasks[date]!.remove(task);
  //     if (_tasks[date]!.isEmpty) {
  //       _tasks.remove(date);
  //     }
  //     notifyListeners();
  //   }
  // }
}

