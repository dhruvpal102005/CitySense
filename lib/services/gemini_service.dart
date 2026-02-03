import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class GeminiService {
  late final GenerativeModel _model;

  static const String _prompt =
      "Analyze this image and tell me if it contains garbage, trash, waste, or litter "
      "that needs to be cleaned up. "
      "Respond with ONLY one word: yes or no. "
      "If unsure, respond with no.";

  GeminiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY not found in .env');
    }

    _model = GenerativeModel(
      model: 'gemini-2.5-flash', // ✅ stable & vision-capable
      apiKey: apiKey,
    );
  }

  Future<bool> containsGarbage(XFile imageFile) async {
    try {
      final imageBytes = await imageFile.readAsBytes();

      // Detect mime type safely
      final mimeType = imageFile.mimeType ?? 'image/jpeg';

      final content = [
        Content.multi([TextPart(_prompt), DataPart(mimeType, imageBytes)]),
      ];

      final response = await _model.generateContent(content);
      final result = response.text?.trim().toLowerCase();

      if (result == 'yes') return true;
      if (result == 'no') return false;

      // Any unexpected output → safe default
      debugPrint('Unexpected Gemini response: $result');
      return false;
    } catch (e) {
      debugPrint('Gemini AI Error: $e');

      // Fail-safe behavior (important for moderation systems)
      return false;
    }
  }
}
