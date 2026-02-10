import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/model/hive_user_model.dart';
import '../service/local_storage.dart';

final localUserProvider = AsyncNotifierProvider<LocalUserNotifier, LocalUser?>(
  LocalUserNotifier.new,
);

class LocalUserNotifier extends AsyncNotifier<LocalUser?> {
  @override
  Future<LocalUser?> build() async {

    final user = LocalStorage.instance.user;
    return user;
  }

  Future<void> save(LocalUser user) async {
    await LocalStorage.instance.saveUser(user);
    state = AsyncData(user);
  }

  Future<void> clear() async {
    await LocalStorage.instance.clearUser();
    state = const AsyncData(null);
  }
}
