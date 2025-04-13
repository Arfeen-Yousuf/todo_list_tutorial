import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:todo_list_tutorial/models.dart/task_model.dart';
import 'package:todo_list_tutorial/services/task_database.dart'; //Import the file

class TasksProviders extends ChangeNotifier {
  //The provider will use database to perform crud operations when user changes the data
  late TaskDatabase _database;

  //Tells if tasks are being fetched from the database
  bool _loading = true;
  bool get loading => _loading;

  //Keep _tasks private
  List<TaskModel> _tasks = [];

  //Provide an immutable list of tasks to the UI
  UnmodifiableListView<TaskModel> get tasks => UnmodifiableListView(_tasks);

  //Add a constructor that loads the tasks
  TasksProviders() {
    _loadTasks();
  }

  //Add this method to load tasks from the database
  void _loadTasks() async {
    _database = TaskDatabase.instance;
    _tasks = await _database.getTasks();
    _loading = false; //Tasks have been fetched

    notifyListeners();
  }

  void addTask(TaskModel task) async {
    _tasks.add(task);
    await _database.insertTask(task); //Add this line

    notifyListeners();
  }

  void removeTaskAt(int index) async {
    _tasks.removeAt(index);
    await _database.deleteTask(_tasks[index].id!); //Add this line

    notifyListeners(); //Notify the UI that a change in state occured
  }

  void upateTask({
    required int taskId,
    String? title,
    String? description,
    bool? isCompleted,
  }) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    final task = _tasks[taskIndex];
    final updatedTask = task.copyWith(
      title: title,
      description: description,
      isCompleted: isCompleted,
    );

    await _database.updateTask(updatedTask); //Add this line
    _tasks[taskIndex] = updatedTask;

    notifyListeners();
  }
}
