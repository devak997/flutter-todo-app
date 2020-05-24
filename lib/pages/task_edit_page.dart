import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskEditPage extends StatefulWidget {
  final String title;
  final int id;
  final DateTime dueDate;
  final DateTime remindTime;

  TaskEditPage(this.id, this.title, this.dueDate, this.remindTime);
  @override
  _TaskEditPageState createState() => _TaskEditPageState();
}

class _TaskEditPageState extends State<TaskEditPage> {
  final _formKey = GlobalKey<FormState>();
  String title;
  int id;
  DateTime dueDate;
  DateTime remindTime;
  final _textFocusNode = FocusNode();

  @override
  void initState() {
    title = widget.title;
    id = widget.id;
    dueDate = widget.dueDate;
    remindTime = widget.remindTime;

    super.initState();
  }

  void _presentDatePicker(ctx) {
    _textFocusNode.unfocus();
    showDatePicker(
      context: ctx,
      firstDate: DateTime.now(),
      initialDate: dueDate == null ? DateTime.now() : dueDate,
      lastDate: DateTime(2120),
    ).then((newdate) {
      if (newdate != null) {
        setState(() {
          dueDate = newdate;
        });
      }
      _textFocusNode.requestFocus();
    });
  }

  void _presentDateTimePicker(ctx) {
    _textFocusNode.unfocus();
    showDatePicker(
      context: ctx,
      firstDate: DateTime(2020),
      initialDate: remindTime == null ? DateTime.now() : dueDate,
      lastDate: DateTime(2120),
    ).then((newdate) {
      if (newdate != null) {
        showTimePicker(
          context: ctx,
          initialTime: TimeOfDay.now(),
        ).then((newTime) {
          if (newTime != null) {
            setState(() {
              remindTime = DateTime(newdate.year, newdate.month, newdate.day,
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
    final id = ModalRoute.of(context).settings.arguments;
    return SingleChildScrollView(
      child: Card(
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  focusNode: _textFocusNode,
                  initialValue: title,
                  autofocus: true,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton.icon(
                      color: Theme.of(context).backgroundColor,
                      onPressed: () => _presentDatePicker(context),
                      icon: Icon(dueDate == null
                          ? Icons.add_circle
                          : Icons.calendar_today),
                      label: Text(
                        dueDate == null
                            ? 'Add date'
                            : DateFormat.yMMMd().format(dueDate),
                      ),
                    ),
                    FlatButton.icon(
                      onPressed: () => _presentDateTimePicker(context),
                      color: Theme.of(context).backgroundColor,
                      icon: Icon(
                          remindTime == null ? Icons.add_circle : Icons.alarm),
                      label: Text(
                        remindTime == null
                            ? 'Add Remainder'
                            : DateFormat.MEd().format(remindTime),
                      ),
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
