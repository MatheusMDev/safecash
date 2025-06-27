import 'dart:async';
import 'package:bank_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bank_app/screens/information.dart'; // ajuste o caminho conforme o seu projeto

class FaceRecognitionScreen extends StatefulWidget {
  @override
  _FaceRecognitionScreenState createState() => _FaceRecognitionScreenState();
}

class _FaceRecognitionScreenState extends State<FaceRecognitionScreen> {
  @override
  void initState() {
    super.initState();

    // Timer para ir à próxima tela após 3 segundos
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // opcional: muda o fundo
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(FontAwesomeIcons.faceSmileBeam, color: Colors.white, size: 50),
            SizedBox(height: 20),
            Text(
              'Reconhecimento Facial',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
