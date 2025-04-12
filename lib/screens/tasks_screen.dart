import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_tutorial/models.dart/task_model.dart';
import 'package:todo_list_tutorial/providers/tasks_providers.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TasksProviders>().tasks;

    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: SafeArea(
        child:
            tasks.isEmpty
                ? Center(child: Text('No todos'))
                : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];

                    return Dismissible(
                      key: ValueKey(task.id!),
                      //When the user dismisses a task, delete it
                      onDismissed:
                          (direction) => context
                              .read<TasksProviders>()
                              .removeTaskAt(index),
                      child: ListTile(
                        leading: Checkbox(
                          value: task.isCompleted,
                          onChanged: (value) {
                            //Update the completion status of task
                            context.read<TasksProviders>().upateTask(
                              taskId: task.id!,
                              isCompleted: value,
                            );
                          },
                        ),
                        title: Text(task.title),
                        //We don't need a subtitle if description is empty
                        subtitle:
                            task.description.isEmpty
                                ? null
                                : Text(task.description),
                        onTap: () async {
                          final result = await _showTaskDialog(
                            context,
                            editTask: true,
                            initialTitle: task.title,
                            initialDescription: task.description,
                          );

                          if (result != null && result.$1.isNotEmpty) {
                            // Add logic here to use the returned values, e.g., add to tasks
                            String title = result.$1;
                            String description = result.$2;

                            if (context.mounted) {
                              context.read<TasksProviders>().upateTask(
                                taskId: task.id!,
                                title: title,
                                description: description,
                              );
                            }
                          }
                        },
                      ),
                    );
                  },
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await _showTaskDialog(context, editTask: false);

          if (result != null && result.$1.isNotEmpty) {
            // Add logic here to use the returned values, e.g., add to tasks
            String title = result.$1;
            String description = result.$2;
            final newTask = TaskModel(
              id: title.hashCode, //Taking hash code as id for simplicity now
              title: title,
              description: description,
            );

            //Adding the task
            if (context.mounted) {
              context.read<TasksProviders>().addTask(newTask);
            }
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  ///Shows a dialog to enter a task title and description
  Future<(String title, String description)?> _showTaskDialog(
    BuildContext context, {
    required bool editTask,
    String? initialTitle,
    String? initialDescription,
  }) async {
    final result = await showDialog<(String, String)>(
      context: context,
      builder: (context) {
        final titleController = TextEditingController(text: initialTitle);
        final descriptionController = TextEditingController(
          text: initialDescription,
        );

        return AlertDialog(
          title: Text(editTask ? 'Edit Task' : 'New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, (
                  titleController.text.trim(),
                  descriptionController.text.trim(),
                ));
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    return result;
  }
}
