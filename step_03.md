This step refactors the code to use **providers** in order to separate UI logic from business logic and make architecture cleaner.

**What is ChangeNotifier**

ChangeNotifier is a class in Flutter's Flutter Foundation library that helps manage state in your app. It **notifies listeners** (usually UI components) whenever there’s a **change in the data** they depend on. By extending ChangeNotifier in your custom class and calling **notifyListeners()** when your data changes, you can automatically update your UI without manually managing **setState** calls across multiple widgets. It's a simple yet powerful tool for managing state in smaller apps.

### Steps:

**Step 1:** Create a file **lib/providers/tasks_provider.dart** and place the following contents:

```dart
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
}
```

**Step 2: Update TasksProviders**

Note that our state has now moved to TasksProvider class. Next add these methods to the TasksProviders class that allow us to mutate the state.

```dart
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
```

**Step 3: Add Dependencies**

Add provider package by running the following command in the project root folder.

```bash
flutter pub add provider
```

**Step 4: Update MyApp**

Change the home argument in MyApp widget in main file to

```dart
home: ChangeNotifierProvider(
  create: (context) => TasksProviders(),
  child: TasksScreen(),
),
```

**Step 5: Update TasksScreen**

Remove the \_tasks field from the \_TasksScreenState class and convert the TasksScreen back to a stateless. We will fix the errors that arise.

**Hint:** Replace

```dart
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
```

with

```dart
class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});
```

**Step 6: Start listening to tasks**

Add the following line to the start of TaskScreen build method

```dart
final tasks = context.watch<TasksProviders>().tasks;
```

and replace change all \_tasks to tasks. context.watch registers the widget as a listener to the tasks changes.

**Step 7: Refact the TasksScreen**

Change

```dart
onDismissed: (direction) {
  setState(() => tasks.removeAt(index));
}
```

in the dismissible widget to

```dart
onDismissed: (direction) => context.read<TasksProviders>().removeTaskAt(index),
```

Update onChanged inside the Checkbox from

```dart
onChanged: (value) {
  //Update the completion status of task
  setState(() {
    tasks[index] = task.copyWith(isCompleted: value);
  });
},
```

to

```dart
onChanged: (value) {
  //Update the completion status of task
  context.read<TasksProviders>().upateTask(
    taskId: task.id!,
    isCompleted: value,
  );
},
```

Update the onTap argument in the ListTile from

```dart
onTap: () async {
  final result = await _showTaskDialog(
    editTask: true,
    initialTitle: task.title,
    initialDescription: task.description,
  );

  if (result != null && result.$1.isNotEmpty) {
    // Add logic here to use the returned values, e.g., add to tasks
    String title = result.$1;
    String description = result.$2;
    final modifiedTask = task.copyWith(
      title: title,
      description: description,
    );

    //Updating the task
    setState(() {
      tasks[index] = modifiedTask;
    });
  }
},
```

to

```dart
onTap: () async {
  final result = await _showTaskDialog(
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
```

Finally replace the line

```dart
setState(() => tasks.add(newTask));
```

inside the FloatingActionButton onPressed callback with

```dart
if (context.mounted) {
  context.read<TasksProviders>().addTask(newTask);
}
```

You will notice that our \_showTaskDialog method now requires a BuildContext because we changes our TasksScreen to a stateless widget. Let's add this and pass it everywhere the method is called.

```dart
///Shows a dialog to enter a task title and description
///Shows a dialog to enter a task title and description
Future<(String title, String description)?> _showTaskDialog(
  BuildContext context, {
  required bool editTask,
  String? initialTitle,
  String? initialDescription,
})
```

Remember to pass the context as argument where the method is called.

**Step 8: Run the App**

Now run the app and it should work same as before. But now with a cleaner code structure and seperation of concerns.

**What's Next**

We are done with this step. In the following steps, we will add a local databse using sqflite package to persist the tasks.

👉 [View Step 03 Code Commit](https://github.com/Arfeen-Yousuf/todo_list_tutorial/commit/497a78a5820ab65c030a913cfcf21f894984c29f)
