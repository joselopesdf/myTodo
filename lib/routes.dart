import 'package:dev/app.dart';
import 'package:dev/features/login/login_view.dart';
import 'package:go_router/go_router.dart';



final router = GoRouter(

  initialLocation: '/home',

  routes: [

    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),

    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginView(),
    ),

  ],

);
