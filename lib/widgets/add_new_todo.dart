import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todos_provider.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../notifications/NotifivationProvider.dart';

class AddNewTodo extends StatefulWidget {
  @override
  _AddNewTodoState createState() => _AddNewTodoState();
}

class _AddNewTodoState extends State<AddNewTodo> {
  DateTime _dueDate;
  DateTime _remindTime;
  final _titleController = TextEditingController();
  final _textFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  void _presentDatePicker(ctx) {
    _textFocusNode.unfocus();
    showDatePicker(
      context: ctx,
      firstDate: DateTime.now(),
      initialDate: DateTime.now(),
      lastDate: DateTime(2120),
    ).then((newdate) {
      if (newdate != null) {
        setState(() {
          _dueDate = newdate;
        });
      }
      _textFocusNode.requestFocus();
    });
  }

  void handleSubmit(tasklist, ctx) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    final title = _titleController.text;
    tasklist.addItem(title: title, dueDate: _dueDate, remindTime: _remindTime);
    if (_remindTime != null) {
      NotificationProvider.instance.scheduleNotification(title, _remindTime);
    }

    Navigator.of(context).pop();
  }

  void _presentDateTimePicker(ctx) {
    _textFocusNode.unfocus();
    showDatePicker(
      context: ctx,
      firstDate: DateTime(2020),
      initialDate: DateTime.now(),
      lastDate: DateTime(2120),
    ).then((newdate) {
      if (newdate != null) {
        showTimePicker(
          context: ctx,
          initialTime: TimeOfDay.now(),
        ).then((newTime) {
          if (newTime != null) {
            setState(() {
              _remindTime = DateTime(newdate.year, newdate.month, newdate.day,
                  newTime.hour, newTime.minute);
            });
          }
          _textFocusNode.requestFocus();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tasklist = Provider.of<TodosProvider>(context);
    return SingleChildScrollView(
      child: Card(
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  onFieldSubmitted: (_) => handleSubmit(tasklist, context),
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Enter Titile';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Title',
                    suffix: IconButton(
                      icon: Icon(Icons.done),
                      color: Colors.green,
                      onPressed: () => handleSubmit(tasklist, context),
                    ),
                    contentPadding: EdgeInsets.all(2),
                  ),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textInputAction: TextInputAction.done,
                  controller: _titleController,
                  focusNode: _textFocusNode,
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton.icon(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      label: _dueDate == null
                          ? Text('Due Date')
                          : Text(DateFormat.MMMEd().format(_dueDate)),
                      color: _dueDate == null
                          ? Theme.of(context).backgroundColor
                          : Theme.of(context).primaryColor,
                      icon: Icon(_dueDate == null
                          ? Icons.add_circle_outline
                          : Icons.calendar_today),
                      onPressed: () {
                        _presentDatePicker(context);
                      },
                    ),
                    FlatButton.icon(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      label: _remindTime == null
                          ? Text('Reminder')
                          : Text(DateFormat.MEd().add_Hm().format(_remindTime)),
                      color: _remindTime == null
                          ? Theme.of(context).backgroundColor
                          : Theme.of(context).primaryColor,
                      icon: Icon(_remindTime == null
                          ? Icons.add_circle_outline
                          : Icons.alarm_on),
                      onPressed: () {
                        _presentDateTimePicker(context);
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
