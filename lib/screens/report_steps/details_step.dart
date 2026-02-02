import 'dart:io';
import 'package:citysense_flutter/services/gemini_service.dart';
import 'package:citysense_flutter/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DetailsStep extends StatefulWidget {
  final File? selectedImage;
  final LatLng userLocation;
  final String address;
  final VoidCallback onBack;
  final VoidCallback onSuccess;

  const DetailsStep({
    super.key,
    required this.selectedImage,
    required this.userLocation,
    required this.address,
    required this.onBack,
    required this.onSuccess,
  });

  @override
  State<DetailsStep> createState() => _DetailsStepState();
}

class _DetailsStepState extends State<DetailsStep> {
  final TextEditingController _descriptionController = TextEditingController();
  final GeminiService _geminiService = GeminiService();
  final DatabaseService _databaseService = DatabaseService();

  bool _isSubmitting = false;
  String _statusMessage = "";

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (widget.selectedImage == null) return;

    setState(() {
      _isSubmitting = true;
      _statusMessage = "Analyzing image with AI...";
    });

    try {
      // 1. AI Verification
      final bool hasGarbage = await _geminiService.containsGarbage(
        widget.selectedImage!,
      );

      if (!hasGarbage) {
        if (mounted) {
          _showErrorDialog(
            "No Garbage Detected",
            "Our AI system did not detect any garbage in this photo. "
                "Please ensure the waste is clearly visible and try again.",
          );
        }
        return;
      }

      setState(() {
        _statusMessage = "Submitting report...";
      });

      // 2. Submit to Database
      await _databaseService.submitReport(
        image: widget.selectedImage!,
        location: widget.userLocation,
        address: widget.address,
        description: _descriptionController.text.trim(),
      );

      // 3. Success
      widget.onSuccess();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showErrorDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isSubmitting) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 20),
            Text(
              _statusMessage,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Describe the waste',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  '(Optional)',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF616161),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'You can provide additional details about the waste you are reporting. This will help our team categorize and prioritize the issue.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Description Input
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[700]!),
                    color: Colors.transparent,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _descriptionController,
                    maxLines: null,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Description (Optional)',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Report Summary Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Report Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111111),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: widget.selectedImage != null
                                    ? FileImage(widget.selectedImage!)
                                    : const NetworkImage(
                                            'https://placehold.co/100x100/png',
                                          )
                                          as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Photo attached',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF111111),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                // Simple file size placeholder
                                'Ready to submit',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            LucideIcons.mapPin,
                            size: 16,
                            color: Color(0xFF111111),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.address,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF111111),
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),

        // Step 3 Bottom Bar (Back + Submit)
        Container(
          padding: EdgeInsets.fromLTRB(
            20,
            16,
            20,
            MediaQuery.of(context).padding.bottom + 16,
          ),
          decoration: const BoxDecoration(color: Colors.white),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: widget.onBack,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF111111)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.chevronLeft,
                          size: 16,
                          color: Color(0xFF111111),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Back',
                          style: TextStyle(
                            color: Color(0xFF111111),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _submitReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E1E1E),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Submit',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Icon(LucideIcons.send, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
