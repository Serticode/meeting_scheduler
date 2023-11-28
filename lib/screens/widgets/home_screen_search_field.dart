import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/services/controllers/meetings_controllers/meetings_controller.dart';
import 'package:meeting_scheduler/services/controllers/search_field_controller/search_field_controller.dart';
import 'package:meeting_scheduler/services/models/meeting/scheduled_meeting_model.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:searchfield/searchfield.dart';

class HomeScreenSearchField extends ConsumerWidget {
  const HomeScreenSearchField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FocusNode focus = FocusNode();

    return Builder(builder: (context) {
      final listOfMeetings = ref.watch(meetingsProvider);

      return listOfMeetings.when(
        data: (meetings) {
          return SearchField(
            key: const Key('searchfield'),
            hint: 'Search for schedule',
            itemHeight: 50,
            scrollbarDecoration: ScrollbarDecoration(),
            offset: const Offset(0, 60),
            focusNode: focus,
            suggestionState: Suggestion.expand,
            onSuggestionTap: (suggestion) {
              focus.unfocus();
            },

            //!
            //! DECORATION
            searchInputDecoration: InputDecoration(
              suffixIcon: const Icon(Icons.search),
              suffixIconColor: Colors.black38,
              contentPadding: 14.0.symmetricPadding,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(width: 1.2, color: Colors.black12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(width: 1.5, color: Colors.black26),
              ),
              hintStyle: const TextStyle(
                color: Colors.black26,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            suggestionsDecoration: SuggestionDecoration(
              padding: 14.0.symmetricPadding,
              border: Border.all(width: 1.5, color: Colors.black26),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),

            //!
            //! SUGGESTIONS / ITEMS
            suggestions: meetings
                .map(
                  (meeting) => SearchFieldListItem<ScheduledMeetingModel?>(
                      meeting!.selectedVenue!,
                      child: Text(
                        meeting.selectedVenue!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColours.black50,
                        ),
                      )),
                )
                .toList(),

            //! ON SEARCH TEXT CHANGE
            onSearchTextChanged: (query) {
              final filter = meetings
                  .where((element) => element!.selectedVenue!
                      .toLowerCase()
                      .contains(query.toLowerCase()))
                  .toList();

              ref
                  .read(searchFieldControllerProvider.notifier)
                  .setSearchFieldValue(query: query);

              return filter
                  .map((meeting) =>
                      SearchFieldListItem<String>(meeting!.selectedVenue!,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              meeting.selectedVenue!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColours.black50,
                              ),
                            ),
                          )))
                  .toList();
            },
          );
        },

        //!
        error: (error, trace) => "Error: $error".txt16(),
        loading: () => const CircularProgressIndicator(),
      );
    });
  }
}
