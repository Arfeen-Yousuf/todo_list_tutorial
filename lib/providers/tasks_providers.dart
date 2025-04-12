import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:todo_list_tutorial/models.dart/task_model.dart';

class TasksProviders extends ChangeNotifier {
  //Keep _tasks private
  final List<TaskModel> _tasks = [
    TaskModel(id: 81, title: 'Maths Homework', description: 'Linear algebra'),
    TaskModel(id: 45, title: 'Buy grocery', isCompleted: true),
  ];
  //Provide an immutable list of tasks to the UI
  UnmodifiableListView<TaskModel> get tasks => UnmodifiableListView(_tasks);

  void addTask(TaskModel task) {
    _tasks.add(task);
    notifyListeners();
  }

  void removeTaskAt(int index) {
    _tasks.removeAt(index);
    notifyListeners(); //Notify the UI that a change in state occured
  }

  void upateTask({
    required int taskId,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    final task = _tasks[taskIndex];
    final updatedTask = task.copyWith(
      title: title,
      description: description,
      isCompleted: isCompleted,
    );

    _tasks[taskIndex] = updatedTask;
    notifyListeners();
  }
}
