import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todo/ui/pages/notification_screen.dart';

import '../models/task.dart';

class NotifyHelper {
  String selectedNotificationPayload = '';
  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initializeNotification() async {
    tz.initializeTimeZones();
    _configureSelectedNotificationSubject();
    await _configureLocalTimeZone();
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('appicon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
        }
        selectNotificationSubject.add(payload!);
      },
    );
  }

  final AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('appicon');

  Future<void> onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    Get.dialog(Text(body!));
  }

  displayNotification({required String? title, required String? body}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'default_sound',
    );
  }

  tz.TZDateTime _nextInstanceOfTenAM(
      int hour, int minutes, int remind, String repeat, String date) {
    final tz.TZDateTime tNow = tz.TZDateTime.now(tz.local);
    DateTime taskDate = DateFormat.yMd().parse(date);
    DateTime taskLocalDate = tz.TZDateTime.from(taskDate, tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(tz.local, taskLocalDate.year,
        taskLocalDate.month, taskLocalDate.day, hour + 12, minutes);

    scheduleDate = afterRemind(scheduleDate, remind);

    if (scheduleDate.isBefore(tNow)) {
      if (repeat == 'Daily') {
        scheduleDate = tz.TZDateTime(
            tz.local, tNow.year, tNow.month, (taskDate.day) + 1, hour, minutes);

        scheduleDate = afterRemind(scheduleDate, remind);
      }
      if (repeat == 'Weekly') {
        scheduleDate = tz.TZDateTime(
            tz.local, tNow.year, tNow.month, (taskDate.day) + 7, hour, minutes);
        scheduleDate = afterRemind(scheduleDate, remind);
      }
      if (repeat == 'Monthly') {
        scheduleDate = tz.TZDateTime(tz.local, tNow.year, (taskDate.month) + 1,
            taskDate.day, hour, minutes);
        scheduleDate = afterRemind(scheduleDate, remind);
      }
    }
    debugPrint('$scheduleDate');
    return scheduleDate;
  }

  tz.TZDateTime afterRemind(tz.TZDateTime scheduleDate, int remind) {
    if (remind == 5) {
      scheduleDate = scheduleDate.subtract(const Duration(minutes: 5));
    }
    if (remind == 10) {
      scheduleDate = scheduleDate.subtract(const Duration(minutes: 10));
    }
    if (remind == 15) {
      scheduleDate = scheduleDate.subtract(const Duration(minutes: 15));
    }
    if (remind == 20) {
      scheduleDate = scheduleDate.subtract(const Duration(minutes: 20));
    }
    return scheduleDate;
  }

  Future<void> scheduleNotification(
      {int? hour, int? minutes, required Task task}) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!,
      task.title,
      task.note,
      _nextInstanceOfTenAM(hour!, minutes!, task.remind!, task.repeat!,
          task.date!), //schedule date
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: IOSNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: '${task.title}|${task.note}|${task.startTime}|',
    );
  }

  requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          sound: true,
          badge: true,
        );
  }

  void _configureSelectedNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      debugPrint(payload);
      await Get.to(() => NotificationScreen(payload: payload));
    });
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  cancelNotification(Task task) async {
    await flutterLocalNotificationsPlugin.cancel(task.id!);
  }

  cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
