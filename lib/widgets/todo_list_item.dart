import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:todo_app/pages/task_edit_page.dart';
import '../providers/todo_item.dart';
import '../providers/todos_provider.dart';

class TodoListItem extends StatelessWidget {
  String dateToText({date, includeTime = false}) {
    var now = DateTime.now();
    int diff =
        date.difference(DateTime(now.year, now.month, now.day, 0, 0)).inHours;
    if (diff < 24) {
      return 'Today';
    } else if (diff < 48) {
      return 'Tommorow';
    } else {
      return includeTime
          ? DateFormat.MEd().add_Hm().format(date)
          : DateFormat.yMMMd().format(date);
    }
  }

  void presentEditTask(
      ctx, int id, String title, DateTime dueDate, DateTime remindTime) {
    showModalBottomSheet(
        context: ctx,
        builder: (ctx) {
          return TaskEditPage(id, title, dueDate, remindTime);
        },
        isScrollControlled: true);
  }

  Widget subTitleText(TodoItem item, double fontSize) {
    if (item.dueDate != null && item.remindTime != null) {
      var dateText = dateToText(date: item.dueDate);
      return Row(
        children: [
          Icon(Icons.calendar_today,
              size: fontSize,
              color: dateText == 'Today' ? Colors.red : Colors.black),
          SizedBox(
            width: 5,
          ),
          Text(
            dateText,
            style: TextStyle(
              fontSize: fontSize,
              color: dateText == 'Today' ? Colors.red : Colors.black,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Text('·'),
          SizedBox(
            width: 5,
          ),
          Icon(
            Icons.alarm_on,
            color: dateText == 'Today' ? Colors.red : Colors.black,
            size: fontSize,
          ),
        ],
      );
    }

    if (item.dueDate != null) {
      var dateText = dateToText(date: item.dueDate);
      return Row(children: [
        Icon(
          Icons.calendar_today,
          color: dateText == 'Today' ? Colors.red : Colors.black,
          size: fontSize,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          dateText,
          style: TextStyle(
            fontSize: fontSize,
            color: dateText == 'Today' ? Colors.red : Colors.black,
          ),
        ),
      ]);
    }

    if (item.remindTime != null) {
      var dateText = dateToText(date: item.remindTime, includeTime: true);
      return Row(children: [
        Icon(
          Icons.alarm_on,
          size: fontSize,
          color: dateText == 'Today' ? Colors.purple : Colors.black,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          dateText,
          style: TextStyle(
            fontSize: fontSize,
            color: dateText == 'Today' ? Colors.purple : Colors.black,
          ),
        ),
      ]);
    }

    return null;
  }

  final Key _dismissKey = GlobalKey();
  Widget build(BuildContext context) {
    return Consumer<TodoItem>(
      builder: (ctx, todoitem, child) {
        return Dismissible(
          key: _dismissKey,
          background: Container(
            color: Theme.of(context).errorColor,
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: 40,
            ),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(
              right: 10,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 4,
            ),
          ),
          onDismissed: (_) => Provider.of<TodosProvider>(context, listen: false)
              .deleteItem(todoitem.id),
          direction: DismissDirection.endToStart,
          child: Card(
            elevation: 8,
            child: ListTile(
              leading: IconButton(
                icon: Icon(
                  todoitem.isCompleted
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                ),
                color: todoitem.isCompleted
                    ? Colors.green
                    : Theme.of(context).accentColor,
                onPressed: () {
                  todoitem.toogleCompleted();
                },
              ),
              title: Text(
                todoitem.title,
                style: TextStyle(
                  decoration: todoitem.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              subtitle: subTitleText(todoitem, 12),
              trailing: Wrap(
                spacing: 12,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => presentEditTask(
                      context,
                      todoitem.id,
                      todoitem.title,
                      todoitem.dueDate,
                      todoitem.remindTime,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      todoitem.isImportant ? Icons.star : Icons.star_border,
                    ),
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      todoitem.toogleImportant();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
