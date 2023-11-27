//! CLASS HANDLING THE DATABASE
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meeting_scheduler/services/models/auth/user_model.dart';
import 'package:meeting_scheduler/services/models/model_field_names.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/shared/utils/type_def.dart';

class Database {
  const Database._();
  static const instance = Database._();

  static final CollectionReference userCollection =
      FirebaseFirestore.instance.collection(
    FirebaseCollectionName.users,
  );

  //!
  //! SAVE USER INFO
  Future<bool> saveUserInfo({
    required UserId? userId,
    required String? fullName,
    required String? email,
  }) async {
    final UserModel user = UserModel(
      userId: userId,
      fullName: fullName,
      email: email,
      profileImage: "",
      profession: "",
      phoneNumber: "",
    );

    try {
      await userCollection
          .where(FirebaseUserFieldName.userId, isEqualTo: userId)
          .limit(1)
          .get()
          .then((userInfo) async {
        if (userInfo.docs.isNotEmpty) {
          await userInfo.docs.first.reference.update(user);
          return true;
        }
      });

      await userCollection.add(user);
      return true;
    } catch (error) {
      error.toString().log();

      return false;
    }
  }

  //!
  //! UPDATE
  Future<bool> updateUserInfo({
    required UserId? userId,
    required String? fullName,
    required String? email,
    required String? profession,
    required String? phoneNumber,
  }) async {
    try {
      await userCollection
          .where(FirebaseUserFieldName.userId, isEqualTo: userId)
          .limit(1)
          .get()
          .then((userInfo) async {
        if (userInfo.docs.isNotEmpty) {
          final UserModel storedUserInfo = UserModel.fromJSON(
              userId: userId,
              json: userInfo.docs.first.data() as Map<String, dynamic>);

          UserModel newUserInfo = UserModel(
            userId: userId,
            profileImage: storedUserInfo.profileImage,
            email: email!.isEmpty ? storedUserInfo.email : email,
            fullName: fullName!.isEmpty ? storedUserInfo.fullName : fullName,
            profession:
                profession!.isEmpty ? storedUserInfo.profession : profession,
            phoneNumber:
                phoneNumber!.isEmpty ? storedUserInfo.phoneNumber : phoneNumber,
          );

          await userInfo.docs.first.reference.update(newUserInfo);
          return true;
        }
      });

      return true;
    } catch (error) {
      error.toString().log();

      return false;
    }
  }
}
