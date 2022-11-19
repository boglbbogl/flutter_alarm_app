import 'package:flutter/material.dart';

class SwiftNativeView extends StatelessWidget {
  const SwiftNativeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Native View'),
      ),
      body: UiKitView(
        viewType: 'gyeom-type',
        layoutDirection: TextDirection.ltr,
      ),
    );
  }
}
