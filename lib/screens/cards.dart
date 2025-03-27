import 'package:bank_app/screens/maintenance.dart';
import 'package:flutter/material.dart';

class MyCardsScreen extends StatefulWidget {
  @override
  _MyCardsScreenState createState() => _MyCardsScreenState();
}

class _MyCardsScreenState extends State<MyCardsScreen> {
  double _spendingLimit = 8545.00;

  Widget _buildTransactionIcon(IconData icon) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color.fromARGB(255, 30, 30, 45),
      ),
      child: Center(child: Icon(icon, color: Colors.grey, size: 18)),
    );
  }

  void _increaseLimit() {
    setState(() {
      _spendingLimit += 500.00;
    });
  }

  void _decreaseLimit() {
    setState(() {
      if (_spendingLimit > 500.00) {
        _spendingLimit -= 500.00;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(22, 22, 34, 1),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 52,
                      height: 52,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MaintenanceScreen(),
                            ),
                          );
                        },
                        child: Container(
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
                    Text(
                      'Meu Cartão',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(
                      width: 52,
                      height: 52,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MaintenanceScreen(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromARGB(255, 30, 30, 45),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: 350,
                    child: Image.asset(
                      "assets/images/card.png",
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Extrato',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    GestureDetector(
                      behavior:
                          HitTestBehavior
                              .opaque, 
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MaintenanceScreen(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: Text(
                          'Ver Tudo',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildTransactionIcon(Icons.shopping_bag_outlined),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Apple Store',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              'Entretenimento',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '- R\$5,99',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildTransactionIcon(Icons.music_note_outlined),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Spotify',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              'Música',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '- R\$12,99',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildTransactionIcon(Icons.shopping_cart_outlined),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Doceria',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              'Restaurante',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '- R\$87,99',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildTransactionIcon(Icons.shopping_cart_outlined),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Makisu Dhama',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              'Restaurante',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '- R\$189,99',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 30, 30, 45),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Limite de gastos mensais',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Valor: R\$ ${_spendingLimit.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: _decreaseLimit,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[700],
                                  ),
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: _increaseLimit,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blueAccent,
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          double progress = _spendingLimit / 10000;
                          if (progress > 1.0) progress = 1.0;
                          return Container(
                            width: constraints.maxWidth,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: constraints.maxWidth * progress,
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IgnorePointer(
           child: Positioned(
              bottom: 225,
              right: 0,
              child: Transform.translate(
                offset: Offset(400, 120),
                child: Image.asset(
                  "assets/images/ellipse.png",
                  width: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),        
        ],
      ),
    );
  }
}
