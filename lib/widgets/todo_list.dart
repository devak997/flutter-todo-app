import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todos_provider.dart';
import './todo_list_item.dart';

class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TodosProvider>(
      builder: (ctx, todolist, child) {
        return todolist.isInit
            ? todolist.items.length == 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/tasks-2.png',
                        fit: BoxFit.cover,
                      ),
                      Text('Tap the  button below to add tasks!'),
                    ],
                  )
                : ListView.builder(
                    itemCount: todolist.items.length,
                    itemBuilder: (ctx, index) {
                      return ChangeNotifierProvider.value(
                          value: todolist.items[index], child: TodoListItem());
                    },
                  )
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}
