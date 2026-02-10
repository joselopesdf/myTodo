
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

  LocalUser({
    required this.id,
    required this.name,
    required this.email,
    this.role = 'user',
  });

  LocalUser copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
  }) {
    return LocalUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }

  @override
  String toString() => 'LocalUser(id: $id, name: $name, email: $email, role: $role)';
}
