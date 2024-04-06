import 'package:flash/homeScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FlashLight App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const homescreen(),
    );
  }
}
