// import 'dart:io'; // Removed for Web compatibility
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class MediaService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickImageFromCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 80, // Optimize size
      );

      return photo;
    } catch (e) {
      // Handle permission errors or other exceptions
      debugPrint('Error picking image: $e');
      return null;
    }
  }
}
