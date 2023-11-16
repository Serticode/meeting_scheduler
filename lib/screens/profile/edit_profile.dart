import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';

class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColours.buttonBlue,
      appBar: AppBar(
        backgroundColor: AppColours.buttonBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColours.white),
        title: "Profile".txt(
          fontSize: 21.0,
          color: AppColours.white,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 629,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColours.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ).alignBottomCenter(),

          //!
          const Positioned(
            bottom: 580,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: AppColours.profileImageBGColour,
            ),
          ),

          //!
          Positioned(
            bottom: 580,
            right: 140,
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: AppColours.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 6.0, color: AppColours.wormGrey),
              ),
              child: Icon(
                Icons.edit_outlined,
                size: 18,
              ),
            ),
          )
        ],
      ),
    );
  }
}
