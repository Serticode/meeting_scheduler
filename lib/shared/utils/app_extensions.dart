//! THIS FILE CONTAINS HOPEFULLY, ALL EXTENSIONS USED IN THE APP.
import "dart:developer" as dev_tools show log;
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:intl/intl.dart";
import "package:meeting_scheduler/shared/app_elements/app_colours.dart";
import "package:meeting_scheduler/shared/utils/type_def.dart";

//!
//! LOG EXTENSION - THIS HELPS TO CALL A .log() ON ANY OBJECT
//! checks if the app in is debug mode first.
extension Log on Object {
  void log() {
    if (kDebugMode) {
      dev_tools.log(toString());
    }
  }
}

//!
//! EXTENSION ON WIDGET
//! HELPS TO CALL A .dismissKeyboard ON A WIDGET
extension DismissKeyboard on Widget {
  void dismissKeyboard() => FocusManager.instance.primaryFocus?.unfocus();
}

//!
//! USED TO SET STYLE OF STATUS BAR, TO DARK, ACROSS THE APP
extension WidgetAnnotatedRegion on Widget {
  AnnotatedRegion<SystemUiOverlayStyle> darkStatusBar() => AnnotatedRegion(
        value: SystemUiOverlayStyle.dark,
        child: this,
      );
}

extension CollectionName on FileType {
  String get collectionName {
    switch (this) {
      case FileType.image:
        return "images";
    }
  }
}

extension SortExtension on List {
  void sortList() => sort((a, b) => a!.dateOfMeeting!
      .split("/")
      .first
      .trim()
      .compareTo(b!.dateOfMeeting!.split("/").first.trim()));
}

//!
//! HAPTIC FEEDBACK
extension AppHapticFeedback on Widget {
  Widget withHapticFeedback({
    required VoidCallback? onTap,
    required AppHapticFeedbackType? feedbackType,
  }) =>
      InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async => {
          onTap?.call(),
          switch (feedbackType) {
            AppHapticFeedbackType.lightImpact =>
              await HapticFeedback.lightImpact(),
            AppHapticFeedbackType.mediumImpact =>
              await HapticFeedback.mediumImpact(),
            AppHapticFeedbackType.heavyImpact =>
              await HapticFeedback.heavyImpact(),
            AppHapticFeedbackType.selectionClick =>
              await HapticFeedback.selectionClick(),
            AppHapticFeedbackType.vibrate => await HapticFeedback.vibrate(),
            _ => null
          },
        },
        child: this,
      );
}

extension HapticFeedbackForApp on bool {
  Future<void> withHapticFeedback() async => switch (this) {
        true => await HapticFeedback.mediumImpact(),
        false => await HapticFeedback.heavyImpact(),
      };
}

//!
//! EXTENSIONS ON TRANSFORM
extension TransformExtension on Widget {
  Widget transformToScale({
    required double scale,
  }) =>
      Transform.scale(
        scale: scale,
        child: this,
      );
}

//!
//! IGNORE POINTER
extension IgnorePointerExtension on Widget {
  ignorePointer({
    required bool isLoading,
  }) =>
      IgnorePointer(
        ignoring: isLoading,
        child: this,
      );
}

//!
//! EXTENSIONS ON NUMBER
extension WidgetExtensions on double {
  Widget get sizedBoxHeight => SizedBox(
        height: this,
      );

  Widget get sizedBoxWidth => SizedBox(
        width: this,
      );

  EdgeInsetsGeometry get verticalPadding =>
      EdgeInsets.symmetric(vertical: this);

  EdgeInsetsGeometry get horizontalPadding =>
      EdgeInsets.symmetric(horizontal: this);

  EdgeInsetsGeometry get symmetricPadding =>
      EdgeInsets.symmetric(vertical: this, horizontal: this);
}

//!
//! PADDING EXTENSION ON WIDGET
extension PaddingExtension on Widget {
  Widget get generalHorizontalPadding => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21),
        child: this,
      );

  Widget get generalVerticalPadding => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: this,
      );

  Widget get generalPadding => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 21,
        ),
        child: this,
      );
}

//!
//! EXTENSIONS ON STRING
extension ImagePath on String {
  String get png => 'assets/images/$this.png';
  String get jpg => 'assets/images/$this.jpg';
  String get gif => 'assets/images/$this.gif';
}

extension VectorPath on String {
  String get svg => 'assets/vectors/$this.svg';
}

extension StringCasingExtension on String {
  String? camelCase() => toBeginningOfSentenceCase(this);

  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');

  String? trimSpaces() => replaceAll(" ", "");
}

//!
//! ALIGNMENT EXTENSIONS
extension AlignExtension on Widget {
  Align align(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: this,
    );
  }

  Align alignCenter() {
    return Align(
      child: this,
    );
  }

  Align alignCenterLeft() {
    return Align(
      alignment: Alignment.centerLeft,
      child: this,
    );
  }

  Align alignCenterRight() {
    return Align(
      alignment: Alignment.centerRight,
      child: this,
    );
  }

  Align alignBottomCenter() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: this,
    );
  }
}

//!
//! ANIMATION EXTENSION
extension WidgetAnimation on Widget {
  Animate fadeInFromBottom({
    Duration? delay,
    Duration? animationDuration,
    Offset? offset,
    AnimationController? controller,
  }) =>
      animate(
        delay: delay ?? 300.ms,
        controller: controller,
      )
          .move(
            duration: animationDuration ?? 300.ms,
            begin: offset ?? const Offset(0, 10),
          )
          .fade(
            duration: animationDuration ?? 300.ms,
            curve: Curves.fastOutSlowIn,
          );

