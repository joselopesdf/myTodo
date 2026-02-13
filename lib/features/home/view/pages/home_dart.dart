import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/local_user_provider.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/widget/online.dart';
import '../../../auth/state/login_state.dart';
import '../../../auth/viewmodel/login_view_model.dart';
import '../../widgets/profile_image.dart';
import '../../widgets/show_profile_picker.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final loginViewModel = ref.read(loginNotifierProvider.notifier);

    final themeMode = ref.watch(themeProvider);

    final localUser = ref.watch(
      localUserProvider.select((value) => value.value?.photo),
    );

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
          context.go('/login'); // navega para login
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          ElevatedButton(
            onPressed: () {
              showProfileImagePickerDialog(context, ref);
            },
            child: Icon(Icons.person),
          ),

          ConnectionStatusDot(),

          Switch(
            value: themeMode == ThemeMode.light,
            onChanged: (value) => ref.read(themeProvider.notifier).toggle(),
          ),

          ProfileImage(radius: 30),

          InkWell(
            child: Icon(Icons.logout),
            onTap: () {
              loginViewModel.logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Text("Bem-vindo  ${localUser.value?.name}  Admin!"),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
