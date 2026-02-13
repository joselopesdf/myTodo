import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;    // UID do FirebaseAuth
  final String name;
  final String email;
  final String role;
  final String? photo ;

  /// Construtor principal
  User( {
    required this.id,
    required this.name,
    required this.email,
    this.role = 'user',
    this.photo ,
  });

  /// Constrói User a partir de dados do Firestore
  factory User.fromMap(DocumentSnapshot<Map<String, dynamic>> map, {required String id}) {
    return User(
      id: id, // pega do documento Firestore ou FirebaseAuth UID
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'user',
      photo: map['photo']
    );
  }

  /// Converte User para Map (para salvar no Firestore/Hive)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'photo':photo
    };
  }

  /// Copia User alterando campos específicos
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? photo
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      photo: photo ?? this.photo
    );
  }

  @override
  String toString() => 'User(id: $id, name: $name, email: $email, role: $role , photo : $photo)';
}
