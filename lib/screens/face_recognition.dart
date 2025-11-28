import 'dart:convert';
import 'package:bank_app/screens/register_face_recognition_fail.dart';
import 'package:bank_app/screens/register_face_recognition_sucess.dart';
import 'package:bank_app/widgets/create_user.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:bank_app/services/api.dart';

class FaceRecognitionScreen extends StatefulWidget {
  const FaceRecognitionScreen({super.key, this.cpf});

  final String? cpf;

  @override
  _FaceRecognitionScreenState createState() => _FaceRecognitionScreenState();
}

class _FaceRecognitionScreenState extends State<FaceRecognitionScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  bool _isLoading = false;
  bool _isCameraReady = false;
  bool _isCaptured = false;

  // Lista de imagens será simplificada para armazenar uma única imagem
  String? _capturedImage;
  static const int _photosNeeded = 1;

  int get _remainingPhotos {
    final remaining = _photosNeeded - (_capturedImage == null ? 0 : 1);
    return remaining > 0 ? remaining : 0;
  }

  int get _nextPhotoNumber {
    return (_capturedImage == null) ? 1 : _photosNeeded;
  }

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
    if (_isLoading) return; // Evita capturar mais de uma foto

    setState(() {
      _isCaptured = true;
      _isLoading = true;
    });

    try {
      await _initializeControllerFuture;

      // 2) Captura a imagem
      final image = await _cameraController.takePicture();

      // Converte a imagem para Base64
      final imageBytes = await image.readAsBytes();
      final imageBase64 = base64Encode(imageBytes);

      // Armazenando apenas a imagem capturada
      setState(() {
        _capturedImage = imageBase64;
      });

      // Obtém o idToken do Firebase (passando email e senha)
      const email = "teste@teste.com";
      const password = "123456";
      final idToken = await captureIDToken(email, password);

      if (idToken == null) {
        print("Erro ao obter idToken");
        return;
      }

      print("idToken obtido: $idToken");

      // Envia a imagem para o endpoint de verificação
      final success = await verifyFace(idToken, _capturedImage!);

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const FaceRecognitionScreenSucess(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const FaceRecognitionScreenFail()),
        );
      }
    } catch (e) {
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
      body: _isCameraReady
          ? Stack(
              children: [
                // Exibe a visualização da câmera
                Positioned.fill(child: CameraPreview(_cameraController)),
                // Exibe o oval dinâmico
                Positioned.fill(
                  child: TweenAnimationBuilder<Size?>(
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    tween: SizeTween(
                      end: _isCaptured
                          ? const Size(380, 480)
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
                // Exibe o botão de captura
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SizedBox(
                      width: 200,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : _capturePhoto, // Desabilita após capturar
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(0, 102, 255, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Capturar foto $_nextPhotoNumber/$_photosNeeded',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Mostra um indicador de carregamento enquanto o processo de captura está em andamento
                if (_isLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Aguarde enquanto solicitamos permissão para acessar a câmera...',
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
                      onPressed: _checkCameraPermission, // Botão que tenta acessar a câmera
                      child: const Text(
                        'Conceder Permissão',
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