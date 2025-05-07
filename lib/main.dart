import 'package:bank_app/screens/cards.dart';
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'package:bank_app/screens/pix.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SafeCash',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PixScreen(),
    );
  }
}