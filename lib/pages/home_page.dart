import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/todos_provider.dart';

import '../widgets/todo_list.dart';
import '../widgets/add_new_todo.dart';

class HomePage extends StatelessWidget {
  void presentAddTask(ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (ctx) {
          return AddNewTodo();
        },
        isScrollControlled: true);
  }

  @override
  Widget build(BuildContext context) {
    final todolist = Provider.of<TodosProvider>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Tasks'),
        actions: <Widget>[
          PopupMenuButton(
            elevation: 10,
            onSelected: (_) {
              todolist.toogleShowCompleted();
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: todolist.showCompleted ? Text('Hide Completed') : Text('Show Completed'),
                  value: 0,
                ),
              ];
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
        padding: EdgeInsets.all(10),
          child: TodoList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => presentAddTask(context),
        icon: Icon(Icons.add),
        label: Text('Add Task'),
        elevation: 20,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
