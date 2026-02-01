import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class MediaService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 80, // Optimize size
      );

      if (photo != null) {
        return File(photo.path);
      }
      return null;
    } catch (e) {
      // Handle permission errors or other exceptions
      debugPrint('Error picking image: $e');
      return null;
    }
  }
}
