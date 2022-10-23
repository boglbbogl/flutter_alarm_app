import 'package:flutter/material.dart';
import 'package:flutter_alarm_app/state/test_provider.dart';
import 'package:provider/provider.dart';

class TestCase extends StatelessWidget {
  const TestCase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TestProvider>(
      create: (_) => TestProvider(),
      child: Consumer<TestProvider>(
        builder: (context, value, child) {
          return Scaffold(
            backgroundColor: const Color.fromRGBO(51, 51, 51, 1),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _button(onTap: () {}, title: '즉시 전송(일회성)'),
                  _button(onTap: () {}, title: '특정 날짜/시간대 전송'),
                  _button(onTap: () {}, title: '매일 전송'),
                  _button(onTap: () {}, title: '주/월간 정송'),
                  _button(onTap: () {}, title: '전송 취소'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Padding _button({
    required Function() onTap,
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 250,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.deepOrange,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
