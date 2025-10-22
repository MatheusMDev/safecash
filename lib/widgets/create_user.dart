// lib/controllers/user_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user.dart';

class UserController {
  final _db = FirebaseFirestore.instance;
  final _collection = 'user';

  /// Cadastra um novo usuário no Firestore
  Future<User?> register(User user) async {
    try {
      final docRef = await _db.collection(_collection).add(user.toMap());
      final snapshot = await docRef.get();
      return User.fromMap(snapshot.data()!, id: snapshot.id);
    } catch (e) {
      print('Erro ao cadastrar usuário: $e');
      return null;
    }
  }

  /// Faz login com CPF e senha (busca simples)
  Future<User?> login(String cpf, String pw) async {
    try {
      final query =
          await _db
              .collection(_collection)
              .where('cpf', isEqualTo: cpf)
              .where('pw', isEqualTo: pw)
              .limit(1)
              .get();

      if (query.docs.isEmpty) {
        print('Usuário não encontrado ou senha incorreta');
        return null;
      }

      final doc = query.docs.first;
      return User.fromMap(doc.data(), id: doc.id);
    } catch (e) {
      print('Erro no login: $e');
      return null;
    }
  }

  /// Lista todos usuários (apenas pra debug/teste)
  Future<List<User>> listAll() async {
    try {
      final snap = await _db.collection(_collection).get();
      return snap.docs.map((d) => User.fromMap(d.data(), id: d.id)).toList();
    } catch (e) {
      print('Erro ao listar usuários: $e');
      return [];
    }
  }
}
