import 'package:flutter/material.dart';

class MaintenanceScreen extends StatefulWidget {
  @override
  _MaintenanceScreenState createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(22, 22, 34, 1),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            Align(
              alignment:
                  Alignment.topLeft, 
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MaintenanceScreen(),
                    ), //alterar depois
                  );
                },
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color.fromARGB(255, 30, 30, 45),
                  ),
                  child: Center(
                    child: Transform.translate(
                      offset: Offset(5, 0),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            Text(
              'OPS!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 58,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Image.asset("assets/images/maintenance.png", width: 325),
            ),
            SizedBox(height: 12),
            Text(
              'Funcionalidade em Construção!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              'Volte em breve!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}