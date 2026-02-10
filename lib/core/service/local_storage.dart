
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../features/auth/model/hive_user_model.dart';


class LocalStorage {

  LocalStorage._() ;

  static late Box _settingsBox;

  static late Box<LocalUser> _userBox;

  static final LocalStorage instance = LocalStorage._();


  static Future<void> init() async {

    await Hive.initFlutter();

    Hive.registerAdapter(LocalUserAdapter()); // registra o adapter
    _userBox = await Hive.openBox<LocalUser>('userBox');

    _settingsBox = await Hive.openBox('settings');

  }


  Future<void> saveUser(LocalUser user) async {
    await _userBox.put('currentUser', user);
  }

  Future<void> clearUser() async {
    await _userBox.delete('currentUser');
  }


  LocalUser? get user {
    final stored = _userBox.get('currentUser');

    if (stored == null) return null;

    return stored ;
  }





  ThemeMode get themeByTime {

    final hour = DateTime.now().hour;
    return (hour >= 19 || hour < 7) ? ThemeMode.dark : ThemeMode.light;

  }


  ThemeMode get themeMode  {

    final stored = _settingsBox.get('themeMode');


    return  stored == 'dark' ? ThemeMode.dark : ThemeMode.light ;


  }

  Future<void> toggleTheme()  async {

    String   newTheme = themeMode == ThemeMode.light  ?  'dark' : 'light' ;

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