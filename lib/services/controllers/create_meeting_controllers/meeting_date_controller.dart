// ignore_for_file: avoid_public_notifier_properties
import 'package:flutter/material.dart';
import 'package:meeting_scheduler/shared/utils/utils.dart';
import 'package:meeting_scheduler/theme/theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part "meeting_date_controller.g.dart";

@riverpod
class MeetingDateController extends _$MeetingDateController {
  @override
  FutureOr<DateTime?> build() => null;

  Future<void> createMeetingDate({
    required BuildContext context,
  }) async {
    final DateTime? result = await showDatePicker(
      initialDate: DateTime.now(),
      context: context,
      firstDate: DateTime(2023, 1, 1),
      lastDate: DateTime(2100, 12, 31),
      currentDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendar,
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

  String get getMeetingDate => toString();

  @override
  String toString() =>
      "${state.value?.day} / ${AppUtils.getMonth(dateTime: state.value!)} / ${state.value?.year}";
}
