
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';


import '../service/local_storage.dart';


var storedThemeProvider = StateProvider<String>((ref) {
  return 'light';
});

var localStorageProvider = Provider( (ref) => LocalStorage.instance ) ;


final themeProvider = NotifierProvider<ThemeNotifier,ThemeMode>(

        ()  =>     ThemeNotifier(LocalStorage.instance)
) ;


class ThemeNotifier extends Notifier<ThemeMode> {

  LocalStorage storage ;


  ThemeNotifier(this.storage);


  @override
  ThemeMode build()  {

    var storedTheme =  storage.themeMode ;


    return  storedTheme ;

  }





  void toggle({required isOpenApp}) async{

    await storage.toggleTheme();

    ThemeMode storedTheme = storage.themeMode ;


    state = storedTheme;


  }


  // void setTheme() async {
  //
  //   await storage.setTheme();
  // }



}