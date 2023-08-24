import 'package:flutter/material.dart';
import 'package:i_health/initlizer.dart';
import 'package:i_health/views/home_screen.dart';

void main() async {
  await Initilizer.initFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iHealth',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}
