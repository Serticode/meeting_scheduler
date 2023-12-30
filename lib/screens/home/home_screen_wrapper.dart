import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/router/router.dart';
import 'package:meeting_scheduler/router/routes.dart';
import 'package:meeting_scheduler/screens/widgets/bottom_nav_bar_item.dart';
import 'package:meeting_scheduler/services/controllers/home_wrapper/home_wrapper_controller.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';

class HomeScreenWrapper extends ConsumerWidget {
  const HomeScreenWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPageIndex = ref.watch(homeWrapperControllerProvider).value;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(toolbarHeight: 0),

      //! BODY
      body: ref
          .read(homeWrapperControllerProvider.notifier)
          .screens
          .elementAt(currentPageIndex ?? 0)
          .generalPadding,

      //! FAB
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => AppNavigator.instance.navigateToPage(
          thePageRouteName: AppRoutes.createMeeting,
          context: context,
        ),
        backgroundColor: AppColours.deepBlue,
        child: const Icon(
          Icons.add,
          color: AppColours.white,
        ),
      ),

      //!
      //! BOTTOM NAV BAR
      bottomNavigationBar: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: ref
            .read(homeWrapperControllerProvider.notifier)
            .bottomNavBarItemNames
            .map(
              (label) => CustomBottomNavBarItem(
                onTap: () {
                  ref
                      .read(homeWrapperControllerProvider.notifier)
                      .updatePageIndex(
                        currentPageIndex: ref
                            .read(homeWrapperControllerProvider.notifier)
                            .bottomNavBarItemNames
                            .indexOf(
                              label,
                            ),
                      );
                },
                isSelected: currentPageIndex ==
                    ref
                        .read(homeWrapperControllerProvider.notifier)
                        .bottomNavBarItemNames
                        .indexOf(
                          label,
                        ),
                label: label,
                itemIcon: currentPageIndex ==
                        ref
                            .read(homeWrapperControllerProvider.notifier)
                            .bottomNavBarItemNames
                            .indexOf(
                              label,
                            )
                    ? ref
                        .read(homeWrapperControllerProvider.notifier)
                        .bottomNavBarItemIconsSolid
                        .elementAt(
                          ref
                              .read(homeWrapperControllerProvider.notifier)
                              .bottomNavBarItemNames
                              .indexOf(
                                label,
                              ),
                        )
                    : ref
                        .read(homeWrapperControllerProvider.notifier)
                        .bottomNavBarItemIcons
                        .elementAt(
                          ref
                              .read(homeWrapperControllerProvider.notifier)
                              .bottomNavBarItemNames
                              .indexOf(
                                label,
                              ),
                        ),
              ),
            )
            .toList(),
      ),
    );
  }
}
