
import 'package:dev/features/login/login_model.dart';
import 'package:dev/features/login/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'login_repository.dart';


final loginNotifierProvider =  NotifierProvider<LoginNotifier, LoginState>(LoginNotifier.new);


class LoginNotifier extends  Notifier<LoginState> {

  @override
  LoginState build() {

    return LoginState.initial();
  }


  Future<void> login  () async {



    try {

      state = state.copyWith(isLoading: true);

      final repo = ref.read(loginProvider);

      final user = await repo.signInWithGoogle();

      print("user retornado: $user"); // DEBUG


      if (user == null) {

        state = state.copyWith(isLoading: false , user:  null , error: "Login Cancelado pelo Usuario",typeError: "null") ;

      }

       else {


        User  newUser  = User(name: user.displayName ?? '',email: user.email ?? '');


         state = state.copyWith(isLoading: false ,user: newUser , error: null  , success: "Login Feito com Sucesso",typeError: null);


      }

    }
    catch(e){

      state = state.copyWith(
        isLoading: false,
         error: "Erro devido ao estar offline ou erro no servidor do google",
        user: null,
        typeError: "server",
        success: null
      );


    }

  }



  Future<void> logout() async {



    try {



      final repo = ref.read(loginProvider);

      await repo.signOut();

      state = state.copyWith(success: 'Logout com sucesso' ,typeError: null ,isLoading: false , user: null , error: null);

    } catch(e){

      state = state.copyWith(success: null ,typeError: 'logout' ,isLoading: false  , error: 'Falha  ao fazer logout');


    }

  }



}