import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alarm_app/main.dart';
import 'package:flutter_alarm_app/state/main_provider.dart';
import 'package:flutter_alarm_app/ui/splash_screen.dart';
import 'package:flutter_alarm_app/ui/test_case.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // const counterChannel = EventChannel('samples.flutter.dev/counter');

    return ChangeNotifierProvider<MainProvider>(
      create: (_) => MainProvider()..delayedSplash(),
      child: Consumer<MainProvider>(
        builder: (context, p, child) {
          if (p.isSplash) {
            return const SplashScreen();
          } else {
            // counterChannel.receiveBroadcastStream().listen((event) {
            //   print(event);
            // });
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
              body: Column(
                children: [
                  Text(p.test),
                  GestureDetector(
                      onTap: () async {
                        NaverLoginResult? _result =
                            await FlutterNaverLogin.logIn();
                        print(_result.accessToken.accessToken);
                        print(_result.account.email);
                      },
                      child: Container(
                        color: Colors.amber,
                        width: 100,
                        height: 30,
                        child: const Text('naver'),
                      )),
                  GestureDetector(
                      onTap: () async {
                        p.refresh();
                      },
                      child: Container(
                        color: Colors.red,
                        width: 100,
                        height: 30,
                        child: Text('router'),
                      )),
                  GestureDetector(
                      onTap: () async {
                        p.getTest('router');
                      },
                      child: Container(
                        color: Colors.green,
                        width: 100,
                        height: 30,
                        child: Text('router'),
                      )),
                  GestureDetector(
                      onTap: () async {},
                      child: Container(
                        color: Colors.purple,
                        width: 100,
                        height: 30,
                        child: Text('router'),
                      )),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
