import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';

import 'app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/service/background_storage.dart';
import 'core/service/sincronizeTasks.dart';
import 'features/home/repository/task_repository.dart';
import 'firebase_options.dart';

import 'core/service/local_storage.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, input) async {
    print("🔥 Rodando em background: $task");

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final inputOwner = input?['ownerId'];

    final hiveUser = await BackgroundLocalStorage.getUser();

    final ownerId = inputOwner ?? hiveUser?.id ?? '';

    if (task == 'syncTasks') {
      print("🔍 Iniciando sincronização para ownerId: $ownerId");

      if (ownerId.isNotEmpty) {
        await SyncService(
          repository: TaskRepository(FirebaseFirestore.instance),
        ).syncTasks(ownerId);
        print("✅ Sincronização concluída para $ownerId");
      } else {
        print("⚠️ OwnerId não encontrado, sincronização abortada");
      }
    }

    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await LocalStorage.init();

  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  await Workmanager().registerPeriodicTask(
    "sync-tasks",
    "syncTasks",
    existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    inputData: {'ownerId': LocalStorage.instance.user?.id},
    frequency: const Duration(minutes: 15),
    initialDelay: const Duration(seconds: 15),
    constraints: Constraints(networkType: NetworkType.connected),
  );

  runApp(ProviderScope(child: MyApp()));
}
