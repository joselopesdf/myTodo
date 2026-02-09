
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';


import '../service/local_storage.dart';


var storedThemeProvider = StateProvider<String>((ref) {
  return 'light';
});

final currentThemeTime = Provider( (ref) => LocalStorage.instance.themeByTime ) ;

final localStorage = Provider( (ref) => LocalStorage.instance ) ;


final themeProvider = NotifierProvider<ThemeNotifier,ThemeMode>(

        ()  =>  ThemeNotifier( )
) ;


class ThemeNotifier extends Notifier<ThemeMode> {




  ThemeNotifier();


  @override
  ThemeMode build()  {

    final storage = ref.watch(localStorage);

    return  storage.themeByTime ;

  }



  void toggle() async{

    final storage = ref.watch(localStorage);


    await storage.toggleTheme();

    ThemeMode storedTheme = storage.themeMode ;


    state = storedTheme;


  }



}