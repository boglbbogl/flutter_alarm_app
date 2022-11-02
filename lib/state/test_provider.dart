import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TestProvider extends ChangeNotifier {
  List<PendingNotificationRequest> notifications = [];
  Future<tz.TZDateTime> _timeZoneSetting({
    int duration = 0,
  }) async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    tz.TZDateTime _now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, _now.year, _now.month,
        _now.day, _now.hour, _now.minute, _now.second);

    return scheduledDate;
  }

  Future<void> unSubscripe() async {
    FlutterLocalNotificationsPlugin _localNotification =
        FlutterLocalNotificationsPlugin();
    await _localNotification.cancelAll();
  }

  Future<void> loopPushAlarm(int index) async {
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
    tz.TZDateTime _timeZone =
        await _timeZoneSetting(duration: index == 0 ? 1 : 0);
    String _setting =
        '${_timeZone.year}-${_timeZone.month}-${_timeZone.day} ${_timeZone.hour}:${_timeZone.minute}:${_timeZone.second}';

    _localNotification.zonedSchedule(
      index == 0 ? 3 : 4,
      '로컬 푸시 알림 3',
      index == 0 ? '$_setting 설정_일간' : '$_setting 설정_월간',
      await _timeZoneSetting(duration: index == 0 ? 1 : 0),
      _details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: index == 0
          ? DateTimeComponents.time
          : index == 1
              ? DateTimeComponents.dayOfWeekAndTime
              : index == 2
                  ? DateTimeComponents.dayOfMonthAndTime
                  : null,
      payload: '$_setting 마다 노출되어야 함',
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
      await _timeZoneSetting(),
      _details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: '한 번만 노출되고 사라짐',
    );
  }

  Future<void> checked() async {
    FlutterLocalNotificationsPlugin _localNotification =
        FlutterLocalNotificationsPlugin();
    notifications = await _localNotification.pendingNotificationRequests();
    notifyListeners();
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
        payload: '즉시 알림 노출');
  }
}
