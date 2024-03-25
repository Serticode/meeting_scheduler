import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/shared/app_elements/app_texts.dart';
import 'package:meeting_scheduler/shared/utils/type_def.dart';

final otpControllerProvider = StateNotifierProvider<OTPController, IsOTPSent>(
  (ref) => OTPController(controllerRef: ref),
);

class OTPController extends StateNotifier<IsOTPSent> {
  final Ref? otpControllerRef;
  final EmailOTP otpController = EmailOTP();

  OTPController({
    required Ref? controllerRef,
  })  : otpControllerRef = controllerRef,
        super(false);

  Future<void> initConfig({
    String? userEmail,
  }) async {
    await otpController.setConfig(
      appName: AppTexts.appName,
      appEmail: "customerService@meetingScheduler.com",
      userEmail: FirebaseAuth.instance.currentUser?.email ?? userEmail,
      otpLength: 4,
      otpType: OTPType.digitsOnly,
    );
  }

  Future<bool> sendOTP() async {
    state = true;
    final result = await otpController.sendOTP();
    await Future.delayed(const Duration(seconds: 2));
    state = false;
    return result;
  }

  Future<bool> verifyOTP({var otp}) async {
    state = true;
    final result = await otpController.verifyOTP(otp: otp);
    await Future.delayed(const Duration(seconds: 2));
    state = false;
    return result;
  }
}
