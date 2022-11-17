import 'package:flutter/material.dart';

class SwiftNativeView extends StatelessWidget {
  const SwiftNativeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Stack(
          children: [
            // UiKitView(
            //   viewType: 'gyeom-type',
            //   layoutDirection: TextDirection.ltr,

            // ),
            Container(
              color: Colors.amber.withOpacity(0.3),
              child: ListView(children: [
                ...List.generate(1000, (index) => Text(index.toString()))
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
