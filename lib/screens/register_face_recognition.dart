import 'package:bank_app/screens/face_recognition.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class RegisterFaceScreen extends StatefulWidget {
  const RegisterFaceScreen({super.key});

  @override
  _RegisterFaceScreenState createState() => _RegisterFaceScreenState();
}

class _RegisterFaceScreenState extends State<RegisterFaceScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Inicializa a câmera
  void _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _cameraController = CameraController(firstCamera, ResolutionPreset.high);
    _initializeControllerFuture = _cameraController.initialize();
    setState(() {});
  }

  // Função para capturar a foto
  void _capturePhoto() async {
    try {
      setState(() => _isLoading = true);

      // Aguarda a inicialização da câmera
      await _initializeControllerFuture;

      // Captura a imagem
      final image = await _cameraController.takePicture();

      // Enviar a imagem para a API (para registrar o embedding)
      // Você pode enviar a imagem para o backend da API para gerar o embedding e salvar no Firestore
      // Aqui você chamaria sua função para enviar para o backend

      // Exemplo de código fictício:
      // await API.registerFace(image.path);

      // Após o registro, navega para a tela de login ou próximo fluxo
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FaceRecognitionScreen()),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      print('Erro ao capturar a foto: $e');
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraController.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Face'),
      ),
      body: Column(
        children: [
          Expanded(
            child: CameraPreview(_cameraController),
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            ElevatedButton(
              onPressed: _capturePhoto,
              child: const Text('Capturar Foto'),
            ),
        ],
      ),
    );
  }
}
