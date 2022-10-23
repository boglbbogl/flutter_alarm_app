import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(31, 31, 31, 1),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
