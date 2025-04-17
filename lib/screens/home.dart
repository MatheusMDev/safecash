import 'package:bank_app/screens/cards.dart';
import 'package:bank_app/screens/maintenance.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Índice da tela ativa

  // Lista de telas que serão exibidas conforme o índice
  final List<Widget> _screens = [
    HomeContent(),
    MyCardsScreen(),
    MaintenanceScreen(),
    MaintenanceScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(22, 22, 34, 1),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: "Meu Cartão"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Estatísticas"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Configuração"),
        ],
      ),
      body: _screens[_selectedIndex], 
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            _buildBalanceCard(),
            SizedBox(height: 20),
            _buildActionButtons(),
            SizedBox(height: 20),
            _buildTransactionList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(backgroundImage: AssetImage('assets/avatar.jpg')),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Bem-vindo de volta", style: TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Poppins')),
                Text("Gabriel Silva",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        Icon(Icons.search, color: Colors.white),
      ],
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 30, 30, 45),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Saldo Total", style: TextStyle(color: Colors.grey, fontSize: 14)),
          SizedBox(height: 5),
          Text("R\$450,49",
              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Icon(Icons.visibility, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _actionButton(Icons.qr_code, "Área Pix"),
        _actionButton(Icons.send, "Transferir"),
        _actionButton(Icons.money, "Sacar"),
        _actionButton(Icons.account_balance_wallet, "Empréstimo"),
      ],
    );
  }

  Widget _actionButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: const Color.fromARGB(255, 30, 30, 45),
          radius: 30,
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        SizedBox(height: 5),
        Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  Widget _buildTransactionList() {
    return Expanded(
      child: ListView(
        children: [
          _transactionItem(Icons.apple, "Apple Store", "Entretenimento", "- R\$5,99"),
          _transactionItem(Icons.music_note, "Spotify", "Música", "- R\$12,99"),
          _transactionItem(Icons.pix, "PIX", "Transação", "+ R\$300,00", isPositive: true),
          _transactionItem(Icons.shopping_cart, "Doceria", "Shopping", "- R\$88,00"),
        ],
      ),
    );
  }

  Widget _transactionItem(IconData icon, String title, String subtitle, String value,
      {bool isPositive = false}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color.fromARGB(255, 30, 30, 45),
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey)),
      trailing: Text(value,
          style: TextStyle(
            color: isPositive ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          )),
    );
  }
}
