import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MainProvider extends ChangeNotifier {
  bool isSplash = true;
  String test = 'asdfdsf';
  String test2 = 'router test';

  void getTest(String v) {
    test2 = v;
    notifyListeners();
  }

  void refresh() => notifyListeners();

  void delayedSplash() {
    // _initLocalNotification();
    Future.delayed(const Duration(milliseconds: 2000), () {
      isSplash = false;
      notifyListeners();
    });
  }
}
