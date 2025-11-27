import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user.dart';

class UserController {
  final _db = FirebaseFirestore.instance;
  final _collection = 'user';

  /// Cadastra um novo usuario no Firestore
  Future<User?> register(User user) async {
    try {
      final docRef = await _db.collection(_collection).add(user.toMap());
      final snapshot = await docRef.get();
      return User.fromMap(snapshot.data()!, id: snapshot.id);
    } catch (e) {
      print('Erro ao cadastrar usuario: $e');
      return null;
    }
  }

  /// Atalho para cadastrar passando apenas os campos basicos
  Future<User?> registerFromFields({
    required String cpf,
    required String name,
    required String email,
    required String phone,
    required String pw,
    List<String>? embedding,
  }) {
    final user = User(
      cpf: cpf.trim(),
      name: name.trim(),
      email: email.trim(),
      phone: phone.trim(),
      pw: pw,
      embedding: embedding,
    );
    return register(user);
  }

  /// Atualiza/guarda o embedding em um usuario ja cadastrado (opcional no fluxo).
  /// Use quando ja tiver o ID do documento do usuario.
  Future<User?> saveEmbeddingForUser({
    required String userId,
    required List<String> embedding,
  }) async {
    try {
      final docRef = _db.collection(_collection).doc(userId);
      await docRef.update({'embedding': embedding});
      final snapshot = await docRef.get();
      return User.fromMap(snapshot.data()!, id: snapshot.id);
    } catch (e) {
      print('Erro ao salvar embedding do usuario: $e');
      return null;
    }
  }

  /// Atalho para salvar embedding usando apenas o CPF (busca e atualiza).
  Future<User?> saveEmbeddingByCpf({
    required String cpf,
    required List<String> embedding,
  }) async {
    try {
      final query =
          await _db.collection(_collection).where('cpf', isEqualTo: cpf).limit(1).get();
      if (query.docs.isEmpty) {
        print('Usuario nao encontrado para salvar embedding');
        return null;
      }
      final docRef = query.docs.first.reference;
      await docRef.update({'embedding': embedding});
      final snapshot = await docRef.get();
      return User.fromMap(snapshot.data()!, id: snapshot.id);
    } catch (e) {
      print('Erro ao salvar embedding por CPF: $e');
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
        print('Usuario nao encontrado ou senha incorreta!');
        return null;
      }

      final doc = query.docs.first;
      return User.fromMap(doc.data(), id: doc.id);
    } catch (e) {
      print('Erro no login: $e');
      return null;
    }
  }

  /// Lista todos usuarios (apenas para debug/teste)
  Future<List<User>> listAll() async {
    try {
      final snap = await _db.collection(_collection).get();
      return snap.docs.map((d) => User.fromMap(d.data(), id: d.id)).toList();
    } catch (e) {
      print('Erro ao listar usuarios: $e');
      return [];
    }
  }
}
