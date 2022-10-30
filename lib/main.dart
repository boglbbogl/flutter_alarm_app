import 'package:flutter/material.dart';
import 'package:flutter_alarm_app/ui/main_screen.dart';

void main() {
  runApp(const MyApp());
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
    );
  }
}
