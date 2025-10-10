import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class MainServices {
  static Future<File?> getCameraImageUsingImagePicker(
      ImageSource source) async {
    var pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 15,
    );
    if (pickedImage != null) {
      return File(pickedImage.path);
    } else {
      return null;
    }
  }

  static Future<File?> getImageUsingImagePicker(ImageSource source) async {
    var pickedImage = await ImagePicker().pickMedia(
      imageQuality: 25,
    );
    if (pickedImage != null) {
      return File(pickedImage.path);
    } else {
      return null;
    }
  }

  static Future<File?> pickDocumentFile() async {
    var pickedImage = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['docx', 'doc', 'pdf'],
      allowCompression: true,
    );
    if (pickedImage != null) {
      return File(pickedImage.files.first.path!);
    } else {
      return null;
    }
  }
}
