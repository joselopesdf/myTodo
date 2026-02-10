import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/local_user_provider.dart';
import '../../../auth/state/login_state.dart';
import '../../../auth/viewmodel/login_view_model.dart';



class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {

    final loginViewModel = ref.read(loginNotifierProvider.notifier);

    final localUser = ref.watch(localUserProvider);


    ref.listen<LoginState>(loginNotifierProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.error ?? 'Erro ao fazer logout')),
          );
        });
      }

      // if ( next.isLogout  ) {
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     context.go('/login'); // navega para login
      //   });
      // }
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Bem-vindo  ${localUser.value?.name} !"),
            const SizedBox(height: 20),
            InkWell(
              child: const Text("Logout"),
              onTap: () {
                loginViewModel.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}