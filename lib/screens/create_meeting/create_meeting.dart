// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/screens/widgets/buttons.dart';
import 'package:meeting_scheduler/screens/widgets/meeting_date_selector.dart';
import 'package:meeting_scheduler/screens/widgets/meeting_time_selector.dart';
import 'package:meeting_scheduler/screens/widgets/meeting_venue_selector.dart';
import 'package:meeting_scheduler/screens/widgets/text_form_field.dart';
import 'package:meeting_scheduler/services/controllers/create_meeting_controllers/meeting_date_controller.dart';
import 'package:meeting_scheduler/services/controllers/create_meeting_controllers/meeting_time_controller.dart';
import 'package:meeting_scheduler/services/controllers/create_meeting_controllers/meeting_venue_controller.dart';
import 'package:meeting_scheduler/services/controllers/home_screen_controllers/user_meetings_controller.dart';
import 'package:meeting_scheduler/services/models/scheduled_meeting_model.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/app_elements/app_texts.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/shared/utils/type_def.dart';
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
    return Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        title: widget.isEditMeeting != null && widget.isEditMeeting == false
            ? AppTexts.createMeeting.txt(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              )
            : AppTexts.editMeeting.txt(
                fontWeight: FontWeight.w600,
                fontSize: 20,
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
              ),

              18.0.sizedBoxHeight,

              //! PROFESSION
              CustomTextFormField(
                isForPassword: false,
                hint: "Profession e.g lecturer, secretary",
                controller: _profession,
              ),

              18.0.sizedBoxHeight,

              //! PURPOSE
              CustomTextFormField(
                isForPassword: false,
                hint: "Purpose of Meeting",
                controller: _purpose,
              ),

              18.0.sizedBoxHeight,

              //! ATTENDERS
              CustomTextFormField(
                isForPassword: false,
                hint: "Number of attenders",
                controller: _attenders,
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

              32.0.sizedBoxHeight,

              RegularButton(
                onTap: () async {
                  if (ref
                              .read(meetingVenueControllerProvider.notifier)
                              .getSelectedVenue ==
                          null ||
                      ref
                              .read(meetingVenueControllerProvider.notifier)
                              .getSelectedVenue ==
                          MeetingVenue.venue) {
                    ScaffoldMessenger.of(context).showMaterialBanner(
                      MaterialBanner(
                        content: "Select a venue".txt16(
                          fontWeight: FontWeight.w500,
                          color: AppColours.white,
                        ),
                        backgroundColor: AppColours.buttonBlue,
                        actions: [
                          "Close".txt14(color: AppColours.white).onTap(
                                onTap: () => ScaffoldMessenger.of(context)
                                    .clearMaterialBanners(),
                              )
                        ],
                      ),
                    );
                  } else {
                    ScheduledMeetingModel scheduledMeeting =
                        ScheduledMeetingModel()
                          ..meetingID = widget.isEditMeeting != null &&
                                  widget.isEditMeeting == true
                              ? widget.meetingModel?.meetingID
                              : null
                          ..fullName = _fullName.value.text.trim()
                          ..professionOfVenueBooker =
                              _profession.value.text.trim()
                          ..purposeOfMeeting = _purpose.value.text.trim()
                          ..numberOfExpectedParticipants =
                              _attenders.value.text.trim()
                          ..dateOfMeeting = ref
                              .read(meetingDateControllerProvider.notifier)
                              .getMeetingDate
                          ..meetingStartTime = ref
                              .read(meetingStartTimeControllerProvider.notifier)
                              .getMeetingTime
                          ..meetingEndTime = ref
                              .read(meetingEndTimeControllerProvider.notifier)
                              .getMeetingTime
                          ..selectedVenue = ref
                                  .read(meetingVenueControllerProvider.notifier)
                                  .getSelectedVenue
                                  ?.hallName ??
                              "No Venue";

                    //!TODO: SHOW SUCCESS MESSAGE OF ACTIONS BELOW
                    if (widget.isEditMeeting!) {
                      await ref
                          .read(userMeetingsControllerProvider.notifier)
                          .updateMeeting(scheduledMeeting: scheduledMeeting)
                          .whenComplete(
                            () => Navigator.of(context).pop(),
                          );
                    } else {
                      const uuid = Uuid();
                      scheduledMeeting = scheduledMeeting
                        ..meetingID = uuid.v4();
                      await ref
                          .read(userMeetingsControllerProvider.notifier)
                          .addMeeting(scheduledMeeting: scheduledMeeting)
                          .whenComplete(
                            () => Navigator.of(context).pop(),
                          );
                    }
                  }
                },
                buttonText: widget.isEditMeeting != null &&
                        widget.isEditMeeting == false
                    ? AppTexts.createMeeting
                    : AppTexts.saveMeeting,
              )
            ],
          ),
        ),
      ).generalPadding,
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
}
