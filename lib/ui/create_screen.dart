import 'package:flutter/material.dart';

class CreateScreen extends StatelessWidget {
  const CreateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(51, 51, 51, 1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 50,
            color: Colors.deepOrange,
            child: Text('adskfjdsljf'),
          )
        ],
      ),
    );
  }
}
