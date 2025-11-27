import 'dart:convert';
import 'package:bank_app/widgets/create_user.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:bank_app/services/api.dart'; // Importar a função de API

class RegisterFaceScreenRecognition extends StatefulWidget {
  const RegisterFaceScreenRecognition({super.key, this.cpf});

  final String? cpf;

  @override
  _RegisterFaceScreenState createState() => _RegisterFaceScreenState();
}

class _RegisterFaceScreenState extends State<RegisterFaceScreenRecognition> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  bool _isLoading = false;
  bool _isCameraReady = false;
  bool _isCaptured = false;
  // ignore: unused_field
  final UserController _userController = UserController();
  final List<String> _capturedImages = [];
  String? _idToken; // Variável para armazenar o idToken do login

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

  void _checkCameraPermission() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _initializeCamera();
    }
  }

  void _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;
      _cameraController = CameraController(firstCamera, ResolutionPreset.high);
      _initializeControllerFuture = _cameraController.initialize();
      await _initializeControllerFuture;
      setState(() {
        _isCameraReady = true;
      });
    } catch (e) {
      print("Erro ao inicializar a camera: $e");
    }
  }

  // Função para capturar a foto e enviar para a API
  void _capturePhoto() async {
    if (_isLoading) return;

    try {
      setState(() {
        _isCaptured = true;
        _isLoading = true;
      });

      await _initializeControllerFuture;

      final image = await _cameraController.takePicture();

      // Converte a imagem para Base64
      final imageBytes = await image.readAsBytes();
      final imageBase64 = base64Encode(imageBytes);
      
      // Adiciona a imagem Base64 à lista
      _capturedImages.add(imageBase64);

      // Verifica se o idToken está disponível (deve ser salvo após o login)
      if (_idToken != null) {
        final success = await registerFace(_idToken!, _capturedImages);
        if (success) {
          print('Face registrada com sucesso!');
        } else {
          print('Falha ao registrar a face.');
        }
      } else {
        print('Erro: idToken não encontrado!');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Erro ao capturar a foto: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(22, 22, 34, 1),
      body:
          _isCameraReady
              ? Stack(
                children: [
                  // Exibe a visualizacao da camera
                  Positioned.fill(child: CameraPreview(_cameraController)),
                  // Exibe o oval dinamico e a sombra fora dele
                  Positioned.fill(
                    child: TweenAnimationBuilder<Size?>(
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOut,
                      tween: SizeTween(
                        end:
                            _isCaptured
                                ? const Size(440, 540)
                                : const Size(380, 480),
                      ),
                      builder: (context, value, _) {
                        final ovalContainerSize = value ?? const Size(260, 340);
                        return CustomPaint(
                          painter: _OvalOverlayPainter(
                            clipper: _OvalClipper(),
                            containerSize: ovalContainerSize,
                          ),
                          child: const SizedBox.expand(),
                        );
                      },
                    ),
                  ),
                  // Exibe o botao de captura
                  Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SizedBox(
                        width: 200,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _capturePhoto,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(
                              0,
                              102,
                              255,
                              1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Prosseguir',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Mostra um indicador de carregamento enquanto o processo de captura esta em andamento
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator()),
                ],
              )
              : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Aguarde enquanto solicitamos permissao para acessar a camera...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
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
                        onPressed:
                            _checkCameraPermission, // Botao que tenta acessar a camera
                        child: const Text(
                          'Conceder Permissao',
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
              ),
    );
  }
}

// Custom Clipper for the oval shape
class _OvalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double width = size.width * 0.7; // Ajuste a largura do oval
    double height = size.height * 0.8; // Ajuste a altura do oval

    return Path()..addOval(
      Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: width,
        height: height,
      ),
    );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class _OvalOverlayPainter extends CustomPainter {
  _OvalOverlayPainter({required this.clipper, required this.containerSize});

  final _OvalClipper clipper;
  final Size containerSize;

  @override
  void paint(Canvas canvas, Size size) {
    final path = clipper
        .getClip(containerSize)
        .shift(
          Offset(
            (size.width - containerSize.width) / 2,
            (size.height - containerSize.height) / 2,
          ),
        );

    final overlay =
        Path()
          ..fillType = PathFillType.evenOdd
          ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
          ..addPath(path, Offset.zero);

    canvas.drawPath(overlay, Paint()..color = Colors.black.withOpacity(0.8));

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = const Color.fromRGBO(0, 102, 255, 1),
    );
  }

  @override
  bool shouldRepaint(covariant _OvalOverlayPainter oldDelegate) {
    return oldDelegate.containerSize != containerSize;
  }
}
