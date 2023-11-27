import 'dart:io' show File;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/services/models/auth/user_model.dart';
import 'package:meeting_scheduler/services/models/model_field_names.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/shared/utils/type_def.dart';

final uploadImageProvider =
    StateNotifierProvider<UploadImageController, IsLoading>(
  (ref) => UploadImageController(),
);

class UploadImageController extends StateNotifier<IsLoading> {
  UploadImageController() : super(false);
  final Reference _storageReference = FirebaseStorage.instance.ref();

  set isLoading(bool value) => state = value;

  Future<bool> uploadProfilePhoto({
    required UserId userId,
    required File profilePhoto,
    required FileType fileType,
    required UserModel loggedInUser,
  }) async {
    try {
      isLoading = true;

      final Reference fileRef = _storageReference
          .child(userId)
          .child(fileType.collectionName)
          .child(FirestoreFileFieldNames.profileImage);

      final TaskSnapshot profilePhotoUploadTask =
          await fileRef.putFile(profilePhoto);

      final String fileUrl = await profilePhotoUploadTask.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .where(FirebaseUserFieldName.userId, isEqualTo: userId)
          .limit(1)
          .get()
          .then((userInfo) async {
        final Map<String, dynamic> userData = userInfo.docs.first.data();
        userData.update(FirebaseUserFieldName.profileImage, (value) => fileUrl);

        loggedInUser = UserModel.fromJSON(
          userId: userId,
          json: userData,
        );

        await userInfo.docs.first.reference.update(loggedInUser);
        return true;
      });

      isLoading = false;

      return true;
    } catch (error) {
      isLoading = false;
      error.toString().log();
      return false;
    }
  }
}
