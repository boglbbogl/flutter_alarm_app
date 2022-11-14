import 'package:flutter/widgets.dart';
import 'package:flutter_alarm_app/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MainProvider extends ChangeNotifier {
  bool isSplash = true;
  String test = 'asdfdsf';
  String test2 = 'router test';

  void getTest(String v) async {
    test2 = v;
    FlutterLocalNotificationsPlugin _localNotification =
        FlutterLocalNotificationsPlugin();
    NotificationAppLaunchDetails? details =
        await _localNotification.getNotificationAppLaunchDetails();
    final notificationAppLaunchDetails =
        await _localNotification.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      print(notificationAppLaunchDetails!.payload);
    }
    print(details!.didNotificationLaunchApp);
    print(details.payload);
    notifyListeners();
  }

  void _runWhileAppIsTerminated() async {
    FlutterLocalNotificationsPlugin _localNotification =
        FlutterLocalNotificationsPlugin();
    var details = await _localNotification.getNotificationAppLaunchDetails();

    if (details!.didNotificationLaunchApp) {
      if (details.payload != null) {
        router = '13413242341234123412341';
      }
    }
  }

  void refresh() => notifyListeners();

  void delayedSplash() {
    _runWhileAppIsTerminated();
    // _initLocalNotification();
    Future.delayed(const Duration(milliseconds: 2000), () {
      isSplash = false;
      notifyListeners();
    });
  }
}
