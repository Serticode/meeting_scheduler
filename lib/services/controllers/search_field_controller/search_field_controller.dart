import 'package:riverpod_annotation/riverpod_annotation.dart';
part "search_field_controller.g.dart";

@Riverpod(keepAlive: true)
class SearchFieldController extends _$SearchFieldController {
  //!
  @override
  FutureOr<String> build() => "";

  void setSearchFieldValue({required String query}) =>
      state = AsyncValue.data(query);
}
