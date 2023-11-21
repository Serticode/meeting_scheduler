import 'package:flutter/foundation.dart' show immutable;
import 'package:meeting_scheduler/shared/utils/type_def.dart';

@immutable
class AuthState {
  final AuthResult? result;
  final bool isLoading;
  final bool isLoggedIn;
  final UserId? userId;

  const AuthState({
    required this.result,
    required this.isLoading,
    required this.userId,
    required this.isLoggedIn,
  });

  const AuthState.logOut()
      : result = null,
        isLoading = false,
        isLoggedIn = false,
        userId = null;

  //! AUTH STATE WITH IS LOADING
  AuthState copiedWithIsLoading({
    required bool isLoading,
  }) =>
      AuthState(
        result: result,
        isLoading: isLoading,
        isLoggedIn: isLoggedIn,
        userId: userId,
      );

  AuthState copiedWithCurrentUser({
    required UserId userId,
  }) =>
      AuthState(
        result: result,
        isLoading: isLoading,
        isLoggedIn: isLoggedIn,
        userId: userId,
      );

  @override
  bool operator ==(covariant AuthState other) =>
      identical(this, other) ||
      (result == other.result &&
          isLoading == other.isLoading &&
          isLoggedIn == other.isLoggedIn &&
          userId == other.userId);

  @override
  int get hashCode => Object.hash(
        result,
        isLoading,
        isLoggedIn,
        userId,
      );

  @override
  String toString() =>
      "Result: $result | isLoading: $isLoading | isLoggedIn: $isLoggedIn | UserID: $userId";
}
