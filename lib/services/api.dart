import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

Future<String?> getIdToken() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Obtém o idToken do usuário logado
      String? idToken = await user.getIdToken();
      return idToken;
    }
  } catch (e) {
    print('Erro ao obter idToken: $e');
  }
  return null;
}

Future<bool> verifyIdToken(String idToken, String apiKey) async {
  final url = Uri.parse(
    'https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=AIzaSyCHDutXuKV_39WzRs9dvt0VN79iREvIjnI',
  );

  // Faz a requisição POST com o ID Token
  final response = await http.post(
    url,
    body: json.encode({'idToken': idToken}),
    headers: {'Content-Type': 'application/json'},
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

Future<bool> registerFace(String idToken, List<String> imageBase64) async {
  final url = Uri.parse(
    'http://localhost:8000/register-face',
  ); // URL do servidor local

  // Estrutura do corpo da requisição
  final body = jsonEncode({'idToken': idToken, 'images_base64': imageBase64});

  // Cabeçalhos da requisição
  final headers = {'Content-Type': 'application/json'};

  try {
    // Realiza a requisição POST
    final response = await http.post(url, headers: headers, body: body);

    // Verifica se a resposta é bem-sucedida
    if (response.statusCode == 200) {
      return true; // Sucesso
    } else {
      print('Erro ao registrar face: ${response.statusCode}');
      return false; // Falha na requisição
    }
  } catch (e) {
    print('Erro na requisição: $e');
    return false; // Erro no processo de requisição
  }
}
