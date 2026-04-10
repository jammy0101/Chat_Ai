import 'package:google_generative_ai/google_generative_ai.dart';

import '../core/constants/app_constants.dart';

class GeminiService {
  GeminiService({required String apiKey, String model = AppConstants.defaultModel})
      : _model = GenerativeModel(model: model, apiKey: apiKey);

  factory GeminiService.fromEnvironment() {
    const apiKey = String.fromEnvironment('GEMINI_API_KEY');
    if (apiKey.isEmpty) {
      throw StateError(
        'GEMINI_API_KEY not provided. Run with --dart-define=GEMINI_API_KEY=your_key',
      );
    }

    return GeminiService(apiKey: apiKey);
  }

  final GenerativeModel _model;

  Future<String> sendMessage({
    required String prompt,
    List<Content> context = const [],
  }) async {
    final content = [...context, Content.text(prompt)];
    final response = await _model.generateContent(content);

    return response.text?.trim().isNotEmpty == true
        ? response.text!.trim()
        : 'I could not generate a response. Please try again.';
  }
}
