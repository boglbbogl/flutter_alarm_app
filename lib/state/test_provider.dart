import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TestProvider extends ChangeNotifier {
  tz.TZDateTime _timeZoneSetting() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    tz.TZDateTime _now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, _now.year, _now.month,
        _now.day, _now.hour, _now.minute, _now.second);
    return scheduledDate.add(const Duration(days: 0));
  }

  Future<void> loopPushAlarm() async {
    FlutterLocalNotificationsPlugin _localNotification =
        FlutterLocalNotificationsPlugin();
    NotificationDetails _details = const NotificationDetails(
      android: AndroidNotificationDetails('alarm 3', '3번 푸시'),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
    _localNotification.zonedSchedule(
      3,
      '로컬 푸시 알림 3',
      '로컬 푸시 10초 마다 알림',
      _timeZoneSetting(),
      _details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  Future<void> selectedDatePushAlarm() async {
    FlutterLocalNotificationsPlugin _localNotification =
        FlutterLocalNotificationsPlugin();

    NotificationDetails _details = const NotificationDetails(
      android: AndroidNotificationDetails('alarm 2', '2번 푸시'),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
    _localNotification.zonedSchedule(
      1,
      '로컬 푸시 알림 2',
      '특정 날짜 / 시간대 전송 알림',
      _timeZoneSetting(),
      _details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> showPushAlarm() async {
    FlutterLocalNotificationsPlugin _localNotification =
        FlutterLocalNotificationsPlugin();

    NotificationDetails _details = const NotificationDetails(
      android: AndroidNotificationDetails('alarm 1', '1번 푸시'),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _localNotification.show(0, '로컬 푸시 알림', '로컬 푸시 알림 테스트', _details,
        payload: 'deepLink');
  }
}
