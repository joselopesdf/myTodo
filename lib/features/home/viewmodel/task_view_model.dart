import 'package:dev/features/home/model/hive_task_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/connection_provider.dart';
import '../repository/task_repository.dart';

// Todas as tasks do usuário (normal) ou admin (dono)
final tasksProvider = StreamProvider.family<List<Task>, String>((ref, userId) {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.getTasksForUser(userId);
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

      await localRepo.saveLocalTask(task);

      if (isOnline) {
        await repoRemote.createTask(task);

        final syncedTask = task.copyWith(isSynced: true);
        await localRepo.saveLocalTask(syncedTask);
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
