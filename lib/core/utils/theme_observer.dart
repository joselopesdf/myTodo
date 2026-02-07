import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../service/local_storage.dart';

class SystemThemeObserver with WidgetsBindingObserver {
  final WidgetRef ref;

  SystemThemeObserver(this.ref);

  @override
  void didChangePlatformBrightness() {

    final systemBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;

    final storedTheme = LocalStorage.instance.themeMode; // light/dark

    final isSystemDark = systemBrightness == Brightness.dark;
    final isStoredDark = storedTheme == ThemeMode.dark;


  }



}
