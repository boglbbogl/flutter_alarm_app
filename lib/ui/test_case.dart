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
              child: ListView(
                children: [
                  _button(
                      onTap: () {
                        value.checked();
                      },
                      title: '알림 정보 확인'),
                  _button(
                      onTap: () {
                        value.showPushAlarm();
                      },
                      title: '즉시 전송(일회성)'),
                  _button(
                      onTap: () {
                        value.selectedDatePushAlarm();
                      },
                      title: '특정 날짜/시간대 전송'),
                  _button(
                      onTap: () {
                        value.loopPushAlarm(0);
                      },
                      title: '매일 전송'),
                  _button(
                      onTap: () {
                        value.loopPushAlarm(1);
                      },
                      title: '주/월간 정송'),
                  _button(
                      onTap: () {
                        value.badgeTest();
                      },
                      title: '배지 카운트 테스트'),
                  _button(
                      onTap: () async {
                        value.unSubscripe();
                      },
                      title: '전송 취소'),
                  ...value.notifications.map((e) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Container(
                          color: Colors.black45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DefaultTextStyle(
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(e.id.toString()),
                                  Text(
                                    e.payload.toString(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))
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
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
