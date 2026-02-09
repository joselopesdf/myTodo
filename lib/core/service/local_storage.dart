
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage {

  LocalStorage._() ;

  static late Box _box;

  static final LocalStorage instance = LocalStorage._();


  static Future<void> init() async {

    await Hive.initFlutter();
    _box = await Hive.openBox('settings');

  }



  ThemeMode get themeByTime {

    final hour = DateTime.now().hour;
    return (hour >= 19 || hour < 7) ? ThemeMode.dark : ThemeMode.light;

  }


  ThemeMode get themeMode  {

    final stored = _box.get('themeMode');


    return  stored == 'dark' ? ThemeMode.dark : ThemeMode.light ;


  }

  Future<void> toggleTheme()  async {

    String   newTheme = themeMode == ThemeMode.light  ?  'dark' : 'light' ;

    await _box.put('themeMode', newTheme);
  }



  // Future<void> setThemeLight() async {
  //
  //   await _box.put('themeMode', 'light');
  //
  //
  // }
  //
  // Future<void> setThemeDark() async {
  //
  //   await _box.put('themeMode', 'dark');
  //
  //
  // }


  Locale get locale {
    final stored = _box.get('locale', defaultValue: 'pt');
    return Locale(stored);
  }

  Future<void> toggleLocale() async {
    final newLocale = locale.languageCode == 'pt' ? 'en' : 'pt';
    await _box.put('locale', newLocale);
  }


  Future<void> setLocale(Locale newLocale) async {
    await _box.put('locale', newLocale.languageCode);
  }


}