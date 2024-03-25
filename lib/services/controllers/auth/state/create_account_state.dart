import 'package:flutter/foundation.dart' show immutable;

@immutable
class CreateAccountState {
  final String fullName;
  final String password;
  final String email;

  const CreateAccountState({
    required this.fullName,
    required this.password,
    required this.email,
  });

  const CreateAccountState.init()
      : fullName = "",
        password = "",
        email = "";

  //! AUTH STATE WITH IS LOADING
  CreateAccountState updateDetails({
    required String password,
    required String email,
    required String fullName,
  }) =>
      CreateAccountState(
        fullName: fullName,
        password: password,
        email: email,
      );

  @override
  bool operator ==(covariant CreateAccountState other) =>
      identical(this, other) ||
      (fullName == other.fullName &&
          password == other.password &&
          email == other.email);

  @override
  int get hashCode => Object.hash(
        fullName,
        password,
        email,
      );

  @override
  String toString() =>
      "fullName: $fullName | password: $password | email: $email ";
}
