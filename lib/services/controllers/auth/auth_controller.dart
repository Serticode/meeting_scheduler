import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meeting_scheduler/services/controllers/auth/state/auth_state.dart';
import 'package:meeting_scheduler/services/repositories/auth/auth_repository.dart';
import 'package:meeting_scheduler/shared/utils/failure.dart';
import 'package:meeting_scheduler/shared/utils/type_def.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
part "auth_controller.g.dart";

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  final AuthRepository _authRepository = AuthRepository.instance;
  User? get _user => FirebaseAuth.instance.currentUser;
  UserId? get _userId => _user?.uid;

  @override
  FutureOr<AuthState> build() => const AuthState.logOut();

  //! CONSTRUCTOR
  /* AuthController() : super(const AuthState.logOut()) {
    /* if (_userId != null) {
      state = AuthState(
        result: AuthResult.success,
        isLoading: false,
        userId: _userId,
        isLoggedIn: true,
      );
    } */
  } */

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

        /* if (result == AuthResult.success) {
          state = AuthState(
            result: result,
            isLoading: false,
            isLoggedIn: true,
            userId: _userId,
          );

          didSignUp = true;
        } */
      },
    );

    return didSignUp;
  }

  /* //! UPDATE APP STATE
  void updateAuthStateWithUserDetail({UserId? userId, UserModel? user}) =>
      state = state.copiedWithCurrentUser(userId: userId!);
 */
  //! LOGOUT
  Future<void> logOut() async {
    /*  state = state.copiedWithIsLoading(isLoading: true);

    await _authRepository.logOut();

    state = const AuthState.logOut(); */
  }
}

/* @Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  //!
  @override
  FutureOr<AuthState> build() => const AuthState.logOut();
  final AuthRepository _authRepository = AuthRepository.instance;

  User? get _user => FirebaseAuth.instance.currentUser;
  UserId? get _userId => _user?.uid;

/*
  User? get user => FirebaseAuth.instance.currentUser;
  UserId? get userId => user?.uid;
  bool get isAlreadyLoggedIn => userId != null;
  String get displayName => user?.displayName ?? "";
  String? get email => user?.email;
*/

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
          state = AsyncValue.data(
            AuthState(
              result: result,
              isLoading: false,
              isLoggedIn: true,
              userId: _userId,
            ),
          );

          didSignUp = true;
        }
      },
    );

    return didSignUp;
  }
} */
