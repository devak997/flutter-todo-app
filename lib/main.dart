import 'package:flutter/material.dart';
import './providers/todo_item.dart';
import './pages/home_page.dart';

import 'package:provider/provider.dart';

import './providers/todos_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: TodoItem(),
        ),
        ChangeNotifierProvider.value(
          value: TodosProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'TODO APP',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          accentColor: Colors.blueAccent,
          backgroundColor: Colors.pink[50],
          textTheme: TextTheme(
              title: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
          )),
        ),
        routes: {
          '/' : (ctx) => HomePage(),
          // '/edit-task' : (ctx) => TaskEditPage(),
        },
      ),
    );
  }
}
