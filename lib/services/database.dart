// lib/services/database.dart
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  Database._();
  static final Database instance = Database._();

  late final FirebaseFirestore db;
  bool _initialized = false;

  /// Inicializa o Firebase e o Firestore (funciona em Android, iOS, Web e Desktop)
  Future<void> init() async {
    if (_initialized) return;

    // Se estiver rodando na Web ou Desktop → precisa de FirebaseOptions manuais
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyCHDutXuKV_39WzRs9dvt0VN79iREvIjnI',
          appId: '1:186779654097:web:f71ba102468c63d6c6f2f0',
          messagingSenderId: '186779654097', // Ex: 1234567890
          projectId: 'mvp-safeface', // Ex: safecash-1234
          authDomain: 'mvp-safeface.firebaseapp.com',
          storageBucket: 'mvp-safeface.firebasestorage.app',
          measurementId: 'G-P66KKPP0HE', // opcional
        ),
      );
      print('✅ Firebase inicializado (via FirebaseOptions para Web/Desktop)');
    } else {
      // Android/iOS → usa arquivos nativos google-services.json / GoogleService-Info.plist
      await Firebase.initializeApp();
      print('✅ Firebase inicializado (modo nativo Android/iOS)');
    }

    db = FirebaseFirestore.instance;
    db.settings = const Settings(persistenceEnabled: true);

    _initialized = true;
    print('✅ Firestore conectado com sucesso');
  }

  // ============================
  // Métodos auxiliares de usuário (MVP)
  // ============================

  CollectionReference<Map<String, dynamic>> get users => db.collection('user');

  /// Adiciona um novo usuário (cadastro)
  Future<DocumentReference<Map<String, dynamic>>> addUser(
    Map<String, dynamic> data,
  ) async {
    try {
      final doc = await users.add(data);
      print('🟢 Usuário criado com ID: ${doc.id}');
      return doc;
    } catch (e) {
      print('❌ Erro ao adicionar usuário: $e');
      rethrow;
    }
  }

  /// Faz login básico (busca CPF + senha)
  Future<Map<String, dynamic>?> login(String cpf, String pw) async {
    try {
      final q =
          await users
              .where('cpf', isEqualTo: cpf)
              .where('pw', isEqualTo: pw)
              .limit(1)
              .get();

      if (q.docs.isEmpty) {
        print('⚠️ Usuário não encontrado ou senha incorreta');
        return null;
      }

      print('✅ Login bem-sucedido para $cpf');
      return q.docs.first.data();
    } catch (e) {
      print('❌ Erro ao realizar login: $e');
      return null;
    }
  }

  /// Retorna todos os usuários (para debug)
  Future<List<Map<String, dynamic>>> listUsers() async {
    try {
      final snap = await users.get();
      return snap.docs.map((d) => d.data()).toList();
    } catch (e) {
      print('❌ Erro ao listar usuários: $e');
      return [];
    }
  }

  /// Atualiza os dados de um usuário pelo ID
  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    try {
      await users.doc(id).update(data);
      print('🟢 Usuário $id atualizado');
    } catch (e) {
      print('❌ Erro ao atualizar usuário: $e');
    }
  }

  /// Deleta um usuário
  Future<void> deleteUser(String id) async {
    try {
      await users.doc(id).delete();
      print('🗑️ Usuário $id removido');
    } catch (e) {
      print('❌ Erro ao deletar usuário: $e');
    }
  }
}
