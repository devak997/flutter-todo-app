import 'package:flutter/material.dart';
import '../database/database_provider.dart';

class TodoItem with ChangeNotifier {
  int id;
  String title;
  DateTime dueDate;
  DateTime remindTime;
  bool isImportant;
  bool isCompleted;

  TodoItem(
      {this.id,
      this.title,
      this.dueDate,
      this.remindTime,
      this.isImportant: false,
      this.isCompleted: false});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_TITLE: title,
      DatabaseProvider.COLUMN_DUEDATE:
          dueDate == null ? null : dueDate.toIso8601String(),
      DatabaseProvider.COLUMN_REMINDTIME:
          remindTime == null ? null : remindTime.toIso8601String(),
      DatabaseProvider.COLUMN_IMPORTANT: isImportant ? 1 : 0,
      DatabaseProvider.COLUMN_COMPLETED: isCompleted ? 1 : 0,
    };

    if (id != null) {
      map[DatabaseProvider.COLUMN_ID] = id;
    }

    return map;
  }

  TodoItem.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
    title = map[DatabaseProvider.COLUMN_TITLE];
    dueDate = map[DatabaseProvider.COLUMN_DUEDATE] == null
        ? null
        : DateTime.parse(map[DatabaseProvider.COLUMN_DUEDATE]);
    remindTime = map[DatabaseProvider.COLUMN_REMINDTIME] == null
        ? null
        : DateTime.parse(map[DatabaseProvider.COLUMN_REMINDTIME]);
    isImportant = map[DatabaseProvider.COLUMN_IMPORTANT] == 1;
    isCompleted = map[DatabaseProvider.COLUMN_COMPLETED] == 1;
  }

  void toogleImportant() {
    isImportant = !isImportant;
    DatabaseProvider.db.update(this);
    notifyListeners();
  }

  void toogleCompleted() {
    isCompleted = !isCompleted;
    DatabaseProvider.db.update(this);
    notifyListeners();
  }
}
