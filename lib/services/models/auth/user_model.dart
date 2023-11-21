import 'dart:collection';
import 'package:meeting_scheduler/services/models/model_field_names.dart';
import 'package:meeting_scheduler/shared/utils/type_def.dart';

class UserModel extends MapView<String, dynamic> {
  late UserId? userId;
  late String? fullName;
  late String? email;

  UserModel({
    this.userId,
    this.fullName,
    this.email,
  }) : super({
          FirebaseUserFieldName.userId: userId,
          FirebaseUserFieldName.fullName: fullName,
          FirebaseUserFieldName.email: email,
        });

  UserModel.fromJSON({
    required UserId userId,
    required Map<String, dynamic> json,
  }) : this(
          userId: userId,
          fullName: json[FirebaseUserFieldName.fullName] ?? "",
          email: json[FirebaseUserFieldName.email] ?? "",
        );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          fullName == other.fullName &&
          email == other.email;

  @override
  int get hashCode => Object.hashAll([
        userId,
        fullName,
        email,
      ]);
}
