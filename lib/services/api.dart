import 'package:http/http.dart' as http;
import 'dart:convert';

// Função para pegar idtoken
Future<String?> captureIDToken(String email, String password) async {
  // URL do Firebase Authentication para autenticar com email e senha
  final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCHDutXuKV_39WzRs9dvt0VN79iREvIjnI');

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

Future<bool> registerFace(String idToken, List<String> imageBase64) async {
  final url = Uri.parse('http://localhost:8000/register-face');

  final body = jsonEncode({
    'idToken': idToken,
    'images_base64': imageBase64,
  });

  final headers = {'Content-Type': 'application/json'};

  try {
    print('➡️ Enviando para /register-face: $body');

    final response = await http.post(url, headers: headers, body: body);

    print('⬅️ Resposta /register-face: '
        '${response.statusCode} | ${response.body}');

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Erro ao registrar face: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Erro na requisição: $e');
    return false;
  }
}
