import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/router/router.dart';
import 'package:meeting_scheduler/router/routes.dart';
import 'package:meeting_scheduler/screens/widgets/buttons.dart';
import 'package:meeting_scheduler/screens/widgets/meeting_date_selector.dart';
import 'package:meeting_scheduler/screens/widgets/meeting_time_selector.dart';
import 'package:meeting_scheduler/screens/widgets/meeting_venue_selector.dart';
import 'package:meeting_scheduler/screens/widgets/text_form_fields.dart';
import 'package:meeting_scheduler/services/controllers/create_meeting_controllers/meeting_date_controller.dart';
import 'package:meeting_scheduler/services/controllers/create_meeting_controllers/meeting_time_controller.dart';
import 'package:meeting_scheduler/services/controllers/create_meeting_controllers/meeting_venue_controller.dart';
import 'package:meeting_scheduler/services/controllers/meetings_controllers/meetings_controller.dart';
import 'package:meeting_scheduler/services/controllers/user_info/user_info_controller.dart';
import 'package:meeting_scheduler/services/models/meeting/scheduled_meeting_model.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/app_elements/app_texts.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/shared/utils/errors/meeting_venue_error.dart';
import 'package:meeting_scheduler/shared/utils/type_def.dart';
import 'package:meeting_scheduler/shared/utils/utils.dart';
import 'package:uuid/uuid.dart';

class CreateMeeting extends ConsumerStatefulWidget {
  final ScheduledMeetingModel? meetingModel;
  final bool? isEditMeeting;
  const CreateMeeting({
    super.key,
    this.meetingModel,
    this.isEditMeeting,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateMeetingState();
}

class _CreateMeetingState extends ConsumerState<CreateMeeting> {
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _profession = TextEditingController();
  final TextEditingController _purpose = TextEditingController();
  final TextEditingController _attenders = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  MeetingVenueError venueError = MeetingVenueError(message: "");
  ValueNotifier<bool> showVenueError = false.toValueNotifier;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback(
      (timeStamp) => updateNeededValues(),
    );
  }

  @override
  void dispose() {
    _fullName.dispose();
    _profession.dispose();
    _purpose.dispose();
    _attenders.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(meetingsControllerProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        title: widget.isEditMeeting != null && widget.isEditMeeting == false
            ? AppTexts.createMeeting.txt(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              )
            : AppTexts.editMeeting.txt(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
        centerTitle: true,
      ),

      //! BODY
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              18.0.sizedBoxHeight,

              //! FULL NAME
              CustomTextFormField(
                isForPassword: false,
                hint: "Full Name",
                controller: _fullName,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (_fullName.value.text.trim().split(" ").length < 2) {
                    return "Enter a Last and First name";
                  } else {
                    return null;
                  }
                },
              ),

              18.0.sizedBoxHeight,

              //! PROFESSION
              CustomTextFormField(
                isForPassword: false,
                hint: "Profession e.g lecturer, secretary",
                controller: _profession,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (_profession.value.text.trim().isEmpty) {
                    return "Enter a profession";
                  } else {
                    return null;
                  }
                },
              ),

              18.0.sizedBoxHeight,

              //! PURPOSE
              CustomTextFormField(
                isForPassword: false,
                hint: "Purpose of Meeting",
                controller: _purpose,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (_purpose.value.text.trim().isEmpty) {
                    return "Enter a purpose for the meeting";
                  } else {
                    return null;
                  }
                },
              ),

              18.0.sizedBoxHeight,

