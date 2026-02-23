import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/core/service/local_storage.dart';
import 'package:dev/features/auth/repository/login_repository.dart';
import 'package:dev/features/home/model/hive_task_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return TaskRepository(firestore);
});

class TaskRepository {
  final FirebaseFirestore firestore;

  TaskRepository(this.firestore);

  CollectionReference get tasks => firestore.collection('tasks');

  Future<void> createTask(Task task) async {
    await tasks.doc(task.id).set(task.toMap());
  }

  Future<void> updateTask(Task task) async {
    await tasks.doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String taskId) async {
    await tasks.doc(taskId).delete();
  }

  Stream<List<Task>> getTasksForOwner(String ownerId) {
    return tasks
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    Task.fromMap(doc.data() as Map<String, dynamic>, doc.id),
              )
              .toList(),
        );
  }

  Stream<List<Task>> getLocalTasksStream(String ownerId) async* {
    final localRepo = LocalStorage.instance;

    // Ouve Firestore em tempo real
    final firestoreStream = getTasksForOwner(ownerId);

    await for (final firestoreTasks in firestoreStream) {
      if (firestoreTasks.isNotEmpty) {
        // Salva no Hive apenas se houver algo novo
        for (final task in firestoreTasks) {
          if (!await localRepo.existsLocalTask(task.id)) {
            await localRepo.saveLocalTask(task.copyWith(isSynced: true));
          }
        }
      }

      // Sempre retorna o que tiver no Hive, mesmo que Firestore esteja vazio
      yield await localRepo.getLocalTasks();
    }
  }

  Stream<List<Task>> getTasksForUser(String userId) {
    return tasks
        .where('assignedUserIds', arrayContains: userId) // mesmo nome do map
        .orderBy('dueDate')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    Task.fromMap(doc.data() as Map<String, dynamic>, doc.id),
              )
              .toList(),
        );
  }
}

final taskLocalRepositoryProvider = Provider<LocalStorage>((ref) {
  return LocalStorage.instance;
});
