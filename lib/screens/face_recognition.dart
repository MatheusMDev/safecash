import 'dart:convert';
import 'package:bank_app/screens/face_recognition_fail.dart';
import 'package:bank_app/screens/face_recognition_sucess.dart';
import 'package:bank_app/widgets/create_user.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:bank_app/services/api.dart';

class FaceRecognitionScreen extends StatefulWidget {
  const FaceRecognitionScreen({super.key, this.cpf, this.uid});

  /// CPF do usuário (caso você queira localizar o uid na collection `user`)
  final String? cpf;

  /// uid do usuário na collection `user` (se já tiver direto, melhor ainda)
  final String? uid;

  @override
  _FaceRecognitionScreenState createState() => _FaceRecognitionScreenState();
}

class _FaceRecognitionScreenState extends State<FaceRecognitionScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  bool _isLoading = false;
  bool _isCameraReady = false;
  bool _isCaptured = false;

  final UserController _userController = UserController();
  String? _resolvedUid;

  // para verify-face só preciso de UMA imagem
  String? _capturedImage;

  @override
  void initState() {
    super.initState();
    // Se já vier o uid na navegação, usa direto
    _resolvedUid = widget.uid;
    // Se veio só CPF, tenta resolver uid na collection `user`
    _ensureUid();
    _checkCameraPermission();
  }

  /// Garante que _resolvedUid esteja preenchido.
  /// Se uid já veio via widget, só retorna.
  /// Caso contrário, tenta localizar por CPF na collection `user`.
  Future<String?> _ensureUid() async {
    if (_resolvedUid != null && _resolvedUid!.isNotEmpty) {
      return _resolvedUid;
    }

    final cpf = widget.cpf;
    if (cpf == null || cpf.isEmpty) {
      return null;
    }

    try {
      final user = await _userController.fetchByCpf(cpf);
      final uid = user?.id;
      if (mounted) {
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
    } else {
      print('Nenhuma câmera disponível');
    }
  }

  void _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;
      _cameraController = CameraController(firstCamera, ResolutionPreset.high);
      _initializeControllerFuture = _cameraController.initialize();
      await _initializeControllerFuture;
      if (mounted) {
        setState(() {
          _isCameraReady = true;
        });
      }
    } catch (e) {
      print("Erro ao inicializar a camera: $e");
    }
  }

  // Captura a foto e envia para /verify-face
  void _capturePhoto() async {
    if (_isLoading) return;

    setState(() {
      _isCaptured = true;
      _isLoading = true;
    });

    try {
      await _initializeControllerFuture;

      // 1) Captura a imagem
      final image = await _cameraController.takePicture();

      // 2) Converte a imagem para Base64
      final imageBytes = await image.readAsBytes();
      final imageBase64 = base64Encode(imageBytes);

      setState(() {
        _capturedImage = imageBase64;
      });

      if (_capturedImage == null) {
        print("Nenhuma imagem capturada.");
        return;
      }

      // 3) Obter idToken do Firebase (usuário técnico)
      const email = "teste@teste.com";
      const password = "123456";

      final idToken = await captureIDToken(email, password);
      if (idToken == null) {
        print("Erro ao obter idToken");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Falha ao obter idToken. Tente novamente.'),
            ),
          );
        }
        return;
      }

      // 4) Garantir UID (via prop ou CPF)
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
      print("uid resolvido: $uid");

      // 5) Chamar /verify-face
      final success = await verifyFace(
        uid: uid,
        idToken: idToken,
        imageBase64: _capturedImage!,
      );

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const FaceRecognitionSucess(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const FaceRecognitionFail(),
          ),
        );
      }
    } catch (e) {
      print('Erro ao capturar a foto: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao capturar/verificar face: $e')),
        );
      }
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
                Positioned.fill(child: CameraPreview(_cameraController)),
                Positioned.fill(
                  child: TweenAnimationBuilder<Size?>(
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    tween: SizeTween(
                      end: const Size(380, 480),
                    ),
                    builder: (context, value, _) {
                      final ovalContainerSize =
                          value ?? const Size(260, 340);
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
                          backgroundColor:
                              const Color.fromRGBO(0, 102, 255, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Capturar foto 1/1',
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
                        backgroundColor:
                            const Color.fromRGBO(0, 102, 255, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: _checkCameraPermission,
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

// Clipper e Painter iguais aos seus
class _OvalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double width = size.width * 0.7;
    double height = size.height * 0.8;

    return Path()
      ..addOval(
        Rect.fromCenter(
          center: Offset(centerX, centerY),
          width: width,
          height: height,
        ),
      );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
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

    final overlay = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addPath(path, Offset.zero);

    canvas.drawPath(
      overlay,
      Paint()..color = Colors.black.withOpacity(0.8),
    );

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = const Color.fromRGBO(0, 102, 255, 1),
    );
  }

  @override
  bool shouldRepaint(covariant _OvalOverlayPainter oldDelegate) =>
      oldDelegate.containerSize != containerSize;
}