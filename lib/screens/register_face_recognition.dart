import 'dart:convert';
import 'package:bank_app/screens/register_face_recognition_fail.dart';
import 'package:bank_app/screens/register_face_recognition_sucess.dart';
import 'package:bank_app/widgets/create_user.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:bank_app/services/api.dart';

class RegisterFaceScreenRecognition extends StatefulWidget {
  const RegisterFaceScreenRecognition({super.key, this.cpf, this.uid});

  final String? cpf;
  final String? uid;

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
  static const int _photosNeeded = 2;
  String? _resolvedUid;

  int get _remainingPhotos {
    final remaining = _photosNeeded - _capturedImages.length;
    return remaining > 0 ? remaining : 0;
  }

  int get _nextPhotoNumber {
    final next = _capturedImages.length + 1;
    return next > _photosNeeded ? _photosNeeded : next;
  }
  bool get _hasRequiredPhotos => _capturedImages.length >= _photosNeeded;

  @override
  void initState() {
    super.initState();
    _resolvedUid = widget.uid;
    // Tenta resolver o UID logo ao iniciar, caso venha apenas o CPF
    _ensureUid();
    _checkCameraPermission();
  }

  Future<String?> _ensureUid() async {
    if (_resolvedUid != null && _resolvedUid!.isNotEmpty) return _resolvedUid;

    final cpf = widget.cpf;
    if (cpf == null || cpf.isEmpty) return null;

    try {
      final user = await _userController.fetchByCpf(cpf);
      final uid = user?.id;
      if (uid != null && uid.isNotEmpty && mounted) {
        setState(() {
          _resolvedUid = uid;
        });
      } else {
        _resolvedUid = uid;
      }
      return uid;
    } catch (e) {
      print('Erro ao buscar UID por CPF: $e');
      return null;
    }
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

      // Adiciona a imagem Base64 à lista (caso queira capturar mais vezes)
      setState(() {
        _capturedImages.add(imageBase64);
        if (_capturedImages.length > _photosNeeded) {
          _capturedImages.removeAt(0);
        }
      });

      if (!_hasRequiredPhotos) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Falta capturar mais $_remainingPhotos foto(s).'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      const email = "teste@teste.com";
      const password = "123456";

      final idToken = await captureIDToken(email, password);

      if (idToken == null) {
        print("Erro ao obter idToken");
        return;
      }

      final uid = await _ensureUid();
      if (uid == null || uid.isEmpty) {
        print("UID ausente. Nao foi possivel enviar para a API.");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('UID do usuario nao encontrado.')),
          );
        }
        return;
      }

      print("idToken obtido: $idToken");

      final imagesToSend = _capturedImages.take(_photosNeeded).toList();

      // 3) Chama a API FastAPI /register-face com o idToken e as imagens
      final success = await registerFace(uid, idToken, imagesToSend);

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
                          onPressed: _isLoading ? null : _capturePhoto,
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
