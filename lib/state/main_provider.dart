import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MainProvider extends ChangeNotifier {
  bool isSplash = true;
  String test = 'asdfdsf';

  Future<void> _initLocalNotification() async {
    FlutterLocalNotificationsPlugin _localNotification =
        FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings initSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings initSettingsIOS =
        const DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    InitializationSettings initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );
    await _localNotification.initialize(
      initSettings,
    );
  }

  void delayedSplash() {
    _initLocalNotification();
    Future.delayed(const Duration(milliseconds: 2000), () {
      isSplash = false;
      notifyListeners();
    });
  }
}
