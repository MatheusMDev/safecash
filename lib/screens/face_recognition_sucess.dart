import 'package:bank_app/screens/home.dart';
import 'package:flutter/material.dart';

import 'dart:async';

class FaceRecognitionSucess extends StatefulWidget {
  const FaceRecognitionSucess({super.key});

  @override
  State<FaceRecognitionSucess> createState() =>
      _FaceRecognitionSucessState();
}

class _FaceRecognitionSucessState
    extends State<FaceRecognitionSucess> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
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
              'Face Autenticada com sucesso!\nVocê será redirecionado em segundos...',
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
              color: Colors.greenAccent.withOpacity(0.05 * (4 - i)),
            ),
          ),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.greenAccent.withOpacity(0.2),
          ),
          child: Icon(Icons.check, color: Colors.white, size: 40),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen()));
}
