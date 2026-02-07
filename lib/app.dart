
import 'package:dev/features/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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


  void changeTheme(){

    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;

    print("SYSTEM BRIGHTNESS CHANGED → $brightness");



    String storedTheme = ref.read(themeProvider) == ThemeMode.light ? 'light' : 'dark';

    print("tema : ${brightness.name}");

    print("tema do riverpod $storedTheme");


    if(brightness.name != storedTheme ){

      ref.read(themeProvider.notifier).toggle();
    }
  }


  @override
  void didChangeDependencies() {

    super.didChangeDependencies();



  }

  @override
  void didChangePlatformBrightness(){

    super.didChangeDependencies();

    changeTheme();


  }



  @override
  void initState() {
    super.initState();
    print("INIT STATE MyApp Page");

    WidgetsBinding.instance.addObserver(this );

    changeTheme();


  }



  @override
  Widget build(BuildContext context) {
    // Aqui você tem acesso ao ref
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeProvider);

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




class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>  {


  @override
  void initState() {
    super.initState();
    print("INIT STATE HomePage");

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("DID UPDATE WIDGET HomePage");


  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("APP LIFECYCLE STATE HomePage: $state");

  }

  @override
  void didChangePlatformBrightness() {



  }

  @override
  void deactivate() {
    super.deactivate();
    print("DEACTIVATE HomePage");
  }

  @override
  void dispose() {

    print("DISPOSE HomePage");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final currentLocale = ref.read(localeProvider.notifier);
    final language = ref.watch(localeProvider);
    final themeMode = ref.watch(themeProvider);



    return Scaffold(
      appBar: AppBar(title: Text(t.home_title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(t.hello, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => currentLocale.toggle(),
              child: language.languageCode == 'pt'
                  ? const Text("Traduzir")
                  : const Text("Translate"),
            ),
            const SizedBox(height: 20),
            Switch(
              value: themeMode == ThemeMode.light,
              onChanged: (value) => ref.read(themeProvider.notifier).toggle(),
            ),
            Text(
              t.description,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            InkWell(
              child: Text(
                "Ir para Login",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginView()),
                );

              },
            ),

          ],
        ),
      ),
    );
  }
}





