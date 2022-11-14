import 'package:flutter/material.dart';
import 'package:flutter_alarm_app/ui/main_screen.dart';
import 'package:flutter_alarm_app/ui/show_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

String router = '';

// @pragma('vm:entry-point')
// // void notificationTapBackground(NotificationResponse notificationResponse) {
//   router = 'ok';
// }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _initLocalNotification();
  runApp(const MyApp());
}

Future<void> _initLocalNotification() async {
  FlutterLocalNotificationsPlugin _localNotification =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings initSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  IOSInitializationSettings initSettingsIOS = const IOSInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );

  InitializationSettings initSettings = InitializationSettings(
    android: initSettingsAndroid,
    iOS: initSettingsIOS,
  );
  await _localNotification.initialize(
    initSettings,
    onSelectNotification: (v) {
      router = 'adskljflsadjflasd';
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Alarm App Test',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const MainScreen(),
      routes: {
        "/show": (context) => ShowScreen(),
      },
    );
  }
}
