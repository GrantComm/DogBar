import 'package:flutter/material.dart';
import 'screens/homeScreen.dart';
import 'screens/resultScreen.dart';

void main() {
  runApp(const DogBar());
}

class DogBar extends StatelessWidget {
  const DogBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DogBar',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
