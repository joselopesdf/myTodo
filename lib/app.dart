
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

  // bool userLoaded = false;



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

  // Future<void> _loadUser() async {
  //   // Carrega o usuário do LocalStorage
  //   final user = await ref.read(localUserProvider.notifier).build();
  //
  //   if (user != null) {
  //     // Atualiza o estado do AsyncNotifier corretamente
  //     ref.read(localUserProvider.notifier).state = AsyncData(user);
  //   } else {
  //     ref.read(localUserProvider.notifier).state = const AsyncData(null);
  //   }
  //
  //   setState(() {
  //     userLoaded = true;
  //   });
  // }



  @override
  Widget build(BuildContext context) {
    // Aqui você tem acesso ao ref
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeProvider);


    final router = ref.watch(routerProvider);

    final localUser = ref.watch(localUserProvider);

    // print(' ------ Usuario atual no main ------ ${currentUser.currentUser}');
    //
    // print(' ------ Usuario atual no main riverpod ------ ${ref.watch(loginNotifierProvider).user?.role}');

    print(" -------user no hive ${localUser.value?.name} -------");




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












