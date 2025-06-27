import 'package:bank_app/screens/home.dart';
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

 
  void _increaseLimit() => setState(() => _spendingLimit += 500.00);
  void _decreaseLimit() =>
      setState(() => _spendingLimit = _spendingLimit > 500 ? _spendingLimit - 500 : _spendingLimit);

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
                const SizedBox(height: 10),

                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Meu Cartão',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Poppins'),
                    ),
                    // Botão "+"
                    _circleButton(
                      icon: Icons.add,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MaintenanceScreen()),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // ---------- Cartão ----------
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: 350,
                    child: Image.asset("assets/images/card.png", fit: BoxFit.fitWidth),
                  ),
                ),

                const SizedBox(height: 25),

                // ---------- Extrato + Ver tudo ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Extrato',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Poppins'),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MaintenanceScreen()),
                      ),
                      child: const Text(
                        'Ver Tudo',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ---------- Itens do extrato ----------
                _transactionRow(Icons.shopping_bag_outlined, 'Apple Store', 'Entretenimento', '- R\$5,99'),
                _transactionRow(Icons.music_note_outlined, 'Spotify', 'Música', '- R\$12,99'),
                _transactionRow(Icons.shopping_cart_outlined, 'Doceria', 'Restaurante', '- R\$87,99'),
                _transactionRow(Icons.shopping_cart_outlined, 'Makisu Dhama', 'Restaurante', '- R\$189,99'),

                const SizedBox(height: 30),

                // ---------- Limite de gastos ----------
                _spendingLimitCard(),
              ],
            ),
          ),

          // ---------- Imagem de fundo decorativa ----------
          IgnorePointer(
            child: Positioned(
              bottom: 225,
              right: 0,
              child: Transform.translate(
                offset: const Offset(400, 120),
                child: Image.asset("assets/images/ellipse.png", width: 200, fit: BoxFit.contain),
              ),
            ),
          ),
        ],
      ),

      // ------------- BOTTOM NAVIGATION ---------------
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // ============  BOTTOM NAVIGATION BAR ==============
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF2A2A3C),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[400],
        unselectedItemColor: Colors.grey[400],
        selectedFontSize: 12,
        unselectedFontSize: 12,
        currentIndex: 1, // "My Cards" aparece selecionado
        onTap: (index) {
          switch (index) {
            case 0: // Home
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()),
              );
              break;
            case 1: // Já está em My Cards, não faz nada
              break;
            case 2: // Statistics
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MaintenanceScreen()),
              );
              break;
            case 3: // Settings
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MaintenanceScreen()),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: 'My Cards'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Statistics'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  // ============  WIDGETS DE APOIO  ==================
  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return SizedBox(
      width: 52,
      height: 52,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color: const Color.fromARGB(255, 30, 30, 45)),
          child: Center(child: Icon(icon, color: Colors.white, size: 20)),
        ),
      ),
    );
  }

  Widget _transactionRow(IconData icon, String title, String subtitle, String amount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildTransactionIcon(icon),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                  Text(subtitle,
                      style: const TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Poppins')),
                ],
              ),
            ],
          ),
          Text(amount,
              style: TextStyle(color: Colors.red[400], fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
        ],
      ),
    );
  }

  Widget _spendingLimitCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 30, 30, 45),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Limite de gastos mensais',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Poppins')),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Valor: R\$ ${_spendingLimit.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Poppins')),
          Row(children: [
            _circleButton(icon: Icons.remove, onTap: _decreaseLimit),
            const SizedBox(width: 10),
            _circleButton(icon: Icons.add, onTap: _increaseLimit),
          ]),
        ]),
        const SizedBox(height: 15),
        LayoutBuilder(builder: (context, constraints) {
          double progress = (_spendingLimit / 10000).clamp(0.0, 1.0);
          return Container(
            width: constraints.maxWidth,
            height: 8,
            decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(4)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: constraints.maxWidth * progress,
                decoration:
                    BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(4)),
              ),
            ),
          );
        }),
      ]),
    );
  }
}
