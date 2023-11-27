import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meeting_scheduler/services/controllers/auth/state/auth_state.dart';
import 'package:meeting_scheduler/services/repositories/auth/auth_repository.dart';
import 'package:meeting_scheduler/shared/utils/failure.dart';
import 'package:meeting_scheduler/shared/utils/type_def.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/shared/utils/utils.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(controllerRef: ref),
);

class AuthController extends StateNotifier<AuthState> {
  User? get _user => FirebaseAuth.instance.currentUser;
  UserId? get _userId => _user?.uid;
  final Ref? _authControllerRef;

  //! CONSTRUCTOR
  AuthController({
    required Ref? controllerRef,
  })  : _authControllerRef = controllerRef,
        super(const AuthState.logOut()) {
    if (_userId != null) {
      state = AuthState(
        result: AuthResult.success,
        isLoading: false,
        userId: _userId,
        isLoggedIn: true,
      );
    }
  }

  Future<void> authenticateSignUp({
    required bool isValidated,
    required String fullName,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    await signUp(
      fullName: fullName,
      email: email,
      password: password,
      context: context,
    );
  }

  Future<void> authenticateLogin({
    required bool isValidated,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    "Authenticating login".log();
    await login(
      email: email,
      password: password,
      context: context,
    );
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = state.copiedWithIsLoading(isLoading: true);

    await Future.delayed(const Duration(seconds: 3));

    final Either<Failure, AuthResult> result =
        await _authControllerRef!.read(authRepositoryProvider).signUp(
              fullName: fullName,
              email: email,
              password: password,
            );

    result.fold(
      (Failure failure) {
        failure.failureMessage?.log();

        AppUtils.showAppBanner(
          message: failure.failureMessage ?? "Sign up failed, please try again",
          context: context,
        );

        Future.delayed(
          const Duration(seconds: 4),
        );

        AppUtils.closeAppBanner(context: context);

        state = state.copiedWithIsLoading(isLoading: false);
      },
      (AuthResult result) {
        "Auth Result: $result".log();

        if (result == AuthResult.success) {
          true.withHapticFeedback();

          state = AuthState(
            result: result,
            isLoading: false,
            isLoggedIn: true,
            userId: _userId,
          );
        }
      },
    );
  }

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    "Logging in".log();

    state = state.copiedWithIsLoading(isLoading: true);

    await Future.delayed(const Duration(seconds: 3));

    final Either<Failure, AuthResult> result =
        await _authControllerRef!.read(authRepositoryProvider).login(
              email: email,
              password: password,
            );

    result.fold(
      (Failure failure) {
        failure.failureMessage?.log();

        AppUtils.showAppBanner(
          message: failure.failureMessage ?? "Sign up failed, please try again",
          context: context,
        );

        Future.delayed(
          const Duration(seconds: 4),
        );

        AppUtils.closeAppBanner(context: context);

        state = state.copiedWithIsLoading(isLoading: false);
      },
      (AuthResult result) {
        "Auth Result: $result".log();

        if (result == AuthResult.success) {
          true.withHapticFeedback();

          state = AuthState(
            result: result,
            isLoading: false,
            isLoggedIn: true,
            userId: _userId,
          );
        }
      },
    );
  }

  //! LOGOUT
  Future<void> logOut() async {
    state = state.copiedWithIsLoading(isLoading: true);

    await _authControllerRef!.read(authRepositoryProvider).logOut();

    state = const AuthState.logOut();
  }
}
