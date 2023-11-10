import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.cyan,
      child: "Home Screen".txt24().alignCenter(),
    );
  }
}
