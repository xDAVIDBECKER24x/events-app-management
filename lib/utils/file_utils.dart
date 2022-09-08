import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> selectGalleryFile() async {
  try {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    final imagePath = File(image!.path);
    return imagePath;
  } on PlatformException catch (e) {
    print("error");
  }
}

Future<File?> selectCameraFile() async {
  try {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    final imagePath = File(image!.path);
    return imagePath;
  } on PlatformException catch (e) {
    print("error");
  }
}

Future<File?> selectFileSource(ImageSource source) async {
  try {
    final image = await ImagePicker().pickImage(source: source);
    final imagePath = File(image!.path);
    return imagePath;
  } on PlatformException catch (e) {
    print("error");
  }
}
