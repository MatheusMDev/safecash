import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

// Função para realizar o login com email e senha
Future<String?> loginWithEmailAndPassword(String email, String password) async {
  // URL do Firebase Authentication para autenticar com email e senha
  final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDXMaZaGsPa3ajobec1c9FK0G-yCqSTMDE');

  // Requisição POST para autenticar com o email e senha
  final response = await http.post(
    url,
    body: json.encode({
      'email': email,  // Aqui você passa o email real
      'password': password,  // Senha do usuário
      'returnSecureToken': true,  // Garantir que o token seja retornado
    }),
    headers: {
      'Content-Type': 'application/json',  // Definir o tipo de conteúdo
    },
  );

  if (response.statusCode == 200) {
    // Se a autenticação for bem-sucedida, pega o idToken da resposta
    final Map<String, dynamic> responseData = json.decode(response.body);
    return responseData['idToken'];  // Retorna o idToken
  } else {
    // Caso contrário, imprime a mensagem de erro
    print('Erro ao autenticar: ${response.statusCode}');
    return null;
  }
}



Future<bool> verifyIdToken(String idToken, String apiKey) async {
  final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=AIzaSyDXMaZaGsPa3ajobec1c9FK0G-yCqSTMDE');

  // Faz a requisição POST com o idToken
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
    // Se o ID token for válido
    print('ID Token verificado com sucesso!');
    return true;
  } else {
    // Se o ID token for inválido
    print('Falha na verificação do ID Token: ${response.statusCode}');
    return false;
  }
}



