import 'dart:io';
import 'package:citysense_flutter/services/media_service.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PhotoStep extends StatefulWidget {
  final File? selectedImage;
  final Function(File) onImageSelected;
  final VoidCallback onNext;

  const PhotoStep({
    super.key,
    required this.selectedImage,
    required this.onImageSelected,
    required this.onNext,
  });

  @override
  State<PhotoStep> createState() => _PhotoStepState();
}

class _PhotoStepState extends State<PhotoStep> {
  final MediaService _mediaService = MediaService();

  Future<void> _pickImage() async {
    final image = await _mediaService.pickImageFromCamera();
    if (image != null) {
      widget.onImageSelected(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Take a photo of the waste',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please take a clear photo of the waste you want to report. This helps our team understand the situation better.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Photo Placeholder
                AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(16),
                      image: widget.selectedImage != null
                          ? DecorationImage(
                              image: FileImage(widget.selectedImage!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: widget.selectedImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LucideIcons.camera,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No photo selected',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        : null,
                  ),
                ),

                const SizedBox(height: 24),

                // Take Photo Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(LucideIcons.camera, size: 20),
                    label: Text(
                      widget.selectedImage != null
                          ? 'Retake Photo'
                          : 'Take Photo',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Photo Tips
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            LucideIcons.lightbulb,
                            size: 20,
                            color: Color(0xFF1565C0),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Photo Tips',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1565C0),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildTipItem(
                        'Ensure good lighting for clear visibility',
                      ),
                      const SizedBox(height: 8),
                      _buildTipItem('Capture the full extent of the waste'),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        _buildBottomBar(),
      ],
    );
  }

  Widget _buildTipItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Icon(Icons.circle, size: 6, color: Color(0xFF1565C0)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF0D47A1),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          // Disable "Next" if no image is selected
          onPressed: widget.selectedImage != null ? widget.onNext : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF111111),
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey[800],
            disabledForegroundColor: Colors.grey[500],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Next', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              Icon(LucideIcons.chevronRight, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
