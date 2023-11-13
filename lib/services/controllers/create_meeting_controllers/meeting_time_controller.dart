// ignore_for_file: avoid_public_notifier_properties
import 'package:flutter/material.dart';
import 'package:meeting_scheduler/theme/theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part "meeting_time_controller.g.dart";

//! START TIME
@riverpod
class MeetingStartTimeController extends _$MeetingStartTimeController {
  @override
  FutureOr<TimeOfDay?> build() => null;

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
      state = AsyncValue.data(result);
    } else {
      state = const AsyncValue.data(null);
    }
  }

  String get getMeetingTime => toString();

  @override
  String toString() =>
      "${state.value?.hourOfPeriod} : ${state.value?.minute} ${state.value?.period.name.toUpperCase()}";
}

//!
//! END TIME
@riverpod
class MeetingEndTimeController extends _$MeetingEndTimeController {
  @override
  FutureOr<TimeOfDay?> build() => null;

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
      state = AsyncValue.data(result);
    } else {
      state = const AsyncValue.data(null);
    }
  }

  String get getMeetingTime => toString();

  @override
  String toString() =>
      "${state.value?.hourOfPeriod} : ${state.value?.minute} ${state.value?.period.name.toUpperCase()}";
}
