import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meeting_scheduler/services/controllers/auth/auth_controller.dart';
import 'package:meeting_scheduler/services/models/auth/user_model.dart';
import 'package:meeting_scheduler/services/models/model_field_names.dart';
import 'package:meeting_scheduler/shared/utils/type_def.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

//!
//! USER ID PROVIDER
final Provider<UserId?> userIdProvider =
    Provider<UserId?>((ref) => ref.watch(authControllerProvider).userId);

//!
//! USER DISPLAY NAME PROVIDER
final userDisplayNameProvider = Provider.autoDispose<UserDisplayName?>((ref) {
  final userModelStream = ref.watch(userInfoControllerProvider);

  ref.keepAlive();

  return userModelStream.value?.fullName?.split(" ").first;
});

//!
//! USER FULL NAME PROVIDER
final userFullNameProvider = Provider.autoDispose<UserFullName?>((ref) {
  final userModelStream = ref.watch(userInfoControllerProvider);

  ref.keepAlive();

  return userModelStream.value?.fullName;
});

//!
//! USER PROFILE IMAGE PROVIDER
final userProfileImageProvider = Provider.autoDispose<UserProfileImage?>((ref) {
  final userModelStream = ref.watch(userInfoControllerProvider);

  ref.keepAlive();

  return userModelStream.value?.profileImage;
});

//!
//! USER INFO CONTROLLER
final AutoDisposeStreamProvider<UserModel?> userInfoControllerProvider =
    StreamProvider.autoDispose<UserModel?>(
  (ref) {
    final userId = ref.watch(userIdProvider);

    final controller = StreamController<UserModel?>();

    controller.onListen = () {
      controller.sink.add(UserModel());
    };

    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.users)
        .where(FirebaseUserFieldName.userId, isEqualTo: userId)
        .snapshots(includeMetadataChanges: true)
        .listen((snapshot) {
      final UserModel userInfo =
          UserModel.fromJSON(userId: userId!, json: snapshot.docs.first.data());

      controller.sink.add(userInfo);
    });

    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });

    return controller.stream;
  },
);
