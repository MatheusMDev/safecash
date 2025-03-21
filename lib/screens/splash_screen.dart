import 'dart:async';
import 'package:bank_app/screens/information.dart';
import 'package:flutter/material.dart';
import 'package:bank_app/screens/register_face.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => InformationScreen()));
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
            Image.asset("assets/images/safecash_logo.png", width: 200),
            const SizedBox(height: 8),
            Text(
              "SAFECASH",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 15), 
            CircularProgressIndicator(
              color: Colors.white,
            ), // Indicador de carregamento
          ],
        ),
      ),
    );
  }
}
