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

  Future<bool> saveUserInfo({
    required UserId? userId,
    required String? fullName,
    required String? email,
  }) async {
    final UserModel user = UserModel(
      userId: userId,
      fullName: fullName,
      email: email,
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

  Future<UserModel?> getUserInfo({
    required UserId? userId,
    required String? email,
  }) async {
    try {
      late UserModel user;

      final QuerySnapshot<Object?> snapshot = await userCollection
          .where(FirebaseUserFieldName.userId, isEqualTo: userId)
          .limit(1)
          .get();

      user = UserModel.fromJSON(
        userId: userId!,
        json: snapshot.docs.first.data() as Map<String, dynamic>,
      );

      user.log();

      // await userCollection.add(user);
      return user;
    } catch (error) {
      error.toString().log();

      return null;
    }
  }
}
