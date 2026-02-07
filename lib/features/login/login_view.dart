import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {



    return Scaffold(
      appBar: AppBar(title: Text('Login Page', ),),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Pagina de Registo', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}
