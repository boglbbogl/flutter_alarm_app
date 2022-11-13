import 'package:flutter/material.dart';

class ShowScreen extends StatelessWidget {
  const ShowScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(title: Text('SHOW')),
    );
  }
}
