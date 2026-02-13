
import 'package:hive/hive.dart';

part 'hive_user_model.g.dart'; // necessário para o adapter ser gerado

@HiveType(typeId: 1)
class LocalUser extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String role;

  @HiveField(4)       // <-- novo campo
  final String? photo;

  LocalUser({
    required this.id,
    required this.name,
    required this.email,
    this.role = 'user',
    this.photo,
  });

  LocalUser copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? photo,
  }) {
    return LocalUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      photo: photo ?? this.photo,
    );
  }

  @override
  String toString() => 'LocalUser(id: $id, name: $name, email: $email, role: $role , photo: $photo)';
}
