import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

Future<String?> getIdToken() async { //aqui é um verify
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Obtém o idToken do usuário logado
      String? idToken = await user.getIdToken();
      return idToken; 
    } else {
      print('Nenhum usuário logado');
      return null;
    }
  } catch (e) {
    print('Erro ao obter idToken: $e');
    return null;
  }
}

Future<bool> verifyIdToken(String idToken, String apiKey) async {  // aqui é um get
  final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=AIzaSyCHDutXuKV_39WzRs9dvt0VN79iREvIjnI');

  // Faz a requisição POST com o ID Token
  final response = await http.post(
    url,
    body: json.encode({
      'idToken': idToken,
    }),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    // Sucesso: A resposta é válida
    print('ID Token verificado com sucesso!');
    return true;
  } else {
    // Falha: ID Token inválido
    print('Falha na verificação do ID Token: ${response.statusCode}');
    return false;
  }
}
