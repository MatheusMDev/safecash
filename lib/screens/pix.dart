import 'package:flutter/material.dart';
import 'maintenance.dart';

class PixScreen extends StatefulWidget {
  @override
  _PixScreenState createState() => _PixScreenState();
}

class _PixScreenState extends State<PixScreen> {
  int? indiceContatoSelecionado; // Armazena o índice do contato selecionado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(22, 22, 34, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(22, 22, 34, 1),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color.fromARGB(255, 255, 255, 255)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Pix",
          style: TextStyle(
            color: Colors.white, // Cor do texto (branco)
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _construirCartaoSaldo(),
            SizedBox(height: 20),
            Text(
              "Enviar para",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),
            _construirListaContatos(),
            SizedBox(height: 20),
            _construirCampoValor(),
            SizedBox(height: 20),
            _construirBotaoEnviar(),
          ],
        ),
      ),
    );
  }

  // Cartão com o saldo atual e dados da conta
  Widget _construirCartaoSaldo() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color.fromARGB(38, 246, 246, 246),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text("Saldo Atual",
              style: TextStyle(
                  color: const Color.fromARGB(200, 255, 255, 255), fontSize: 14)),
          SizedBox(height: 5),
          Text("R\$450,49",
              style: TextStyle(
                  fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white),
            ),
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("assets/images/Gabriel.png"),
                  radius: 20,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Gabriel Silva",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Text("Nubank - 0987 3422 8756",
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Lista horizontal de contatos
  Widget _construirListaContatos() {
    final List<Map<String, dynamic>> contatos = [
      {"nome": "Adicionar", "icone": Icons.add},
      {"nome": "Matheus", "imagem": "assets/images/Matheus.png"},
      {"nome": "Vinicius", "imagem": "assets/images/Vinicius.png"},
      {"nome": "Iago", "imagem": "assets/images/Iago.png"},
      {"nome": "Felipe", "imagem": "assets/images/Felipe.png"},
    ];

    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: contatos.length,
        separatorBuilder: (context, index) => SizedBox(width: 10),
        itemBuilder: (context, index) {
          final contato = contatos[index];
          final isSelected = indiceContatoSelecionado == index;

          return GestureDetector(
            onTap: () {
              if (index == 0) {
                // Se for o botão "Adicionar", redireciona para a tela de manutenção
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MaintenanceScreen(),
                  ),
                );
              } else {
                // Seleciona o contato clicado
                setState(() {
                  indiceContatoSelecionado = index;
                });
              }
            },
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    contato.containsKey("icone")
                        ? CircleAvatar(
                            backgroundColor: Colors.grey[800],
                            radius: 25,
                            child: Icon(contato["icone"], color: Colors.white),
                          )
                        : CircleAvatar(
                            backgroundImage: AssetImage(contato["imagem"]),
                            radius: 25,
                          ),
                    if (isSelected && index != 0)
                      CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.3),
                        radius: 28,
                      ),
                  ],
                ),
                SizedBox(height: 5),
                Text(contato["nome"],
                    style: TextStyle(fontSize: 12, color: Colors.white)),
              ],
            ),
          );
        },
      ),
    );
  }

  // Campo para digitar o valor a ser enviado
  Widget _construirCampoValor() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E2D),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Insira o valor",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF9CB1D1),
            ),
          ),
          TextField(
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: 20, color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixText: "R\$ ",
              prefixStyle: TextStyle(fontSize: 20, color: Colors.white),
              hintText: "0,00",
              hintStyle: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
        ],
      ),
    );
  }

  // Botão de enviar
  Widget _construirBotaoEnviar() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {
          // Lógica de envio aqui
        },
        child: Text("Enviar",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
