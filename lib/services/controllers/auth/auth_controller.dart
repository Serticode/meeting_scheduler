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

  Future<void> validateSignUp({
    required bool isValidated,
    required String fullName,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    if (isValidated) {
      await signUp(
        fullName: fullName,
        email: email,
        password: password,
        context: context,
      );
    }
  }

  Future<void> validateLogin({
    required bool isValidated,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    if (isValidated) {
      await login(
        email: email,
        password: password,
        context: context,
      );
    }
  }

  Future<void> validateProfileUpdate({
    required bool isValidated,
    required String email,
    required String fullName,
    required String profession,
    required String phoneNumber,
    required BuildContext context,
  }) async {
    if (isValidated) {
      await updateUserInfo(
        email: email,
        fullName: fullName,
        profession: profession,
        phoneNumber: phoneNumber,
        context: context,
      );
    }
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = state.copiedWithIsLoading(isLoading: true);

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
    state = state.copiedWithIsLoading(isLoading: true);

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

  Future<void> updateUserInfo({
    required String email,
    required String fullName,
    required String profession,
    required String phoneNumber,
    required BuildContext context,
  }) async {
    state = state.copiedWithIsLoading(isLoading: true);

    final Either<Failure, bool> result = await _authControllerRef!
        .read(authRepositoryProvider)
        .updateUserProfile(
          email: email,
          fullName: fullName,
          profession: profession,
          phoneNumber: phoneNumber,
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
      (bool result) {
        if (result) {
          true.withHapticFeedback();

          state = state.copiedWithIsLoading(isLoading: false);
        }
      },
    );
  }

  //! LOGOUT
  Future<void> logOut() async {
    state = state.copiedWithIsLoading(isLoading: true);

    await Future.delayed(const Duration(seconds: 1));

    await _authControllerRef!.read(authRepositoryProvider).logOut();

    state = const AuthState.logOut();
  }
}