  Animate fadeIn({
    Duration? delay,
    Duration? animationDuration,
    Curve? curve,
    AnimationController? controller,
  }) =>
      animate(
        delay: delay ?? 300.ms,
        controller: controller,
      ).fade(
        duration: animationDuration ?? 300.ms,
        curve: curve ?? Curves.decelerate,
      );
}

//!
//! STYLED TEXT EXTENSION ON STRING
extension StyledTextExtension on String {
  Text onboardingHeaderText({
    Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
    FontStyle? fontStyle,
    TextOverflow? overflow,
    TextDecoration? decoration,
    TextAlign? textAlign,
    int? maxLines,
    double? height,
  }) {
    return Text(
      this,
      overflow: overflow,
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyle(
        height: height,
        fontSize: 30,
        color: color ?? AppColours.greyBlack,
        fontWeight: fontWeight ?? FontWeight.w700,
        fontFamily: fontFamily,
        fontStyle: fontStyle,
        decoration: decoration,
      ),
    );
  }

  Text onboardingRiderText({
    Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
    FontStyle? fontStyle,
    TextOverflow? overflow,
    TextDecoration? decoration,
    TextAlign? textAlign,
    int? maxLines,
    double? height,
  }) {
    return Text(
      this,
      overflow: overflow,
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyle(
        height: height,
        fontSize: 16,
        color: color ?? AppColours.greyBlack,
        fontWeight: fontWeight ?? FontWeight.w400,
        fontFamily: fontFamily,
        fontStyle: fontStyle,
        decoration: decoration,
      ),
    );
  }

  Text txt({
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    String? fontFamily,
    FontStyle? fontStyle,
    TextOverflow? overflow,
    TextDecoration? decoration,
    TextAlign? textAlign,
    int? maxLines,
    double? height,
  }) {
    return Text(
      this,
      overflow: overflow,
      textAlign: textAlign,
      maxLines: maxLines,
      softWrap: true,
      style: TextStyle(
        fontSize: fontSize ?? 12,
        height: height,
        color: color ?? AppColours.greyBlack,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        fontStyle: fontStyle,
        decoration: decoration,
      ),
    );
  }

  Text txt12({
    Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
    FontStyle? fontStyle,
    TextOverflow? overflow,
    TextDecoration? decoration,
    TextAlign? textAlign,
    int? maxLines,
    double? height,
  }) {
    return Text(
      this,
      overflow: overflow,
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: 12,
        height: height,
        color: color ?? AppColours.greyBlack,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        fontStyle: fontStyle,
        decoration: decoration,
      ),
    );
  }

  Text txt14({
    Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
    FontStyle? fontStyle,
    TextOverflow? overflow,
    TextDecoration? decoration,
    TextAlign? textAlign,
    int? maxLines,
    double? height,
  }) {
    return Text(
      this,
      overflow: overflow,
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyle(
        height: height,
        fontSize: 14,
        color: color ?? AppColours.greyBlack,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        fontStyle: fontStyle,
        decoration: decoration,
      ),
    );
  }

  Text txt16({
    Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
    FontStyle? fontStyle,
    TextOverflow? overflow,
    TextDecoration? decoration,
    TextAlign? textAlign,
    int? maxLines,
    double? height,
  }) {
    return Text(
      this,
      overflow: overflow,
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: 16,
        color: color ?? AppColours.greyBlack,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        fontStyle: fontStyle,
        decoration: decoration,
        height: height,
      ),
    );
  }

  Text txt24({
    Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
    FontStyle? fontStyle,
    TextOverflow? overflow,
    TextDecoration? decoration,
    TextAlign? textAlign,
    int? maxLines,
  }) {
    return Text(
      this,
      overflow: overflow,
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: 24,
        color: color ?? AppColours.greyBlack,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        fontStyle: fontStyle,
        decoration: decoration,
      ),
    );
  }
}

//!
//! INKWELL EXTENSION ON WIDGET
extension InkWellExtension on Widget {
  InkWell onTap({
    required GestureTapCallback? onTap,
    GestureTapCallback? onDoubleTap,
    GestureLongPressCallback? onLongPress,
    BorderRadius? borderRadius,
    Color? splashColor = Colors.transparent,
    Color? highlightColor = Colors.transparent,
  }) {
    return InkWell(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      splashColor: splashColor,
      highlightColor: highlightColor,
      child: this,
    );
  }
}

//!
//! DATE HELPER EXTENSION
const String dateFormatter = 'EEE, dd MMM yyyy';

extension DateHelper on DateTime {
  String formatDate() {
    final formatter = DateFormat(dateFormatter);
    return formatter.format(this);
  }

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  int getDifferenceInDaysWithNow() {
    final now = DateTime.now();
    return now.difference(this).inDays;
  }
}

//!
//! VALUE NOTIFIERS AND VALUE LISTENABLE BUILDERS EXTENSIONS
extension ValueNotifierExtension<AnyType> on AnyType {
  ValueNotifier<AnyType> get toValueNotifier {
    return ValueNotifier<AnyType>(this);
  }
}

extension ValueNotifierBuilderExtension<AnyType> on ValueNotifier<AnyType> {
  Widget toValueListenable({
    required Widget Function(BuildContext context, AnyType value, Widget? child)
        builder,
  }) {
    return ValueListenableBuilder<AnyType>(
      valueListenable: this,
      builder: builder,
    );
  }
}

extension ListenableBuilderExtension on List<Listenable> {
  Widget toMultiValueListenable({
    required Widget Function(BuildContext context, Widget? child) builder,
  }) {
    return ListenableBuilder(
      listenable: Listenable.merge(this),
      builder: builder,
    );
  }
}
