import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meeting_scheduler/services/controllers/auth/state/auth_state.dart';
import 'package:meeting_scheduler/services/repositories/auth/auth_repository.dart';
import 'package:meeting_scheduler/shared/utils/failure.dart';
import 'package:meeting_scheduler/shared/utils/type_def.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(),
);

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository = AuthRepository.instance;
  User? get _user => FirebaseAuth.instance.currentUser;
  UserId? get _userId => _user?.uid;

  //! CONSTRUCTOR
  AuthController() : super(const AuthState.logOut()) {
    if (_userId != null) {
      state = AuthState(
        result: AuthResult.success,
        isLoading: false,
        userId: _userId,
        isLoggedIn: true,
      );
    }
  }

  Future<bool> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    bool didSignUp = false;

    final Either<Failure, AuthResult> result = await _authRepository.signUp(
      fullName: fullName,
      email: email,
      password: password,
    );

    result.fold(
      (Failure failure) => failure.failureMessage?.log(),
      (AuthResult result) {
        "Auth Result: $result".log();

        if (result == AuthResult.success) {
          state = AuthState(
            result: result,
            isLoading: false,
            isLoggedIn: true,
            userId: _userId,
          );

          didSignUp = true;
        }
      },
    );

    return didSignUp;
  }

  //! LOGOUT
  Future<void> logOut() async {
    state = state.copiedWithIsLoading(isLoading: true);

    await _authRepository.logOut();

    state = const AuthState.logOut();
  }
}
