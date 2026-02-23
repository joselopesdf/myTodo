import 'package:dev/features/home/model/hive_task_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/auth/model/hive_user_model.dart';

class LocalStorage {
  LocalStorage._();

  static late Box _settingsBox;

  static late Box<LocalUser> _userBox;

  static late Box<Task> _taskBox;

  static final LocalStorage instance = LocalStorage._();

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(LocalUserAdapter());

    Hive.registerAdapter(TaskAdapter());
    // registra o adapter
    _userBox = await Hive.openBox<LocalUser>('userBox');

    _taskBox = await Hive.openBox<Task>('taskBox');

    _settingsBox = await Hive.openBox('settings');
  }

  Future<void> saveUser(LocalUser user) async {
    await _userBox.put('currentUser', user);
  }

  Future<void> saveLocalTask(Task task) async {
    await _taskBox.put(task.id, task);
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    final task = _taskBox.get(taskId);
    if (task != null) {
      await _taskBox.put(
        taskId,
        task.copyWith(completed: !task.completed, isSynced: false),
      );
    }
  }

  Future<List<Task>> getLocalTasks() async {
    return _taskBox.values.toList();
  }

  Future<bool> existsLocalTask(String taskId) async {
    return _taskBox.containsKey(taskId);
  }

  Future<void> updateLocalTask(Task updatedTask) async {
    if (_taskBox.containsKey(updatedTask.id)) {
      await _taskBox.put(updatedTask.id, updatedTask.copyWith(isSynced: false));
    }
  }

  Future<void> deleteLocalTask(String taskId) async {
    await _taskBox.delete(taskId);
  }

  Future<void> clearLocalTasks() async {
    await _taskBox.clear();
  }

  Future<void> clearUser() async {
    await _userBox.delete('currentUser');
  }

  LocalUser? get user {
    final stored = _userBox.get('currentUser');

    if (stored == null) return null;

    return stored;
  }

  Future<void> updateUserPhoto(String newPhotoUrl) async {
    final currentUser = _userBox.get('currentUser');

    if (currentUser == null) return;

    final updatedUser = currentUser.copyWith(photo: newPhotoUrl);

    await _userBox.put('currentUser', updatedUser);
  }

  ThemeMode get themeByTime {
    final hour = DateTime
        .now()
        .hour;
    return (hour >= 19 || hour < 7) ? ThemeMode.dark : ThemeMode.light;
  }

  ThemeMode get themeMode {
    final stored = _settingsBox.get('themeMode');

    return stored == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme() async {
    String newTheme = themeMode == ThemeMode.light ? 'dark' : 'light';

    await _settingsBox.put('themeMode', newTheme);
  }

  Locale get locale {
    final stored = _settingsBox.get('locale', defaultValue: 'pt');
    return Locale(stored);
  }

  Future<void> toggleLocale() async {
    final newLocale = locale.languageCode == 'pt' ? 'en' : 'pt';
    await _settingsBox.put('locale', newLocale);
  }

  Future<void> setLocale(Locale newLocale) async {
    await _settingsBox.put('locale', newLocale.languageCode);
  }

}
