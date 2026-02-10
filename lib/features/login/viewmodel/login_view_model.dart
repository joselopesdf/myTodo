
import 'package:dev/features/login/model/login_model.dart';
import 'package:dev/features/login/state/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/local_user_provider.dart';
import '../model/hive_user_model.dart';
import '../repository/login_repository.dart';


final isAdminProvider = Provider<bool>((ref) {
  final state = ref.watch(loginNotifierProvider);
  return state.user?.role == 'admin';
});




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

      final store = ref.read(firestoreProvider);


      final user = await repo.signInWithGoogle();

      print("user retornado: $user"); // DEBUG


      if (user == null) {

        state = state.copyWith(isLoading: false , user:  null , error: "Login Cancelado pelo Usuario",typeError: "null") ;

      }

       else {


        User  newUser  = User(name: user.displayName ?? '',email: user.email ?? '' ,id:  user.uid );






        final docRef = store.collection('users').doc(newUser.id);

        final docSnapshot = await docRef.get();




        if (!docSnapshot.exists) {

          await docRef.set(newUser.toMap());

          await ref.read(localUserProvider.notifier).save(
            LocalUser(
              id: newUser.id,
              name: newUser.name,
              email: newUser.email,
              role: newUser.role
            ),
          );


        } else {

          final userFirebase = User.fromMap(docSnapshot, id: newUser.id);



       newUser = newUser.copyWith(role:userFirebase.role,email: userFirebase.email ,name: userFirebase.name );

          await ref.read(localUserProvider.notifier).save(
            LocalUser(
              id: newUser.id,
              name: newUser.name,
              email: newUser.email,
              role: newUser.role
            ),
          );


          print("user do firebase $userFirebase");



         print("Usuario logado ${user.displayName}");

         print("Usuario atual ${repo.currentUser}");
      }



        state = state.copyWith(isLoading: false ,user: newUser , error: null  , success: "Login Feito com Sucesso",typeError: null);

        print("logado com sucesso dados ${state.user!.email} ---  ${state.user!.role}");
       }

    }
    catch(e){

      state = state.copyWith(
        isLoading: false,
         error: "Erro no servidor google ao fazer login",
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

      state = state.copyWith(isLogout: true,user: null ,error: null);

      await ref.read(localUserProvider.notifier).clear() ;



      print("Usuario deslogado ${repo.currentUser?.displayName}");

      print("Usuario atual ${repo.currentUser}");

      print("deslogado com sucesso dados ${state.user!.email} ---  ${state.user!.role}");

    } catch(e){

      state = state.copyWith(error: "Erro ao fazer logout" ,isLogout: false);




    }

  }



}