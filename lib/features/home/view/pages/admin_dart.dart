import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:workmanager/workmanager.dart';

import '../../../../core/providers/local_user_provider.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/widget/online.dart';
import '../../../auth/model/hive_user_model.dart';
import '../../../auth/repository/users_repository.dart';
import '../../../auth/state/login_state.dart';
import '../../../auth/viewmodel/login_view_model.dart';
import '../../repository/task_repository.dart';
import '../../viewmodel/task_view_model.dart';
import '../../widgets/create_task_form.dart';
import '../../widgets/profile_image.dart';
import '../../widgets/profile_picture.dart';
import '../../widgets/showAddTask.dart';
import '../../widgets/show_profile_picker.dart';

class AdminPage extends ConsumerStatefulWidget {
  const AdminPage({super.key});

  @override
  ConsumerState<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends ConsumerState<AdminPage> {
  @override
  Widget build(BuildContext context) {
    final loginViewModel = ref.read(loginNotifierProvider.notifier);

    final themeMode = ref.watch(themeProvider);

    final localUser = ref.watch(localUserProvider);

    final firestoreTasks = ref.watch(
      adminTasksProvider(localUser.value?.id ?? ''),
    );

    void printLocalTasks() async {
      final repo = ref.read(taskLocalRepositoryProvider); // pega o repo
      final localTasks = await repo
          .getLocalTasks(); // espera o Future completar

      if (localTasks.isNotEmpty) {
        print("total de tarefas locais: ${localTasks.length}");
        for (final task in localTasks) {
          print("Tarefa local: ${task.title}, isSynced: ${task.isSynced}");
        }
      } else {
        print("Nenhuma tarefa local");
      }
    }

    printLocalTasks();

    if (firestoreTasks.value?.isNotEmpty == true) {
      print("total de tarefas firebase: ${firestoreTasks.value?.length}");
      firestoreTasks.value?.forEach((task) {
        print("Tarefa firebase: ${task.title}, isSynced: ${task.isSynced}");
      });
    }

    // DEBUG

    ref.listen<LoginState>(loginNotifierProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.error ?? 'Erro ao fazer logout')),
          );
        });
      }

      if (next.isLogout) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/login');
        });
      }
    });

    ref.listen<AsyncValue<LocalUser?>>(localUserProvider, (prev, next) async {
      final user = next.value;
      if (user != null) {
        print("🔄 Registrando WorkManager para ownerId: ${user.id}");

        await Workmanager().registerOneOffTask(
          "syncTasksId",
          "syncTasks",
          inputData: {"ownerId": user.id},
          constraints: Constraints(
            networkType: NetworkType.connected,
            requiresBatteryNotLow: true,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Page"),
        actions: [
          ElevatedButton(
            onPressed: () {
              showAddTask(context, ref);
            },
            child: Icon(Icons.add),
          ),

          ConnectionStatusDot(),

          Switch(
            value: themeMode == ThemeMode.light,
            onChanged: (value) => ref.read(themeProvider.notifier).toggle(),
          ),

          GestureDetector(
            child: ProfileImage(radius: 30),
            onTap: () {
              showProfileImagePickerDialog(context, ref);
            },
          ),
          InkWell(
            child: Icon(Icons.logout),
            onTap: () {
              loginViewModel.logout();
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final adminTasks = ref.watch(
            adminTasksProvider(localUser.value?.id ?? ''),
          );

          if (adminTasks.value?.isEmpty == true) {
            return const Center(
              child: Text('Nenhuma tarefa encontrada para este admin.'),
            );
          }

          return adminTasks.when(
            data: (task) => ListView.builder(
              shrinkWrap: true,
              itemCount: task.length,

              itemBuilder: (context, index) {
                final tasks = task[index];
                return ListTile(
                  title: Text(tasks.title),
                  subtitle: Text(tasks.description),
                  trailing: Text('Due: ${tasks.dueDate?.toLocal()}'),
                );
              },
            ),

            loading: () => const Center(child: CircularProgressIndicator()),

            error: (e, _) => Center(child: Text('Erro: $e')),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
