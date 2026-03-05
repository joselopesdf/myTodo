import '../../features/home/repository/task_repository.dart';
import 'local_storage.dart';

class SyncService {
  final TaskRepository repository;
  final LocalStorage localStorage = LocalStorage.instance;

  SyncService({required this.repository});

  Future<void> syncTasks(String ownerId) async {
    final localRepo = localStorage;

    final localTasks = await localRepo.getLocalTasks();
    final firestoreTasks = await repository.getTasksForOwner(ownerId).first;

    // 🔹 Se Hive estiver vazio, salvar tudo do Firestore direto
    if (localTasks.isEmpty && firestoreTasks.isNotEmpty) {
      for (final task in firestoreTasks) {
        await localRepo.saveLocalTask(task.copyWith(isSynced: true));
      }
      print("🔄 Hive preenchido com dados do Firestore");
      return; // já sincronizou, pode sair
    }

    // 🔹 Sincronização normal: do Hive para Firestore
    final firestoreIds = firestoreTasks.map((t) => t.id).toSet();

    final hiveIds = localTasks.map((t) => t.id).toSet();

    if (localTasks.length > firestoreTasks.length) {
      for (var localId in hiveIds) {
        if (!firestoreIds.contains(localId)) {
          localRepo.deleteLocalTask(localId);
        }
      }
    }

    for (final task in localTasks) {
      if (!task.isSynced) {
        await repository.createTask(task);
        await localRepo.saveLocalTask(task.copyWith(isSynced: true));
      }
    }

    // 🔹 Atualiza Hive com tarefas do Firestore que não existem localmente
    for (final task in firestoreTasks) {
      if (!await localRepo.existsLocalTask(task.id)) {
        await localRepo.saveLocalTask(task.copyWith(isSynced: true));
      }
    }
  }
}
