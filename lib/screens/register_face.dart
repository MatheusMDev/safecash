import 'package:bank_app/screens/face_recognition.dart';
import 'package:bank_app/screens/home.dart';
import 'package:flutter/material.dart';

class RegisterFaceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(22, 22, 34, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaceIDDesign(),
            const SizedBox(height: 15),
            const Text(
              "Use o Reconhecimento Facial para\n autorizar pagamentos e desbloquear seu aplicativo",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Com o Reconhecimento Facial ativado, você evita a inclusão da sua senha toda vez que quiser enviar dinheiro!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 45,
              width: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 102, 255, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FaceRecognitionScreen()));
                },
                child: const Text(
                  'Cadastrar Face ID',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 45,
              width: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                },
                child: const Text(
                  'Deixar para depois',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FaceIDDesign extends StatelessWidget {
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
          child: Image.asset(
            "assets/images/face_id.png",
            width: 30, 
            height: 30, 
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RegisterFaceScreen(),
  ));
}
