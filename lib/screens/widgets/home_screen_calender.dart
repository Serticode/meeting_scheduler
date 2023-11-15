import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/shared/utils/utils.dart';

class HomeScreenCalender extends ConsumerStatefulWidget {
  const HomeScreenCalender({super.key});

  @override
  ConsumerState<HomeScreenCalender> createState() => _HomeScreenCalenderState();
}

class _HomeScreenCalenderState extends ConsumerState<HomeScreenCalender> {
  int currentDateSelectedIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: ListView.builder(
        itemCount: 365,
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),

        //!
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: currentDateSelectedIndex == index
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
                      color: currentDateSelectedIndex == index
                          ? Colors.white
                          : AppColours.black50.withOpacity(0.3),
                    ),

                //!
                5.0.sizedBoxHeight,

                DateTime.now().add(Duration(days: index)).day.toString().txt16(
                      fontWeight: FontWeight.w700,
                      color: currentDateSelectedIndex == index
                          ? AppColours.white
                          : AppColours.greyBlack,
                    )
              ],
            ),
          ).onTap(
            onTap: () => setState(() => currentDateSelectedIndex = index),
          );
        },
      ),
    );
  }
}
