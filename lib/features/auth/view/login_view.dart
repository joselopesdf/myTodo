
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



import '../state/login_state.dart';
import '../viewmodel/login_view_model.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final loginViewModel = ref.read(loginNotifierProvider.notifier) ;

    final loginState = ref.watch(loginNotifierProvider);


    ref.listen<LoginState>(loginNotifierProvider, (previous, next) {
      // Mostrar SnackBar apenas para erros do usuário
      if (next.error != null && next.error != previous?.error && next.typeError != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.error!)),
          );
        });
      }

      // Navegar apenas quando login for bem-sucedido
      // if (next.user != null && next.user != previous?.user && next.user?.role == 'admin' ) {
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     context.go('/admin');
      //   });
      // }
      //
      // else if (next.user != null && next.user != previous?.user && next.user?.role == 'user'){
      //
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     context.go('/home');
      //   });
      //
      //
      // }


    });




    return Scaffold(
      appBar: AppBar(title: Text('Login Page', ),),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Pagina de Registo', style: Theme.of(context).textTheme.titleLarge),

            const SizedBox(height: 20),

            if (loginState.isLoading)

              CircularProgressIndicator(),


            const SizedBox(height: 20),

            InkWell(
              child: Text(
                "Login",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              onTap: (){

               loginViewModel.login() ;

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => LoginView()),
                // );

              },
            ),


          ],
        ),
      ),
    );
  }
}
