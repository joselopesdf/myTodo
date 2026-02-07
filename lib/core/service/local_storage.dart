
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


  ThemeMode switchTheme(ThemeMode theme) {


    if (theme == ThemeMode.light) return ThemeMode.light;

    if (theme == ThemeMode.dark) return ThemeMode.dark;

    return ThemeMode.system;
  }


  ThemeMode switchThemeString(String theme) {

    ThemeMode newTheme = ThemeMode.light ;



    if (theme ==  'light' ) {

      newTheme =  ThemeMode.light ;

    }

    if (theme ==  'dark' ) {

      newTheme =  ThemeMode.dark ;

    }

    if (theme ==  'system' ) {

      newTheme =  ThemeMode.system ;

    }

    return newTheme ;


    }



  ThemeMode get themeMode  {

    final stored = _box.get('themeMode');


    if(stored == null){


    return  ThemeMode.system  ;

    }

    return  stored == 'dark' ? ThemeMode.dark : ThemeMode.light ;


  }

  Future<void> toggleTheme()  async {


    String newTheme = themeMode == ThemeMode.light  ?  'dark' : 'light' ;


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