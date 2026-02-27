import 'package:dev/features/home/model/hive_task_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';
import '../../../core/providers/connection_provider.dart';
import '../../../core/providers/local_user_provider.dart';
import '../../auth/model/login_model.dart';
import '../repository/task_repository.dart';

// Todas as tasks do usuário (normal) ou admin (dono)
final tasksProvider = StreamProvider.family<List<Task>, String>((ref, userId) {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.getTasksForUser(userId);
});

final getUsersFromTaskProvider = StreamProvider.family<List<User>, String>((
  ref,
  taskId,
) {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.getUsersFromTask(taskId);
});

final adminTasksProvider = StreamProvider.family<List<Task>, String>((
  ref,
  ownerId,
) {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.getTasksForOwner(ownerId);
});

final adminLocalTasksProvider = StreamProvider.family<List<Task>, String>((
  ref,
  ownerId,
) {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.getLocalTasksStream(ownerId);
});

final taskViewModel = AsyncNotifierProvider(TaskViewModel.new);

class TaskViewModel extends AsyncNotifier<bool> {
  @override
  Future<bool> build() {
    return Future.value(false);
  }

  Future<void> createTask(Task task) async {
    state = const AsyncValue.loading();

    try {
      final localRepo = ref.read(taskLocalRepositoryProvider);
      final repoRemote = ref.read(taskRepositoryProvider);
      final isOnline = ref.read(isOnlineProvider);
      final localUser = ref.read(localUserProvider).value;

      // 1️⃣ Salva a task no Hive
      await localRepo.saveLocalTask(task);

      if (isOnline && localUser != null) {
        // 2️⃣ Se online, envia direto para o Firestore
        await repoRemote.createTask(task);

        final syncedTask = task.copyWith(isSynced: true);
        await localRepo.saveLocalTask(syncedTask);
      } else if (localUser != null) {
        // 3️⃣ Se offline, agenda uma OneTimeTask para sincronizar em background
        await Workmanager().registerPeriodicTask(
          "syncTasksPeriodic", // id único da task
          "syncTasks", // nome da task que o callbackDispatcher vai identificar
          frequency: const Duration(minutes: 15),
          // intervalo mínimo permitido é 15 min
          inputData: {"ownerId": localUser.id},
          // passa o ownerId para o callback
          constraints: Constraints(
            networkType: NetworkType.connected, // só roda se tiver internet
            requiresBatteryNotLow: true,
          ),

          initialDelay: const Duration(
            seconds: 10,
          ), // delay inicial para evitar execução imediata
        );
        print(
          "⚡ Task offline registrada para sincronização futura: ${task.id}",
        );
      }

      state = const AsyncValue.data(true);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void reset() {
    state = const AsyncValue.data(false);
  }
}
