//! THIS FILE CONTAINS HOPEFULLY, ALL EXTENSIONS USED IN THE APP.
import "dart:developer" as dev_tools show log;
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:intl/intl.dart";
import "package:meeting_scheduler/shared/app_elements/app_colours.dart";
import "package:meeting_scheduler/shared/utils/type_def.dart";
import "package:meeting_scheduler/shared/utils/utils.dart";

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
  void sortList() => sort((a, b) {
        //! SPLIT CONCERNS
        List<String> aParts = a.dateOfMeeting.split('/');
        List<String> bParts = b.dateOfMeeting.split('/');

        //! PARSE DAYS MOTHS AND YEAR
        int aDay = int.parse(aParts[0]);
        int aMonth = AppUtils.getMonthNumber(monthName: aParts[1]);
        int aYear = int.parse(aParts[2]);

        int bDay = int.parse(bParts[0]);
        int bMonth = AppUtils.getMonthNumber(monthName: bParts[1]);
        int bYear = int.parse(bParts[2]);

        //! COMPARE YEARS FIRST
        if (aYear != bYear) {
          return bYear.compareTo(aYear);
        }

        //! COMPARE MONTHS IF YEARS ARE THE SAME
        if (aMonth != bMonth) {
          return bMonth.compareTo(aMonth);
        }

        //! IF YEARS AND MONTHS ARE THE SAME, COMPARE DAYS
        return bDay.compareTo(aDay);
      });

  void sortNotification() => sort((a, b) => a.createdAt.compareTo(b.createdAt));
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
        height: h,
      );

  Widget get sizedBoxWidth => SizedBox(
        width: w,
      );

  EdgeInsetsGeometry get verticalPadding => EdgeInsets.symmetric(vertical: h);

  EdgeInsetsGeometry get horizontalPadding =>
      EdgeInsets.symmetric(horizontal: w);

  EdgeInsetsGeometry get symmetricPadding =>
      EdgeInsets.symmetric(vertical: h, horizontal: w);
}

//!
//! PADDING EXTENSION ON WIDGET
extension PaddingExtension on Widget {
  Widget get generalHorizontalPadding => Padding(
        padding: EdgeInsets.symmetric(horizontal: 21.0.w),
        child: this,
      );

  Widget get generalVerticalPadding => Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: this,
      );

  Widget get generalPadding => Padding(
        padding: EdgeInsets.symmetric(
          vertical: 12.0.h,
          horizontal: 21.0.w,
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
        fontSize: 30.0.sp,
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
        fontSize: 16.0.sp,
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
        fontSize: fontSize?.sp ?? 12.0.sp,
        height: height,
        color: color ?? AppColours.greyBlack,
        fontWeight: fontWeight ?? FontWeight.w400,
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
        fontSize: 12.0.sp,
        height: height,
        color: color ?? AppColours.greyBlack,
        fontWeight: fontWeight ?? FontWeight.w500,
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
        fontSize: 14.0.sp,
        color: color ?? AppColours.greyBlack,
        fontWeight: fontWeight ?? FontWeight.w500,
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
        fontSize: 16.0.sp,
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
        fontSize: 24.0.sp,
        color: color ?? AppColours.greyBlack,
        fontWeight: fontWeight ?? FontWeight.w600,
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
