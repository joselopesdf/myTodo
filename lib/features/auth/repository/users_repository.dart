import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/login_model.dart';

final firestore = FirebaseFirestore.instance;

// Referência da coleção
CollectionReference<Map<String, dynamic>> get users =>
    firestore.collection('users');

// Stream que retorna apenas usuários "normais" (role == 'user')
Stream<List<User>> getNormalUsers() {
  return users
      .where('role', isEqualTo: 'user')
      .snapshots()
      .map(
        (snapshot) =>
            snapshot.docs.map((doc) => User.fromMap(doc, id: doc.id)).toList(),
      );
}

// Provider do Riverpod
