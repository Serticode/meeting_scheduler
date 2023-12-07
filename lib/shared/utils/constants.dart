import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class AppConstants {
  const AppConstants._();

//! PIN PUT CONSTANT
  static final PinTheme otpVerificationDefaultPinTheme = PinTheme(
    width: 76.0.w,
    height: 60.0.h,
    textStyle: TextStyle(
      fontSize: 24.sp,
      color: const Color.fromRGBO(30, 60, 87, 1),
      fontWeight: FontWeight.w700,
    ),
    decoration: BoxDecoration(
      border: Border.all(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
      borderRadius: BorderRadius.circular(10.0.r),
    ),
  );
}
