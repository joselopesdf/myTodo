import 'package:dev/core/providers/local_user_provider.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/view/login_view.dart';

import 'features/home/view/pages/admin_dart.dart';
import 'features/home/view/pages/home_dart.dart';


final loginListenableProvider = Provider<LoginStateListenable>((ref) {
  return LoginStateListenable(ref);
});


class LoginStateListenable extends ChangeNotifier {

  LoginStateListenable(Ref ref) {

    ref.listen(localUserProvider, (_, __) {

      notifyListeners();

    });



  }
}


final routerProvider = Provider<GoRouter>((ref) {


  return GoRouter(

    initialLocation: '/login',

    refreshListenable: ref.read(loginListenableProvider),


    redirect: (context, state) {



      final localUser = ref.read(localUserProvider);



      if(localUser.isLoading) return null ;

      final user = localUser.value ;

      final loggedIn = user != null;
      final isAdmin = user?.role == 'admin';

      final goingTo = state.matchedLocation;





      // 1) Não logado → só login
      if (!loggedIn && goingTo != '/login') return '/login';

      // 2) Logado e indo para login → manda pra home/admin
      if (loggedIn && goingTo == '/login') return isAdmin ? '/admin' : '/home';

      // 3) Bloquear acesso de usuário normal ao admin
      if (loggedIn && !isAdmin && goingTo == '/admin') return '/home';

      // 4) Bloquear acesso de admin à home normal
      if (loggedIn && isAdmin && goingTo == '/home') return '/admin';

      return null; // tudo certo

    },
    routes: [

      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),

      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),

      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminPage(),
      ),

    ],
  );
});

