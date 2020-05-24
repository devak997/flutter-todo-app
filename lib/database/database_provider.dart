import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/providers/todo_item.dart';

class DatabaseProvider {
  static final _databaseName = 'tasks_db.db';
  static final _databaseVersion = 1;
  static const TASKS_TABLE = 'tasks';
  static const COLUMN_ID = 'id';
  static const COLUMN_TITLE = 'title';
  static const COLUMN_DUEDATE = 'dueDate';
  static const COLUMN_REMINDTIME = 'remindTime';
  static const COLUMN_IMPORTANT = 'isImportant';
  static const COLUMN_COMPLETED = 'isCompleted';

  DatabaseProvider._private();

  static final DatabaseProvider db = DatabaseProvider._private();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute("CREATE TABLE $TASKS_TABLE  ("
        "$COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$COLUMN_TITLE TEXT,"
        "$COLUMN_DUEDATE Text,"
        "$COLUMN_REMINDTIME Text,"
        "$COLUMN_IMPORTANT int,"
        "$COLUMN_COMPLETED int"
        ")");
  }

  Future<List<TodoItem>> getTasks() async {
    final db = await database;
    var tasks = await db.query(TASKS_TABLE);
    return List.generate(tasks.length, (index) {
      return TodoItem.fromMap(tasks[index]);
    });
  }

  Future<TodoItem> insert(TodoItem task) async {
    final db = await database;
    task.id = await db.insert(TASKS_TABLE, task.toMap());
    return task;
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(TASKS_TABLE, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(TodoItem task) async {
    final db = await database;
    return await db.update(TASKS_TABLE, task.toMap(),where: "id = ?", whereArgs: [task.id]);
  }
}
