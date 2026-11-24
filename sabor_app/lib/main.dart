import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(const SaborApp());

class SaborApp extends StatelessWidget {
  const SaborApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SaborApp',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
