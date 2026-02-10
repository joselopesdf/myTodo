import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'app.dart';
import 'features/login/view/login_view.dart';
import 'features/login/viewmodel/login_view_model.dart';

final router = GoRouter(
  initialLocation: '/login',

  // redirect: (context, state) {
  //
  //   final container = ProviderScope.containerOf(context);
  //
  //   final loginState = container.read(loginNotifierProvider);
  //
  //   final user = loginState.user;
  //   final loggedIn = user != null;
  //   final isAdmin = user?.role == 'admin';
  //
  //   final goingTo = state.matchedLocation;
  //
  //   // 1) Se NÃO está logado → só pode ir para /login
  //   if (!loggedIn && goingTo != '/login') {
  //     return '/login';
  //   }
  //
  //   // 2) Se está logado e tentou ir para login → manda pra home/admin
  //   if (loggedIn && goingTo == '/login') {
  //     return isAdmin ? '/admin' : '/home';
  //   }
  //
  //   // 3) Se está logado e NÃO é admin, bloquear acesso a /admin
  //   if (loggedIn && !isAdmin && goingTo == '/admin') {
  //     return '/home';
  //   }
  //
  //   // 4) Se é admin, bloquear acesso à home normal
  //   if (loggedIn && isAdmin && goingTo == '/home') {
  //     return '/admin';
  //   }
  //
  //   return null; // tudo OK
  // },

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
