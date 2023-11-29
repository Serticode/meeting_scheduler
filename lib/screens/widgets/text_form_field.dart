import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';

class CustomTextFormField extends ConsumerStatefulWidget {
  final bool isForPassword;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final bool? isPasswordVisible;
  final String? Function(String?)? validator;
  const CustomTextFormField({
    super.key,
    required this.isForPassword,
    required this.hint,
    required this.controller,
    this.isPasswordVisible,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends ConsumerState<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.isPasswordVisible ?? false,
      keyboardAppearance: Brightness.dark,
      decoration: InputDecoration(
        hintText: widget.hint,

        hintStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
          color: Colors.black38,
        ),
        errorStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14.0,
          color: AppColours.red,
        ),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        suffixIconColor:
            widget.isPasswordVisible != null && !widget.isPasswordVisible!
                ? AppColours.deepBlue
                : AppColours.warmGrey,
        prefixIconColor: AppColours.black50,

        //! BORDERS
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1.2,
            color: Colors.black12,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1.6,
            color: AppColours.primaryBlue,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.6,
            color: AppColours.red,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.6,
            color: AppColours.red,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: widget.validator,
    );
  }
}
