
import 'package:dev/core/service/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final localeProvider =
NotifierProvider<LocaleNotifier, Locale>(
  () => LocaleNotifier(LocalStorage.instance)
);


class LocaleNotifier extends Notifier<Locale> {

  LocalStorage storage ;

  LocaleNotifier(this.storage) ;

  @override
  Locale build() => storage.locale ;

  void toggle() async {


    var storedLocale = storage.locale ;


    state = storedLocale.languageCode == 'pt'
        ? const Locale('en')
        : const Locale('pt');


  await  storage.setLocale(state);

  }

}


