import 'package:riverpod_annotation/riverpod_annotation.dart';

final searchFieldControllerProvider =
    AsyncNotifierProvider<SearchFieldController, String>(
  SearchFieldController.new,
);

class SearchFieldController extends AsyncNotifier<String> {
  //!
  @override
  FutureOr<String> build() => "";

  void setSearchFieldValue({required String query}) =>
      state = AsyncValue.data(query);
}
