import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meeting_scheduler/services/database/database.dart';
import 'package:meeting_scheduler/services/models/auth/user_model.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/shared/utils/failure.dart';
import 'package:meeting_scheduler/shared/utils/type_def.dart';

class AuthRepository {
  const AuthRepository._();
  static const instance = AuthRepository._();
  static const Database database = Database.instance;

  //!  SIGN UP
  FutureEither<AuthResult> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    UserCredential? loggedInUser;

    try {
      loggedInUser = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (loggedInUser.user?.uid != null) {
        bool isUpdateSuccessful = await database.saveUserInfo(
          email: email,
          userId: loggedInUser.user?.uid,
          fullName: fullName,
        );

        return isUpdateSuccessful
            ? right(AuthResult.success)
            : left(
                Failure(failureMessage: "Failed to register user"),
              );
      } else {
        return left(Failure(failureMessage: "Failed to register user"));
      }
    } on FirebaseAuthException catch (error) {
      error.toString().log();

      return left(
        Failure(failureMessage: "Failed to register user"),
      );
    }
  }

  //!  LOGIN
  FutureEither<AuthResult> login({
    required String email,
    required String password,
  }) async {
    UserCredential? loggedInUser;

    try {
      loggedInUser = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (loggedInUser.user?.uid != null) {
        UserModel? userData = await database.getUserInfo(
          email: email,
          userId: loggedInUser.user?.uid,
        );

        if (userData != null) {
          return right(AuthResult.success);
        } else {
          return left(
            Failure(failureMessage: "Could not fetch user info"),
          );
        }
      } else {
        return left(Failure(failureMessage: "Failed to login user"));
      }
    } on FirebaseAuthException catch (error) {
      error.toString().log();

      return left(
        Failure(failureMessage: "Failed to login user"),
      );
    }
  }

  //!
  //! LOGOUT
  Future<void> logOut() async => await FirebaseAuth.instance.signOut();
}
