import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';


final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn();
});


final loginProvider = Provider <AuthRepository>( (ref) {

  final auth = ref.watch(firebaseAuthProvider) ;

  final google = ref.watch(googleSignInProvider);


  return AuthRepository(auth, google);
});

class AuthRepository {
  final FirebaseAuth _auth;
  final GoogleSignIn _google;


  AuthRepository(this._auth, this._google );

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<User?> signInWithGoogle() async {

    try {

      final googleUser = await _google.signIn();
      if (googleUser == null)  {

        print(" usuario desistiu de logar") ;

        return null;
      }   // Usuário cancelou login

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      print(" usuario email ${userCredential.user?.email} ") ;

      print(" usuario nome ${userCredential.user?.displayName} ") ;



      return userCredential.user;
    } catch (e) {

      print("Erro no login com Google: $e");
      // Relança para que o Notifier ou Controller trate
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {

      await _google.signOut();
      await _auth.signOut();
      print('logout com sucesso');
    } catch (e) {
      print("Erro no logout: $e");
      rethrow;
    }
  }

}

