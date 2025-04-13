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
