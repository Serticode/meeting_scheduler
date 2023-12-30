import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meeting_scheduler/services/database/database.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/shared/utils/failure.dart';
import 'package:meeting_scheduler/shared/utils/type_def.dart';

final Provider<AuthRepository> authRepositoryProvider =
    Provider((ref) => const AuthRepository._());

class AuthRepository {
  const AuthRepository._() : super();
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
            : left(Failure(failureMessage: "Failed to register user"));
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
        return right(AuthResult.success);
      } else {
        return left(Failure(failureMessage: "Failed to login user"));
      }
    } on FirebaseAuthException catch (error) {
      error.toString().log();

      return left(
        Failure(failureMessage: "Invalid email or password"),
      );
    }
  }

  //! CHANGE PASSWORD
  FutureEither<bool> changePassword({
    required String newPassword,
    required String currentPassword,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    AuthCredential? userCredential;

    if (user != null) {
      userCredential = EmailAuthProvider.credential(
          email: user.email!, password: currentPassword);

      await user
          .reauthenticateWithCredential(userCredential)
          .then((value) async {
        await user.updatePassword(newPassword).then((_) {}).catchError((error) {
          "User update password error: $error".log();
        });
      }).catchError((err) {
        "User error from update password: $err".log();
      });

      return right(true);
    } else {
      return left(Failure(failureMessage: "Change password failed"));
    }
  }

  //!  UPDATE USER PROFILE
  FutureEither<bool> updateUserProfile({
    required String email,
    required String fullName,
    required String profession,
    required String phoneNumber,
  }) async {
    try {
      final isUserUpdated = await database.updateUserInfo(
        userId: FirebaseAuth.instance.currentUser?.uid,
        fullName: fullName,
        email: email,
        profession: profession,
        phoneNumber: phoneNumber,
      );

      if (isUserUpdated) {
        return right(isUserUpdated);
      } else {
        return left(Failure(failureMessage: "Failed to update profile"));
      }
    } on FirebaseAuthException catch (error) {
      error.toString().log();

      return left(
        Failure(failureMessage: "Failed to update profile"),
      );
    }
  }

  //! SEND OTP
  FutureEither<bool> sendVerificationCode({
    required String phoneNumber,
  }) async {
    try {
      bool verificationSent = false;

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          "Verification completed: ${credential.smsCode} $credential".log();
        },
        verificationFailed: (FirebaseAuthException exception) {
          "Verification failed: ${exception.message} $exception".log();
        },
        codeSent: (String verificationId, int? resendToken) {
          "Code Sent: VerificationID: $verificationId ResendToken: $resendToken"
              .log();

          verificationSent = true;
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 90),
        //forceResendingToken: null,
        //verificationCompletedForTesting: null, // for testing
      );

      return right(verificationSent);
    } on FirebaseAuthException catch (error) {
      "Firebase Auth Error: $error".log();

      return left(
        Failure(failureMessage: "Failed to send verification code"),
      );
    }
  }

  //!
  //! LOGOUT
  Future<void> logOut() async => await FirebaseAuth.instance.signOut();
}
