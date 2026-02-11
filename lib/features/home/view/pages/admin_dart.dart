

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/local_user_provider.dart';
import '../../../auth/state/login_state.dart';
import '../../../auth/viewmodel/login_view_model.dart';




class AdminPage extends ConsumerStatefulWidget {
  const AdminPage({super.key});

  @override
  ConsumerState<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends ConsumerState<AdminPage> {
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

      if (next.isLogout) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/login');
        });
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Admin Page")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Bem-vindo  ${localUser.value?.name}  Admin!"),
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