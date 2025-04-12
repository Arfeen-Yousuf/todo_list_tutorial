import 'package:flutter/foundation.dart';

@immutable
class TaskModel {
  final int? id; //Used to identify a specific task
  final String title;
  final String description;
  final bool isCompleted;

  const TaskModel({
    this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
  });

  TaskModel copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
