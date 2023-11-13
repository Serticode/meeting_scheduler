// ignore_for_file: avoid_public_notifier_properties
import 'package:flutter/material.dart';
import 'package:meeting_scheduler/theme/theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part "meeting_time_controller.g.dart";

//!
//!
//! START TIME
@riverpod
class MeetingStartTimeController extends _$MeetingStartTimeController {
  @override
  FutureOr<TimeOfDay?> build() => null;

  String amOrPM = "";

  Future<void> createMeetingTime({
    required BuildContext context,
  }) async {
    final TimeOfDay? result = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      builder: (context, child) => Theme(
        data: AppTheme.dateRangePickerTheme,
        child: child!,
      ),
    );

    if (result != null) {
      amOrPM = result.period.name.toUpperCase();
      state = AsyncValue.data(result);
    } else {
      state = const AsyncValue.data(null);
    }
  }

  String get getMeetingTime => toString();

  void setStartTime({
    required String theTime,
  }) {
    final List<String> times = theTime.split(":");
    amOrPM = times.elementAt(1).split(" ").last;

    TimeOfDay time = TimeOfDay(
        hour: int.tryParse(times.elementAt(0).trim())!,
        minute: int.tryParse(times.elementAt(1).split(" ")[1].trim())!);

    state = AsyncValue.data(time);
  }

  @override
  String toString() =>
      "${state.value?.hourOfPeriod} : ${state.value?.minute} $amOrPM";
}

//!
//!
//! END TIME
@riverpod
class MeetingEndTimeController extends _$MeetingEndTimeController {
  @override
  FutureOr<TimeOfDay?> build() => null;

  String amOrPM = "";

  Future<void> createMeetingTime({
    required BuildContext context,
  }) async {
    final TimeOfDay? result = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      builder: (context, child) => Theme(
        data: AppTheme.dateRangePickerTheme,
        child: child!,
      ),
    );

    if (result != null) {
      amOrPM = result.period.name.toUpperCase();
      state = AsyncValue.data(result);
    } else {
      state = const AsyncValue.data(null);
    }
  }

  String get getMeetingTime => toString();

  void setEndTime({
    required String theTime,
  }) {
    final List<String> times = theTime.split(":");
    amOrPM = times.elementAt(1).split(" ").last;

    TimeOfDay time = TimeOfDay(
      hour: int.tryParse(times.elementAt(0).trim())!,
      minute: int.tryParse(times.elementAt(1).split(" ")[1].trim())!,
    );

    state = AsyncValue.data(time);
  }

  @override
  String toString() =>
      "${state.value?.hourOfPeriod} : ${state.value?.minute} $amOrPM";
}
