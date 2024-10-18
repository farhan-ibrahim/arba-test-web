import 'package:arba_test_web/src/model/user.dart';
import 'package:arba_test_web/src/repositories/auth.dart';
import 'package:bloc/bloc.dart';

class AuthState {
  final bool isLoggedIn;
  final User? user;
  final String? error;

  const AuthState({
    this.isLoggedIn = false,
    this.user,
    this.error,
  });

  AuthState.copyWith({
    bool? isLoggedIn,
    this.user,
    this.error,
  }) : isLoggedIn = isLoggedIn ?? false;
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  void login(String email, String password) async {
    // Call the login method from the repository
    try {
      final user = await AuthRepository().login(email, password);
      if (user != null) {
        emit(AuthState.copyWith(isLoggedIn: true, user: user));
      }
    } catch (e) {
      emit(AuthState.copyWith(error: "An error occurred: ${e.toString()}"));
    }
  }

  void register(String email, String password, String name) async {
    // Call the register method from the repository
    try {
      final user = await AuthRepository().register(email, password, name);
      if (user != null) {
        emit(AuthState.copyWith(user: user));
      }
    } catch (e) {
      emit(AuthState.copyWith(error: "An error occurred: ${e.toString()}"));
    }
  }

  void logout() {
    try {
      AuthRepository().logout();
    } catch (e) {
      emit(AuthState(error: "An error occurred: ${e.toString()}"));
    }
    emit(const AuthState());
  }

  void clearError() {
    emit(const AuthState());
  }
}
