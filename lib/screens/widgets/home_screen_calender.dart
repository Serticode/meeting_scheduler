import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/screens/widgets/app_loader.dart';
import 'package:meeting_scheduler/services/controllers/calender_controller/calender_controller.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/shared/utils/utils.dart';

class HomeScreenCalender extends ConsumerWidget {
  const HomeScreenCalender({super.key});
  static final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 75,
      child: ListView.builder(
        itemCount: 365,
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),

        //!
        itemBuilder: (BuildContext context, int index) {
          final currentDateSelectedIndex =
              ref.watch(calenderControllerProvider);

          int currentDay = DateTime.now().add(Duration(days: index)).day;

          return currentDateSelectedIndex.when(
            data: (date) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: date == currentDay
                      ? AppColours.buttonBlue
                      : AppColours.white,
                ),
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //! DAY
                    AppUtils.listOfDays
                        .elementAt(
                          DateTime.now().add(Duration(days: index)).weekday - 1,
                        )
                        .substring(0, 1)
                        .txt14(
                          color: date == currentDay
                              ? Colors.white
                              : AppColours.black50.withOpacity(0.3),
                        ),

                    //!
                    5.0.sizedBoxHeight,

                    currentDay.toString().txt16(
                          fontWeight: FontWeight.w700,
                          color: date == currentDay
                              ? AppColours.white
                              : AppColours.greyBlack,
                        )
                  ],
                ),
              ).onTap(
                onTap: () =>
                    ref.read(calenderControllerProvider.notifier).setDate(
                          query: DateTime.now().add(Duration(days: index)).day,
                        ),
              );
            },
            error: (error, stackTrace) => "Calender Error: $error".txt14(),
            loading: () => const AppLoader(),
          );
        },
      ),
    );
  }
}
