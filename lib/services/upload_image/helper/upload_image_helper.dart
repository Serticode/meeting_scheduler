import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';

class UploadImageHelper {
  const UploadImageHelper._();

  //! IMAGE PICKER
  static Future<File?> pickImage() async {
    try {
      //! INITIALIZE PICKER THEN; PICK IMAGE OR TAKE PHOTO
      final XFile? userImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      File? imageTemp = userImage?.path != null ? File(userImage!.path) : null;

      return imageTemp;
    } on PlatformException catch (error) {
      "Failed to pick images: $error".log();
      return null;
    }
  }
}
