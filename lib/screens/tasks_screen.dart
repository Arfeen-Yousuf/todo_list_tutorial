import 'package:flutter/material.dart';
import 'package:todo_list_tutorial/models.dart/task_model.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final List<TaskModel> _tasks = [
    TaskModel(id: 81, title: 'Maths Homework', description: 'Linear algebra'),
    TaskModel(id: 45, title: 'Buy grocery', isCompleted: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: SafeArea(
        child:
            _tasks.isEmpty
                ? Center(child: Text('No todos'))
                : ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];

                    return Dismissible(
                      key: ValueKey(task.id!),
                      //When the user dismisses a task, delete it
                      onDismissed: (direction) {
                        setState(() => _tasks.removeAt(index));
                      },
                      child: ListTile(
                        leading: Checkbox(
                          value: task.isCompleted,
                          onChanged: (value) {
                            //Update the completion status of task
                            setState(() {
                              _tasks[index] = task.copyWith(isCompleted: value);
                            });
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
                            editTask: true,
                            initialTitle: task.title,
                            initialDescription: task.description,
                          );

                          if (result != null && result.$1.isNotEmpty) {
                            // Add logic here to use the returned values, e.g., add to _tasks
                            String title = result.$1;
                            String description = result.$2;
                            final modifiedTask = task.copyWith(
                              title: title,
                              description: description,
                            );

                            //Updating the task the task
                            setState(() {
                              _tasks[index] = modifiedTask;
                            });
                          }
                        },
                      ),
                    );
                  },
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await _showTaskDialog(editTask: false);

          if (result != null && result.$1.isNotEmpty) {
            // Add logic here to use the returned values, e.g., add to _tasks
            String title = result.$1;
            String description = result.$2;
            final newTask = TaskModel(
              id: title.hashCode, //Taking hash code as id for simplicity now
              title: title,
              description: description,
            );

            //Adding the task
            setState(() => _tasks.add(newTask));
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  ///Shows a dialog to enter a task title and description
  Future<(String title, String description)?> _showTaskDialog({
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
