import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alarm_app/state/main_provider.dart';
import 'package:flutter_alarm_app/ui/splash_screen.dart';
import 'package:flutter_alarm_app/ui/test_case.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainProvider>(
      create: (_) => MainProvider()..delayedSplash(),
      child: Consumer<MainProvider>(
        builder: (context, p, child) {
          if (p.isSplash) {
            return const SplashScreen();
          } else {
            return Scaffold(
              backgroundColor: const Color.fromRGBO(51, 51, 51, 1),
              appBar: AppBar(
                centerTitle: false,
                title: const Text(
                  'Alarm App',
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: ((context) => TestCase())));
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.deepOrange,
                      ))
                ],
                backgroundColor: const Color.fromRGBO(51, 51, 51, 1),
              ),
              body: Text(p.test),
            );
          }
        },
      ),
    );
  }
}
