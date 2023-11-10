import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class AppConstants {
  const AppConstants._();

//! PIN PUT CONSTANT
  static final PinTheme otpVerificationDefaultPinTheme = PinTheme(
    width: 76,
    height: 60,
    textStyle: const TextStyle(
      fontSize: 24,
      color: Color.fromRGBO(30, 60, 87, 1),
      fontWeight: FontWeight.w700,
    ),
    decoration: BoxDecoration(
      border: Border.all(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
