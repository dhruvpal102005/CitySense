import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart'; // For XFile

class GeminiService {
  late final GenerativeModel _model;
  static const String _prompt =
      "Analyze this image and tell me if it contains garbage, trash, waste, or litter "
      "that needs to be cleaned up. Return strictly 'yes' or 'no'. "
      "If you are unsure, default to 'no'.";

  GeminiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      throw Exception('GEMINI_API_KEY not found in .env');
    }
    _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
  }

  Future<bool> containsGarbage(XFile imageFile) async {
    try {
      final imageBytes = await imageFile.readAsBytes();
      final content = [
        Content.multi([TextPart(_prompt), DataPart('image/jpeg', imageBytes)]),
      ];

      final response = await _model.generateContent(content);
      final text = response.text?.toLowerCase().trim() ?? '';

      return text.contains('yes');
    } catch (e) {
      print('Gemini AI Error: $e');
      // In case of error, we might want to allow it or block it.
      // For now, let's return false to be safe and maybe handle the error in UI.
      throw Exception('Failed to analyze image: $e');
    }
  }
}
