import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
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

    try {
      // 1️⃣ Inicializar Firebase
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      print("✅ Firebase inicializado");

      // 2️⃣ Inicializar Hive local
      await Hive.initFlutter();
      print("✅ Hive inicializado");

      // 3️⃣ Obter usuário do Hive
      final hiveUser = await BackgroundLocalStorage.getUser();
      print("📦 Hive user: ${hiveUser?.id}");

      // 4️⃣ Obter ownerId (input ou Hive)
      final ownerId = hiveUser?.id ?? '';
      if (ownerId.isEmpty) {
        print("⚠️ OwnerId não encontrado, abortando");
        return Future.value(true);
      }

      // 5️⃣ Executar sincronização
      if (task == 'syncTasks') {
        print("🔍 Iniciando sincronização para ownerId: $ownerId");
        await SyncService(
          repository: TaskRepository(FirebaseFirestore.instance),
        ).syncTasks(ownerId);
        print("✅ Sincronização concluída para $ownerId");
      }
    } catch (e, st) {
      print("❌ Erro no Worker: $e\n$st");
    }

    // 6️⃣ Sempre retornar true
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await LocalStorage.init();

  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  runApp(ProviderScope(child: MyApp()));
}
