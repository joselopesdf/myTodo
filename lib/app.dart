
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers/local_user_provider.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/theme/app_theme.dart';

import 'l10n/app_localizations.dart';
import 'routes.dart';


// main.dart
class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver  {


  @override
  void didChangeDependencies() {

    super.didChangeDependencies();



  }

  @override
  void didChangePlatformBrightness(){

    super.didChangeDependencies();

    print("change dependency MyApp Page");

    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;

    print("SYSTEM BRIGHTNESS CHANGED → $brightness");



    String storedTheme = ref.read(themeProvider) == ThemeMode.light ? 'light' : 'dark';

    if(brightness.name != storedTheme ){

      ref.read(themeProvider.notifier).toggle();

      print("tema : ${brightness.name}");

      print("tema do riverpod $storedTheme");


  }

  }



  @override
  void initState() {
    super.initState();
    print("INIT STATE MyApp Page");

    // _loadUser() ;



    WidgetsBinding.instance.addObserver(this );

    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;

    print("SYSTEM BRIGHTNESS CHANGED → $brightness");



  final  currentTheme = ref.read(currentThemeTime);

  final   storedTheme = ref.read(themeProvider);


    if(currentTheme != storedTheme ) {

      ref.read(themeProvider.notifier).toggle();
    }

    print("tema : ${brightness.name}");

    print("tema do riverpod $storedTheme");



  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("APP LIFECYCLE STATE HomePage: $state");


  }


  @override
  Widget build(BuildContext context) {
    // Aqui você tem acesso ao ref
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeProvider);


    final router = ref.watch(routerProvider);

    final localUser = ref.watch(localUserProvider);

    print(" -------user no hive direto no router ${localUser.value?.name} ------- --");


    return MaterialApp.router(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: router,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      title: 'Flutter Demo',
    );
  }
}












