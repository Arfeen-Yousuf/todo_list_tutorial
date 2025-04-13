### Persisting Tasks with SQLite in Flutter

This guide shows you how to store a list of TaskModel objects locally using SQLite, with insert, retrieve, update, and delete operations.

### Steps

**📦 Step 1: Add Dependencies**

Add sqflite and path to your pubspec.yaml:

```bash
flutter pub add sqflite path
```

**⚠️ Note on sqflite**

The sqflite package works only on mobile platforms (Android and iOS). It does not support web or desktop out of the box.

If you're using a newer version of sqflite and encounter build errors on Android you may need to update your Android NDK (Native Development Kit). Check the version requirements on the [sqflite changelog](https://pub.dev/packages/sqflite/changelog) and ensure your local.properties file points to a valid NDK path. You will need to update your ndk version in the android/app/build.gradle file also.

**Step 2: Update the main method**

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}
```

**🧱 Step 3: Add TaskModel serialization and deserialization methods**

Add the following methods to our TasksModel class.

```dart
Map<String, dynamic> toMap() {
  return {
    '_id': id,
    'title': title,
    'description': description,
    'isCompleted': isCompleted ? 1 : 0,
  };
}

factory TaskModel.fromMap(Map<String, dynamic> map) {
  return TaskModel(
    id: map['_id'],
    title: map['title'],
    description: map['description'],
    isCompleted: map['isCompleted'] == 1,
  );
}
```

**🗂️ Step 4: Create a Database Helper**

Create a file called **task_database.dart** inside **lib/services** directory.

```dart
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list_tutorial/models.dart/task_model.dart';

class TaskDatabase {
  //Singleton design pattern is used for database service
  static final instance = TaskDatabase._init();

  Database? _database;

  TaskDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        _id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        isCompleted INTEGER NOT NULL
      )
    ''');
  }

  Future<TaskModel> insertTask(TaskModel task) async {
    final db = await instance.database;
    //Take the id of a task as time in milliseconds since epoch
    task = task.copyWith(id: DateTime.now().millisecondsSinceEpoch);
    await db.insert('tasks', task.toMap());
    return task;
  }

  Future<List<TaskModel>> getTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks');
    return result.map((map) => TaskModel.fromMap(map)).toList();
  }

  Future<int> updateTask(TaskModel task) async {
    final db = await instance.database;
    return db.update(
      'tasks',
      task.toMap(),
      where: '_id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return db.delete('tasks', where: '_id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
```

**Step 5: Use database helper in the TasksProvider**

Use the database helper in the TasksProviders class to update the database also whenever the state is changing. Here is an updated version of it. Note the changes.

```dart
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
```

**Step 6: Reflect the UI**

In the TasksScreen build method, replace the line

```dart
final tasks = context.watch<TasksProviders>().tasks;
```

with this code

```dart
final tasksProvider = context.watch<TasksProviders>();
//If the tasks are loading from the database, show a
//circular progress indicator
if (tasksProvider.loading) {
  return Scaffold(
    appBar: AppBar(title: const Text('Tasks')),
    body: Center(child: CircularProgressIndicator()),
  );
}

//Else show the tasks
final tasks = tasksProvider.tasks;
```

This allows us to show a loader(circular progress indicator) when the tasks have not been loaded yet. When the tasks are loaded, TasksScreen gets notified and show the tasks.

### 🎉 Congratulations!

You've just built a fully functional Todo App with local SQLite storage in Flutter!
You've learned how to create, update, delete, and persist tasks — all right on the device.

Feel free to customize it further, or continue building by adding features like task reminders, search, or even dark mode.

**Happy coding! 🚀**

👉 [View Step 04 Code Commit](https://github.com/Arfeen-Yousuf/todo_list_tutorial/commit/545c40b46a134781abe0ae07394a4a232106fb4f)
