import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';

class CalenderScreen extends ConsumerWidget {
  const CalenderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.amber,
      child: "Calender Screen".txt24().alignCenter(),
    );
  }
}
