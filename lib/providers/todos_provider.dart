import 'package:flutter/material.dart';
import './todo_item.dart';
import '../database/database_provider.dart';

class TodosProvider with ChangeNotifier {
  bool isInit = false;
  bool showCompleted = true;

  List<TodoItem> _items = [];


  TodosProvider() {
    initData();
  }

  void initData() {
    if (isInit == false) {
      _items.clear();
      DatabaseProvider.db.getTasks().then((tasks) {
        print("Contacting DB Tasks Len: ${tasks.length}");
        _items.addAll(tasks);
        isInit = true;
        notifyListeners();
      });
    }
  }

  List<TodoItem> get items {
    if(!showCompleted) {
      return _items.where((item) => !item.isCompleted).toList();
    }
    return [..._items];
  }

  void addItem({String title, DateTime dueDate, DateTime remindTime}) {
    var currentTask =
        TodoItem(title: title, dueDate: dueDate, remindTime: remindTime);
    DatabaseProvider.db.insert(currentTask).then((task) {
      _items.add(task);
      notifyListeners();
    });
  }

  void deleteItem(int id) {
    DatabaseProvider.db.delete(id).then((_) {
      _items.removeWhere((task) => task.id == id);
      notifyListeners();
    });
  }

  void toogleShowCompleted() {
    showCompleted = !showCompleted;
    notifyListeners();
  }
}
