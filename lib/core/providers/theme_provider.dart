
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';


import '../service/local_storage.dart';


var storedThemeProvider = StateProvider<String>((ref) {
  return 'light';
});


final themeProvider = NotifierProvider<ThemeNotifier,ThemeMode>(
        ()  =>  ThemeNotifier(LocalStorage.instance)
) ;


class ThemeNotifier extends Notifier<ThemeMode> {

  LocalStorage storage ;


  ThemeNotifier(this.storage);


  @override
  ThemeMode build()  {

    var storedTheme =  storage.themeMode ;


    return  storedTheme ;

  }


  ThemeMode get themeByTime {

    final hour = DateTime.now().hour;
    return (hour >= 19 || hour < 6) ? ThemeMode.dark : ThemeMode.light;
  }


  void toggle() async{

    await storage.toggleTheme();

    ThemeMode storedTheme = storage.themeMode ;


    state = storedTheme;


  }


  // void setLight() async {
  //
  //   await storage.setThemeLight();
  // }
  //
  // void setDark() async {
  //
  //   await storage.setThemeDark();
  // }


}