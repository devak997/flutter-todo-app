import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo_app/providers/todo_item.dart';

class NotificationProvider {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  static final initializationSettingsIOS = IOSInitializationSettings();
  static final initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);

  final MethodChannel platform = MethodChannel('crossingthestreams.io/resourceResolver');

  static final NotificationProvider instance = NotificationProvider._();

  NotificationProvider._() {
    init();
  }

  Future<void> init() async {
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleNotification(String title, DateTime date) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'deva_channel_01',
      'Tasks Channel',
      'Channel for TODO App,',
      enableVibration: true,
      importance: Importance.High,
      category: 'reminder',
      visibility: NotificationVisibility.Public,
      styleInformation: DefaultStyleInformation(true,true),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        '$title',
        'Just a quick remainder for your task!',
        date,
        platformChannelSpecifics);
  }
}
