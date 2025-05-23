### Interactivity

This step adds interactivity and a task model to our app.

### Steps:

**Step 1: Create Task model**

Create a file **lib/models/task_model.dart** and place the following contents:

```dart
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
```

Note that the model class is marked as @immutable to prevent accidental manipulation.

**Step 2: Make TasksScreen stateful**

Since user will be creating/editing tasks on the tasks screen, convert the **TasksScreen** widget to a stateful widget.
![image](https://github.com/user-attachments/assets/2bb749d7-b264-4818-bed9-45e304fa7233)

and add a field to the **\_TasksScreenState** class to hold the tasks.

```dart
final List<TaskModel> _tasks = [
  TaskModel(id: 81, title: 'Maths Homework', description: 'Linear algebra'),
  TaskModel(id: 45, title: 'Buy grocery', isCompleted: true),
];
```

**Step 3: Update TasksScreen**

Replace the body argument inside the build method with the following code

```dart
body: SafeArea(
  child: _tasks.isEmpty
      ? Center(child: Text('No todos'))
      : ListView.builder(
          itemCount: _tasks.length,
          itemBuilder: (context, index) {
            final task = _tasks[index];

            return Dismissible(
              key: ValueKey(task.id!),
              // When the user dismisses a task, delete it
              onDismissed: (direction) {
                setState(() => _tasks.removeAt(index));
              },
              child: ListTile(
                leading: Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    // Update the completion status of task
                    setState(() {
                      _tasks[index] = task.copyWith(isCompleted: value);
                    });
                  },
                ),
                title: Text(task.title),
                // We do not need a subtitle if description is empty
                subtitle: task.description.isEmpty
                    ? null
                    : Text(task.description),
              ),
            );
          },
        ),
),
```

Now the user can easily delete a task and update its completion status but can not yet create new task or update a task. We fix this in the next step

**Step 4: Update \_TasksScreenState**

Add a private method inside the state class to show a add/edit task dialog when a user wants to create or edit a task

```dart
/// Shows a dialog to enter a task title and description
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
```

**Step 5: Add a Floating Action Button**

Add a floating action button inside the scaffold that asks user to add a task

```dart
body: ...,
floatingActionButton: FloatingActionButton(
  onPressed: () async {
    final result = await _showTaskDialog(editTask: false);

    if (result != null && result.$1.isNotEmpty) {
      // Add logic here to use the returned values, e.g., add to _tasks
      String title = result.$1;
      String description = result.$2;
      final newTask = TaskModel(
        id: title.hashCode, // Taking hash code as id for simplicity now
        title: title,
        description: description,
      );

      // Adding the task
      setState(() => _tasks.add(newTask));
    }
  },
  child: Icon(Icons.add),
),
```

Now the user can add a task.
![image](https://github.com/user-attachments/assets/b3609699-da8c-456c-b8cc-c5643c5e3afa)

**Step 6: Update ListTile in the body**

Add onTap callback to out task ListTile to enable user to update a task

```dart
ListTile(
  leading: ...,
  title ...,
  subtitle: ...,
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

      // Updating the task
      setState(() {
        _tasks[index] = modifiedTask;
      });
    }
  },
)
```

![Screenshot from 2025-04-12 18-35-14](https://github.com/user-attachments/assets/c84dc67e-cb17-4710-a72f-c6f99815c2dd)

**What's Next**

We are done with this step. In the following steps, we refactor our code and use provider to seperate our UI Logic from Business Logic

👉 [View Step 02 Code Commit](https://github.com/Arfeen-Yousuf/todo_list_tutorial/commit/57b9dc349240b944f85e02c13d521112e4c93dbc)
