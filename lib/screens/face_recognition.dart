import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class FaceRecognitionScreen extends StatefulWidget {
  const FaceRecognitionScreen({super.key});

  @override
  _FaceRecognitionScreenState createState() => _FaceRecognitionScreenState();
}

class _FaceRecognitionScreenState extends State<FaceRecognitionScreen> {
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;
    final firstCamera = cameras.first;
    final controller = CameraController(firstCamera, ResolutionPreset.high);
    _initializeControllerFuture = controller.initialize();
    await _initializeControllerFuture;
    if (!mounted) return;
    setState(() {
      _cameraController = controller;
    });
  }

  // Função para capturar a foto e verificar a face
  void _captureAndVerifyFace() async {
    try {
      setState(() => _isLoading = true);

      final controller = _cameraController;
      if (controller == null) {
        throw Exception('Camera nao inicializada');
      }

      await _initializeControllerFuture;

      final image = await controller.takePicture();

      // Envie a imagem para a API para verificar se a face bate com o embedding
      // Aqui você pode chamar sua função de verificação de face
      // Exemplo de código fictício:
      // final result = await API.verifyFace(image.path);

      // Navegar para a próxima tela dependendo do resultado da verificação
      // if (result.success) {
      //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NextScreen()));
      // } else {
      //   _showSnack('Verificação falhou', background: Colors.redAccent);
      // }

    } catch (e) {
      setState(() => _isLoading = false);
      print('Erro ao capturar a foto: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reconhecimento Facial'),
      ),
      body: Column(
        children: [
          Expanded(
            child: CameraPreview(controller),
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            ElevatedButton(
              onPressed: _captureAndVerifyFace,
              child: const Text('Capturar e Verificar Face'),
            ),
        ],
      ),
    );
  }
}
