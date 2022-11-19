import 'package:background_fetch/background_fetch.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alarm_app/ui/main_screen.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as zone;
import 'package:timezone/timezone.dart' as zone;

// [Android-only] This "Headless Task" is run when the Android app is terminated with `enableHeadless: true`
// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
@pragma('vm:entry-point')
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  FlutterAppBadger.updateBadgeCount(111);
  SharedPreferences? pre = await SharedPreferences.getInstance();
  List<String> save = [];
  List<String>? _add = pre.getStringList('BACKGROUND');
  if (_add != null) {
    save = _add;
  }
  if (isTimeout) {
    save.add('[BackgroundFetch] TIME_OUT');
    await pre.setStringList('BACKGROUND', save);
    // This task has exceeded its allowed running-time.
    // You must stop what you're doing and immediately .finish(taskId)
    print("[BackgroundFetch] Headless 1 task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  } else {
    save.add('[BackgroundFetch] SUCCESS_UNDER');
    await pre.setStringList('BACKGROUND', save);
  }
  // save.add('[BackgroundFetch] OK');
  // await pre.setStringList('BACKGROUND', save);
  print('[BackgroundFetch] Headless event received.');
  // Do your work here...
  BackgroundFetch.finish(taskId);
}

List<String>? showList = [];

void main() {
  // Enable integration testing with the Flutter Driver extension.
  // See https://flutter.io/testing/ for more info.
  runApp(new MyApp());

  // Register to receive BackgroundFetch events after app is terminated.
  // Requires {stopOnTerminate: false, enableHeadless: true}
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _enabled = true;
  int _status = 0;
  List<DateTime> _events = [];

  @override
  void initState() {
    super.initState();
    notiInit();
    initPlatformState();
  }

  notiInit() {
    FlutterLocalNotificationsPlugin _noti = FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings _aos =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    IOSInitializationSettings _ios = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    InitializationSettings _setting =
        InitializationSettings(iOS: _ios, android: _aos);
    // _noti.initialize(_setting);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    int status = await BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.NONE), (String taskId) async {
      FlutterAppBadger.updateBadgeCount(444);
      SharedPreferences? pre = await SharedPreferences.getInstance();
      List<String> save = [];
      List<String>? _test = pre.getStringList('BACKGROUND');
      if (_test != null) {
        save = _test;
      }
      save.add("[BackgroundFetch] BACK - SUCCESS :: $taskId");
      await pre.setStringList('BACKGROUND', save);
      print("[BackgroundFetch] Event received $taskId");
      setState(() {
        _events.insert(0, new DateTime.now());
      });
      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      FlutterAppBadger.updateBadgeCount(222);

      SharedPreferences? pre = await SharedPreferences.getInstance();
      List<String> save = [];
      List<String>? _test = pre.getStringList('BACKGROUND');
      if (_test != null) {
        save = _test;
      }
      save.add("[BackgroundFetch] BACK - TIME_OUT :: $taskId");
      await pre.setStringList('BACKGROUND', save);

      // <-- Task timeout handler.
      // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
      print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    });
    print('[BackgroundFetch] configure success: $status');
    setState(() {
      _status = status;
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  void _onClickEnable(enabled) {
    setState(() {
      _enabled = enabled;
    });
    if (enabled) {
      BackgroundFetch.start().then((int status) {
        print('[BackgroundFetch] start success: $status');
      }).catchError((e) {
        print('[BackgroundFetch] start FAILURE: $e');
      });
    } else {
      BackgroundFetch.stop().then((int status) {
        print('[BackgroundFetch] stop success: $status');
      });
    }
  }

  void _onClickStatus() async {
    int status = await BackgroundFetch.status;
    print('[BackgroundFetch] status: $status');
    setState(() {
      _status = status;
    });
  }

  Future<zone.TZDateTime> _timeZone(int index) async {
    zone.initializeTimeZones();
    zone.setLocalLocation(zone.getLocation('Asia/Seoul'));
    zone.TZDateTime _now = zone.TZDateTime.now(zone.local);
    zone.TZDateTime _schedule = zone.TZDateTime(zone.local, _now.year,
        _now.month, _now.day, _now.hour, 50 + index, _now.second);
    return _schedule;
  }

  // final EventChannel _notificationStreamWithTerminated =
  //     EventChannel("example/notification");

  @override
  Widget build(BuildContext context) {
    // _notificationStreamWithTerminated.receiveBroadcastStream().listen((event) {
    //   print(event);
    // });

    return MaterialApp(
      home: MainScreen(),
      // home: Scaffold(
      //   appBar: AppBar(
      //       title: const Text('BackgroundFetch Example',
      //           style: TextStyle(color: Colors.black)),
      //       backgroundColor: Colors.amberAccent,
      //       brightness: Brightness.light,
      //       leading: IconButton(
      //           onPressed: () {
      //             setState(() {
      //               showList = showList;
      //             });
      //           },
      //           icon: Icon(Icons.remove)),
      //       actions: <Widget>[
      //         Switch(value: _enabled, onChanged: _onClickEnable),
      //         IconButton(
      //             onPressed: () async {
      //               SharedPreferences? _pre =
      //                   await SharedPreferences.getInstance();
      //               showList = _pre.getStringList('BACKGROUND');
      //               print(showList);
      //               if (showList == null) {
      //                 showList = [];
      //               }
      //             },
      //             icon: Icon(Icons.abc)),
      //       ]),
      //   body: Container(
      //     color: Colors.pink.shade100,
      //     child: ListView(
      //       shrinkWrap: true,
      //       children: [
      //         GestureDetector(
      //             onTap: () async {
      //               // zone.TZDateTime _schedule = await _timeZone(1);
      //               // List<zone.TZDateTime> _list = [];
      //               FlutterLocalNotificationsPlugin _local =
      //                   FlutterLocalNotificationsPlugin();
      //               AndroidNotificationDetails _aos =
      //                   AndroidNotificationDetails('출석체크 루프', '출석체크 루프');
      //               IOSNotificationDetails _ios = IOSNotificationDetails(
      //                 presentAlert: true,
      //                 presentBadge: true,
      //                 presentSound: true,
      //               );
      //               for (int i = 0; i < 100; i++) {
      //                 zone.TZDateTime _test = await _timeZone(i + 1);
      //                 int _id = int.parse(
      //                     "${_test.year.toString().substring(2, 4)}${_test.month}${_test.day}${_test.hour}${_test.minute}");
      //                 // _list.add(_schedule.add(Duration(minutes: i)));
      //                 _local.zonedSchedule(
      //                   _id,
      //                   '$_id',
      //                   '$_id',
      //                   await _timeZone(i + 1),
      //                   NotificationDetails(android: _aos, iOS: _ios),
      //                   androidAllowWhileIdle: true,
      //                   uiLocalNotificationDateInterpretation:
      //                       UILocalNotificationDateInterpretation.absoluteTime,
      //                 );
      //               }

      //               // for (final e in _list) {
      //               //   print(e);
      //               //   int _test = int.parse(
      //               //       "${e.year}${e.month}${e.day}${e.hour}${e.minute}");
      //               //   print(_test);

      //               // }
      //             },
      //             child: Container(
      //                 width: 100,
      //                 height: 100,
      //                 child: Center(child: Text('NOTI')))),
      //         const SizedBox(height: 50),
      //         GestureDetector(
      //             onTap: () async {
      //               // FlutterAppBadger.updateBadgeCount(0);
      //               FlutterLocalNotificationsPlugin _local =
      //                   FlutterLocalNotificationsPlugin();
      //               List<PendingNotificationRequest> _list =
      //                   await _local.pendingNotificationRequests();
      //               for (final e in _list) {
      //                 print(e.id);
      //               }
      //             },
      //             child: Text('LIST')),
      //         const SizedBox(height: 50),
      //         GestureDetector(
      //             onTap: () {
      //               FlutterAppBadger.updateBadgeCount(0);
      //             },
      //             child: Text('RESET')),
      //         if (showList != null) ...[...showList!.map((e) => Text(e))],
      //         ...List.generate(_events.length, (index) {
      //           DateTime timestamp = _events[index];
      //           return Container(
      //             child: InputDecorator(
      //                 decoration: InputDecoration(
      //                     contentPadding: EdgeInsets.only(
      //                         left: 10.0, top: 10.0, bottom: 0.0),
      //                     labelStyle: TextStyle(
      //                         color: Colors.amberAccent, fontSize: 20.0),
      //                     labelText: "[background fetch event]"),
      //                 child: new Text(timestamp.toString(),
      //                     style:
      //                         TextStyle(color: Colors.white, fontSize: 16.0))),
      //           );
      //         }),
      //       ],
      //     ),
      //   ),
      //   bottomNavigationBar: BottomAppBar(
      //       child: Row(children: <Widget>[
      //     RaisedButton(onPressed: _onClickStatus, child: Text('Status')),
      //     Container(
      //         child: Text("$_status"), margin: EdgeInsets.only(left: 20.0))
      //   ])),
      // ),
    );
  }
}
