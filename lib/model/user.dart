class User {
  String? id;            // opcional: id do doc no Firestore
  String cpf;
  String name;
  String email;
  String phone;
  String? photoUrl;
  String pw;          
  DateTime createdAt;

  User({
    this.id,
    required this.cpf,
    required this.name,
    required this.email,
    required this.phone,
    this.photoUrl,
    required this.pw,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // map -> model (ex.: ao ler do Firestore)
  factory User.fromMap(Map<String, dynamic> map, {String? id}) {
    final created = map['created_at'];
    DateTime createdAtParsed;
    if (created is DateTime) {
      createdAtParsed = created;
    } else {
      // tenta Timestamp do Firestore ou string
      createdAtParsed = DateTime.tryParse(created?.toString() ?? '') ??
          DateTime.now();
    }

    return User(
      id: id,
      cpf: (map['cpf'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      phone: (map['phone'] ?? '').toString(),
      photoUrl: map['photo_url']?.toString(),
      pw: (map['pw'] ?? '').toString(),
      createdAt: createdAtParsed,
    );
  }

  // model -> map (ex.: para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'cpf': cpf,
      'name': name,
      'email': email,
      'phone': phone,
      'photo_url': photoUrl,
      'pw': pw,
      'created_at': createdAt,
    };
  }

  User copyWith({
    String? id,
    String? cpf,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    String? pw,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      cpf: cpf ?? this.cpf,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      pw: pw ?? this.pw,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() =>
      'User(id:$id, name:$name, email:$email, cpf:$cpf, phone:$phone)';
}
