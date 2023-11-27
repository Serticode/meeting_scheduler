import 'dart:collection';
import 'package:meeting_scheduler/services/models/model_field_names.dart';
import 'package:meeting_scheduler/shared/utils/type_def.dart';

class UserModel extends MapView<String, dynamic> {
  late UserId? userId;
  late String? fullName;
  late String? email;
  late String? profileImage;

  UserModel({this.userId, this.fullName, this.email, this.profileImage})
      : super({
          FirebaseUserFieldName.userId: userId,
          FirebaseUserFieldName.fullName: fullName,
          FirebaseUserFieldName.email: email,
          FirebaseUserFieldName.profileImage: profileImage,
        });

  UserModel.fromJSON({
    required UserId userId,
    required Map<String, dynamic> json,
  }) : this(
            userId: userId,
            fullName: json[FirebaseUserFieldName.fullName] ?? "",
            email: json[FirebaseUserFieldName.email] ?? "",
            profileImage: json[FirebaseUserFieldName.profileImage] ?? "");

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          fullName == other.fullName &&
          email == other.email &&
          profileImage == other.profileImage;

  @override
  int get hashCode => Object.hashAll([
        userId,
        fullName,
        email,
        profileImage,
      ]);
}
