import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import 'llm_service.dart';

class GeminiService extends LlmService {
  @override
  Future<Map<String, dynamic>> analyzeCode({
    required String code,
    required String logs,
    required String focus,
  }) async {
    final modelList = ApiConstants.geminiModels;

    for (int i = 0; i < modelList.length; i++) {
      try {
        final result = await _tryAnalyzeWithModel(
          model: modelList[i],
          code: code,
          logs: logs,
          focus: focus,
        );
        return result;
      } catch (e) {
        if (i == modelList.length - 1) {
          throw Exception(
            'All Gemini models failed. Last error: ${e.toString()}',
          );
        }
        continue;
      }
    }
    throw Exception('Failed to analyze code with any available Gemini model');
  }

  Future<Map<String, dynamic>> _tryAnalyzeWithModel({
    required String model,
    required String code,
    required String logs,
    required String focus,
  }) async {
    try {
      // Gemini API Structure is different
      // URL: https://generativelanguage.googleapis.com/v1beta/models/[MODEL_NAME]:generateContent?key=[API_KEY]

      final url =
          'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=${ApiConstants.geminiApiKey}';

      String prompt = ApiConstants.systemPrompt + "\n\n";

      if (code.isNotEmpty) {
        prompt += 'Code:\n```\n$code\n```\n\n';
      }

      if (logs.isNotEmpty) {
        prompt += 'Error Logs:\n```\n$logs\n```\n\n';
      }

      prompt += 'Analysis Focus: $focus\n';
      prompt +=
          'Please optimize your analysis based on the selected focus above.\n';

      // Construct parts of the message
      List<Map<String, dynamic>> parts = [
        {'text': prompt},
      ];

      final requestBody = {
        'contents': [
          {'parts': parts},
        ],
        'generationConfig': {
          'temperature': 0.2,
          'maxOutputTokens': 4000,
          'responseMimeType': 'application/json',
        },
      };

      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(
            const Duration(seconds: 60),
            onTimeout: () {
              throw Exception('Request timeout. Please try again.');
            },
          );

      if (response.statusCode != 200) {
        throw Exception(
          'Gemini API Error: ${response.statusCode} - ${response.body}',
        );
      }

      final responseData = jsonDecode(response.body);

      // Extract content from Gemini response
      if (responseData == null || !responseData.containsKey('candidates')) {
        throw Exception('Invalid Gemini response');
      }

      final candidates = responseData['candidates'] as List;
      if (candidates.isEmpty) {
        throw Exception('No candidates in Gemini response');
      }

      final content = candidates[0]['content'];
      final partsResponse = content['parts'] as List;
      final textPart = partsResponse.firstWhere(
        (p) => p.containsKey('text'),
        orElse: () => {'text': ''},
      );
      String contentText = textPart['text'];

      String jsonContent = sanitizeJson(contentText);

      try {
        final analysisResult = jsonDecode(jsonContent) as Map<String, dynamic>;

        final requiredFields = [
          'language',
          'root_cause',
          'fixed_code',
          'explanation_beginner',
          'explanation_intermediate',
          'explanation_expert',
          'best_practices',
          'alternative_solution',
          'score',
        ];

        for (final field in requiredFields) {
          if (!analysisResult.containsKey(field)) {
            if (field == 'score') {
              analysisResult['score'] = 0;
            } else {
              analysisResult[field] = 'N/A';
            }
          }
        }

        return analysisResult;
      } catch (e) {
        throw Exception(
          'Failed to decode JSON from Gemini: $e\nContent: $jsonContent',
        );
      }
    } catch (e) {
      throw Exception('Gemini Model $model failed: ${e.toString()}');
    }
  }
}
