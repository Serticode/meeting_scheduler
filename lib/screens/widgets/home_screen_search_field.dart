import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:searchfield/searchfield.dart';

class HomeScreenSearchField extends ConsumerWidget {
  const HomeScreenSearchField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestions = List.generate(12, (index) => 'suggestion $index');
    final focus = FocusNode();

    return SearchField(
      key: const Key('searchfield'),
      hint: 'Search for schedule',
      itemHeight: 50,
      scrollbarDecoration: ScrollbarDecoration(),
      offset: const Offset(0, 60),
      focusNode: focus,
      suggestionState: Suggestion.expand,
      onSuggestionTap: (SearchFieldListItem<String> x) => focus.unfocus(),

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
      suggestions: suggestions
          .map(
            (e) => SearchFieldListItem<String>(e,
                child: Text(
                  e,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColours.black50,
                  ),
                )),
          )
          .toList(),

      //! ON SEARCH TEXT CHANGE
      onSearchTextChanged: (query) {
        final filter = suggestions
            .where((element) =>
                element.toLowerCase().contains(query.toLowerCase()))
            .toList();
        return filter
            .map((e) => SearchFieldListItem<String>(e,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    e,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColours.black50,
                    ),
                  ),
                )))
            .toList();
      },
    );
  }
}
