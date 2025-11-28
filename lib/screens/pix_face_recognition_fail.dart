import 'package:bank_app/screens/home.dart';
import 'package:bank_app/screens/login.dart';
import 'package:flutter/material.dart';

import 'dart:async';

class PixFaceRecognitionFail extends StatefulWidget {
  const PixFaceRecognitionFail({super.key});

  @override
  State<PixFaceRecognitionFail> createState() =>
      _PixFaceRecognitionFailState();
}

class _PixFaceRecognitionFailState extends State<PixFaceRecognitionFail> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(22, 22, 34, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaceRecognitionSuces(),
            const SizedBox(height: 20),
            // Texto abaixo do ícone
            const Text(
              'Essa tentativa foi considerada um Deepfake!\nPix não enviado!\nUm alerta foi enviado à instituição!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FaceRecognitionSuces extends StatelessWidget {
  const FaceRecognitionSuces({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        for (int i = 0; i < 4; i++)
          AnimatedContainer(
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            width: 80.0 + (i * 60),
            height: 80.0 + (i * 60),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromARGB(
                255,
                240,
                105,
                105,
              ).withOpacity(0.05 * (4 - i)),
            ),
          ),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color.fromARGB(255, 240, 105, 105).withOpacity(0.2),
          ),
          child: Icon(Icons.close, color: Colors.white, size: 40),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen()));
}