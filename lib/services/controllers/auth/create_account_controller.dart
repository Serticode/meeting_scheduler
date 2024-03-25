import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/services/controllers/auth/state/create_account_state.dart';

final createAccountControllerProvider =
    StateNotifierProvider<CreateAccountController, CreateAccountState>(
  (ref) => CreateAccountController(),
);

class CreateAccountController extends StateNotifier<CreateAccountState> {
  //! CONSTRUCTOR
  CreateAccountController() : super(const CreateAccountState.init());

  Future<void> updateDetails({
    required String fullName,
    required String email,
    required String password,
  }) async {
    state = state.updateDetails(
      password: password,
      email: email,
      fullName: fullName,
    );
  }
}
