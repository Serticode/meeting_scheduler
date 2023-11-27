import 'dart:collection';
import 'package:meeting_scheduler/services/models/model_field_names.dart';
import 'package:meeting_scheduler/shared/utils/type_def.dart';

class UserModel extends MapView<String, dynamic> {
  late UserId? userId;
  late String? fullName;
  late String? email;
  late String? profileImage;
  late String? profession;
  late String? phoneNumber;

  UserModel({
    this.userId,
    this.fullName,
    this.email,
    this.profileImage,
    this.profession,
    this.phoneNumber,
  }) : super({
          FirebaseUserFieldName.userId: userId,
          FirebaseUserFieldName.fullName: fullName,
          FirebaseUserFieldName.email: email,
          FirebaseUserFieldName.profileImage: profileImage,
          FirebaseUserFieldName.profession: profession,
          FirebaseUserFieldName.phoneNumber: phoneNumber,
        });

  UserModel.fromJSON({
    required UserId? userId,
    required Map<String, dynamic> json,
  }) : this(
          userId: userId,
          fullName: json[FirebaseUserFieldName.fullName] ?? "",
          email: json[FirebaseUserFieldName.email] ?? "",
          profileImage: json[FirebaseUserFieldName.profileImage] ?? "",
          profession: json[FirebaseUserFieldName.profession] ?? "",
          phoneNumber: json[FirebaseUserFieldName.phoneNumber] ?? "",
        );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          fullName == other.fullName &&
          email == other.email &&
          profileImage == other.profileImage &&
          profession == other.profession &&
          phoneNumber == other.phoneNumber;

  @override
  int get hashCode => Object.hashAll([
        userId,
        fullName,
        email,
        profileImage,
        profession,
        phoneNumber,
      ]);
}