              //! ATTENDERS
              CustomTextFormField(
                isForPassword: false,
                hint: "Number of attenders",
                controller: _attenders,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (_attenders.value.text.trim().isEmpty) {
                    return "This field cannot be empty";
                  } else {
                    return null;
                  }
                },
              ),

              18.0.sizedBoxHeight,

              //! MEETING DATE
              const MeetingDateSelector(),

              18.0.sizedBoxHeight,

              //! MEETING TIME
              Row(
                children: [
                  Expanded(
                    child: MeetingTimeSelector(
                        isStartTime: true,
                        provider: meetingStartTimeControllerProvider),
                  ),

                  //!
                  21.0.sizedBoxWidth,

                  Expanded(
                    child: MeetingTimeSelector(
                        isStartTime: false,
                        provider: meetingEndTimeControllerProvider),
                  )
                ],
              ),

              //!
              18.0.sizedBoxHeight,

              //! MEETING VENUE
              const MeetingVenueSelector(),

              //!
              18.0.sizedBoxHeight,

              showVenueError.toValueListenable(
                builder: (context, value, child) {
                  if (value) {
                    return venueError.message.txt14(
                        color: AppColours.red, fontWeight: FontWeight.w500);
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),

              //!
              18.0.sizedBoxHeight,

              if (widget.isEditMeeting != null && widget.isEditMeeting == true)
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColours.warmGrey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      "${widget.meetingModel?.fullName} Meeting".txt14(),
                      const Spacer(),
                      const Icon(
                        Icons.copy_rounded,
                        size: 21,
                      ).onTap(
                        onTap: () => Clipboard.setData(
                          ClipboardData(
                            text: widget.meetingModel?.meetingID ?? "",
                          ),
                        ).then(
                          (value) => AppUtils.showAppBanner(
                            title: "Success",
                            message: "Meeting ID copied successfully",
                            contentType: ContentType.success,
                            callerContext: context,
                          ),
                        ),
                      ),
                    ],
                  ).generalPadding,
                ),

              32.0.sizedBoxHeight,

              RegularButton(
                onTap: () async => await validateInputFields(),
                buttonText: widget.isEditMeeting != null &&
                        widget.isEditMeeting == false
                    ? AppTexts.createMeeting
                    : AppTexts.saveMeeting,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ).generalPadding.ignorePointer(
            isLoading: ref.watch(meetingsControllerProvider),
          ),
    );
  }

  void updateNeededValues() {
    if (widget.meetingModel != null) {
      _fullName.value = TextEditingValue(text: widget.meetingModel!.fullName!);
      _profession.value =
          TextEditingValue(text: widget.meetingModel!.professionOfVenueBooker!);
      _purpose.value =
          TextEditingValue(text: widget.meetingModel!.purposeOfMeeting!);
      _attenders.value = TextEditingValue(
          text: widget.meetingModel!.numberOfExpectedParticipants!);
      ref
          .read(meetingDateControllerProvider.notifier)
          .setMeetingDate(date: widget.meetingModel!.dateOfMeeting!);
      ref.read(meetingVenueControllerProvider.notifier).setMeetingVenue(
            meetingVenue: MeetingVenue.values.firstWhere((element) =>
                element.hallName == widget.meetingModel!.selectedVenue),
          );
      ref
          .read(meetingStartTimeControllerProvider.notifier)
          .setStartTime(theTime: widget.meetingModel!.meetingStartTime!);
      ref
          .read(meetingEndTimeControllerProvider.notifier)
          .setEndTime(theTime: widget.meetingModel!.meetingEndTime!);
    }
  }

  Future<void> validateInputFields() async {
    //! USER HAS NOT SELECTED A VENUE
    if (ref.read(meetingVenueControllerProvider.notifier).getSelectedVenue ==
        MeetingVenue.venue) {
      venueError = MeetingVenueError(message: "No venue selected");
      showVenueError.value = true;
    }

    //! VENUE IS SELECTED - VALIDATE INPUT
    else if (_formKey.currentState!.validate()) {
      bool meetingExists = false;
      showVenueError.value = false;
      late ScheduledMeetingModel? alreadyScheduledMeeting;

      ScheduledMeetingModel scheduledMeeting = ScheduledMeetingModel()
        ..ownerID = widget.isEditMeeting != null && widget.isEditMeeting == true
            ? widget.meetingModel?.ownerID
            : ref.read(userIdProvider)
        ..meetingID =
            widget.isEditMeeting != null && widget.isEditMeeting == true
                ? widget.meetingModel?.meetingID
                : null
        ..fullName = _fullName.value.text.trim()
        ..professionOfVenueBooker = _profession.value.text.trim()
        ..purposeOfMeeting = _purpose.value.text.trim()
        ..numberOfExpectedParticipants = _attenders.value.text.trim()
        ..dateOfMeeting =
            ref.read(meetingDateControllerProvider.notifier).getMeetingDate
        ..meetingStartTime =
            ref.read(meetingStartTimeControllerProvider.notifier).getMeetingTime
        ..meetingEndTime =
            ref.read(meetingEndTimeControllerProvider.notifier).getMeetingTime
        ..selectedVenue = ref
            .read(meetingVenueControllerProvider.notifier)
            .getSelectedVenue
            .hallName;

      if (widget.isEditMeeting!) {
        await ref
            .read(meetingsControllerProvider.notifier)
            .updateMeeting(meeting: scheduledMeeting, context: context)
            .whenComplete(
              () => Navigator.of(context).pop(),
            );
      } else {
        for (ScheduledMeetingModel? element
            in ref.read(meetingsProvider).value ?? []) {
          if (scheduledMeeting.dateOfMeeting == element?.dateOfMeeting &&
              scheduledMeeting.meetingStartTime == element?.meetingStartTime &&
              scheduledMeeting.selectedVenue == element?.selectedVenue) {
            meetingExists = true;
            alreadyScheduledMeeting = element;
            break;
          }
        }

        if (meetingExists) {
          venueError = MeetingVenueError(
              message:
                  "NOT Available - In use from ${alreadyScheduledMeeting?.meetingStartTime} - ${alreadyScheduledMeeting?.meetingEndTime}");
          showVenueError.value = true;
        } else {
          showVenueError.value = false;
          const uuid = Uuid();
          scheduledMeeting = scheduledMeeting..meetingID = uuid.v4();
          await ref
              .read(meetingsControllerProvider.notifier)
              .addMeeting(meeting: scheduledMeeting, context: context)
              .whenComplete(
            () {
              ref.invalidate(meetingDateControllerProvider);
              ref.invalidate(meetingStartTimeControllerProvider);
              ref.invalidate(meetingEndTimeControllerProvider);
              ref.invalidate(meetingVenueControllerProvider);

              AppNavigator.instance.navigateToPage(
                thePageRouteName: AppRoutes.successScreen,
                context: context,
                arguments: {
                  "meetingOwner": scheduledMeeting.fullName,
                  "showMeetingOwner": true,
                  "meetingID": scheduledMeeting.meetingID,
                },
              );
            },
          );
        }
      }
    } else {
      showVenueError.value = false;
    }
  }
}
