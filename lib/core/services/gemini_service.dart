import 'package:google_generative_ai/google_generative_ai.dart';

import '../constants/gemini_constants.dart';

class GeminiService {
  static final GenerativeModel _model = GenerativeModel(
    model: 'gemini-3.5-flash',
    apiKey: GeminiConstants.apiKey,
  );

  static Future<String> generateResponse(
      String prompt,
      ) async {
    try {
      final response = await _model.generateContent(
        [Content.text(prompt)],
      );

      return response.text ??
          "Sorry, I couldn't generate a response.";
    } catch (e) {
      return "Error: $e";
    }
  }
}