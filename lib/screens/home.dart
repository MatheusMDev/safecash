import 'package:bank_app/screens/cards.dart';
import 'package:bank_app/screens/maintenance.dart';
import 'package:bank_app/screens/pix.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Inter'),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1C2E),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildBalanceCard(),
            _buildActionIcons(),
            Expanded(child: _buildTransactionsSection()),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/Gabriel.png'),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bem-vindo de volta',
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                  const Text(
                    'Gabriel Silva',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MaintenanceScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(Icons.search, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFF1C1C2E),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'assets/images/world.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Saldo Total',
                  style: TextStyle(color: Colors.grey[300], fontSize: 14),
                ),
                SizedBox(height: 10),
                Text(
                  _isVisible ? 'R\$12.286,49' : '••••••',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isVisible = !_isVisible;
                });
              },
              child: Icon(
                _isVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey[300],
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionIcon(Icons.pix, 'Área Pix', PixScreen()),
          _buildActionIcon(Icons.send, 'Transferir', MaintenanceScreen()),
          _buildActionIcon(
            Icons.account_balance_wallet,
            'Sacar',
            MaintenanceScreen(),
          ),
          _buildActionIcon(
            Icons.receipt_long,
            'Empréstimo',
            MaintenanceScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, String label, Widget targetScreen) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => targetScreen),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 30, 30, 45),
            radius: 30,
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          SizedBox(height: 5),
          Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildTransactionsSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Extrato',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MaintenanceScreen()),
                  );
                },
                child: Text(
                  'Ver tudo',
                  style: TextStyle(
                    color: Colors.blue[400],
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildTransactionItem(
                  Icons.apple,
                  Colors.black,
                  'Apple Store',
                  'Entretenimento',
                  '- R\$5,99',
                  Colors.red[400]!,
                ),
                SizedBox(height: 12),
                _buildTransactionItem(
                  Icons.music_note,
                  Colors.green[600]!,
                  'Spotify',
                  'Música',
                  '- R\$12,99',
                  Colors.red[400]!,
                ),
                SizedBox(height: 12),
                _buildTransactionItem(
                  Icons.download,
                  Colors.grey[600]!,
                  'PIX',
                  'Transação',
                  'R\$300,00',
                  Colors.blue[400]!,
                ),
                SizedBox(height: 12),
                _buildTransactionItem(
                  Icons.shopping_cart,
                  Colors.red[500]!,
                  'Doceria',
                  'Shopping',
                  '- R\$ 88,00',
                  Colors.red[400]!,
                ),
                SizedBox(height: 12),
                _buildTransactionItem(
                  Icons.download,
                  Colors.grey[600]!,
                  'PIX',
                  'Transação',
                  'R\$5.000,00',
                  Colors.blue[400]!,
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
    IconData icon,
    Color iconBgColor,
    String title,
    String subtitle,
    String amount,
    Color amountColor,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: amountColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF2A2A3C),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[400],
        unselectedItemColor: Colors.grey[400],
        selectedFontSize: 12,
        unselectedFontSize: 12,
        currentIndex: 0, // Sempre "Home" selecionado visualmente
        onTap: (index) {
          if (index == 0) return;

          Widget screen;
          switch (index) {
            case 1:
              screen = MyCardsScreen(); // Aqui está sua tela de cartão!
              break;
            case 2:
              screen = MaintenanceScreen();
              break;
            case 3:
              screen = MaintenanceScreen();
              break;
            default:
              screen = MaintenanceScreen();
          }

          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'My Cards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
