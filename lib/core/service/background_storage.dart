import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/auth/model/hive_user_model.dart';

class BackgroundLocalStorage {
  static Future<LocalUser?> getUser() async {
    // iniciar Hive no isolate do WorkManager
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    // registrar adapter (muito importante!)
    if (!Hive.isAdapterRegistered(LocalUserAdapter().typeId)) {
      Hive.registerAdapter(LocalUserAdapter());
    }

    // abrir box
    final box = await Hive.openBox<LocalUser>('userBox');

    return box.get('currentUser');
  }
}
