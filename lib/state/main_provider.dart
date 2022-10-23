import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class MainProvider extends ChangeNotifier {
  bool isSplash = true;
  String test = 'asdfdsf';

  void delayedSplash() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      isSplash = false;
      notifyListeners();
    });
  }
}
