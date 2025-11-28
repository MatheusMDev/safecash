import 'package:bank_app/screens/face_recognition.dart';
import 'package:bank_app/screens/information.dart';
import 'package:bank_app/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bank_app/services/api.dart';
import '../widgets/create_user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;

  // >>> ADICIONE:
  final _cpfCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  final _userController = UserController();
  bool _loading = false;

  @override
  void dispose() {
    _cpfCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final cpf = _cpfCtrl.text.trim();
    final pw = _pwCtrl.text;

    if (cpf.isEmpty || pw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Informe CPF e senha',
            style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
          ),
          backgroundColor: const Color(0xFFFFF59D), // amarelo pastel
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() => _loading = true);

    // Chama a função de verificação do idToken aqui
    String email = "teste@teste.com"; // Email do usuário
    String password = "123456"; // Senha do usuário

    String? idToken = await captureIDToken(email, password);
    if (idToken != null) {
      print("Login bem-sucedido! idToken: $idToken");
    } else {
        print("Erro no login, IdToken");
    }

    // Agora, continue com o login no Firestore
    final user = await _userController.login(cpf, pw);
    setState(() => _loading = false);

    if (!mounted) return;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'CPF ou senha incorretos',
            style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    // Sucesso: navega para a tela de face
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => FaceRecognitionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(22, 22, 34, 1),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InformationScreen()),
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
            const SizedBox(height: 75),
            const Text(
              'Entrar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 40),

            // ===== CPF =====
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CPF',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _cpfCtrl, // <<< LIGA AQUI
                  keyboardType: TextInputType.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                  decoration: InputDecoration(
                    hintText: 'Digite seu CPF',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Poppins',
                    ),
                    prefixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(FontAwesomeIcons.solidIdCard, color: Colors.white),
                        SizedBox(width: 10),
                      ],
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 1.0,
              color: const Color.fromARGB(38, 158, 158, 158),
              margin: const EdgeInsets.only(top: 5.0),
            ),
            const SizedBox(height: 40),

            // ===== SENHA =====
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Senha',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _pwCtrl, // <<< LIGA AQUI
                  obscureText: _obscureText,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                  decoration: InputDecoration(
                    hintText: 'Digite sua senha',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Poppins',
                    ),
                    prefixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.lock_outline, color: Colors.white),
                        SizedBox(width: 10),
                      ],
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.remove_red_eye_outlined
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed:
                          () => setState(() => _obscureText = !_obscureText),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 1.0,
              color: const Color.fromARGB(38, 158, 158, 158),
              margin: const EdgeInsets.only(top: 5.0),
            ),

            const SizedBox(height: 20),

            // ===== BOTÃO ENTRAR =====
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 45,
                  width: 300,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(0, 102, 255, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: _loading ? null : _handleLogin, // <<< LOGIN
                    child:
                        _loading
                            ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Text(
                              'Entrar',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ===== LINK CADASTRAR =====
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text(
                      'É novo aqui?',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 3),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Cadastre-se',
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
              ],
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
