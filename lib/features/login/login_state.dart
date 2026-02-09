

import 'login_model.dart';




class LoginState  {
  final bool isLoading;
  final User? user;
  final String? error;
  final String? success;
  final String? typeError ;

  const LoginState({
    this.isLoading = false,
    this.user,
    this.error,
    this.success,
    this.typeError
  });

  LoginState copyWith({
    bool? isLoading,
    User? user,
    String? error,
    String? success,
    String? typeError
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error ?? this.error,
      success: success ?? this.success,
      typeError: typeError ?? this.typeError
    );
  }

  factory LoginState.initial() => const LoginState();
}



