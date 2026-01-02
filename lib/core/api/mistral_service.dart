import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import 'llm_service.dart';

class MistralService extends LlmService {
  @override
  Future<Map<String, dynamic>> analyzeCode({
    required String code,
    required String logs,
    required String focus,
  }) async {
    // Mistral API via their standard endpoint.
    final modelList = ApiConstants.mistralModels;

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
            'All Mistral models failed. Last error: ${e.toString()}',
          );
        }
        continue;
      }
    }
    throw Exception('Failed to analyze code with any available Mistral model');
  }

  Future<Map<String, dynamic>> _tryAnalyzeWithModel({
    required String model,
    required String code,
    required String logs,
    required String focus,
  }) async {
    try {
      dynamic userContent;
      String textMessage = '';

      if (code.isNotEmpty) {
        textMessage += 'Code:\n```\n$code\n```\n\n';
      }

      if (logs.isNotEmpty) {
        textMessage += 'Error Logs:\n```\n$logs\n```\n\n';
      }

      textMessage += 'Analysis Focus: $focus\n';
      textMessage +=
          'Please optimize your analysis based on the selected focus above.\n';

      if (textMessage.isEmpty) {
        throw Exception('No input provided. Please provide code or logs.');
      }

      userContent = textMessage;

      final requestBody = {
        'model': model,
        'messages': [
          {'role': 'system', 'content': ApiConstants.systemPrompt},
          {'role': 'user', 'content': userContent},
        ],
        'temperature': 0.2,
        'max_tokens': 2000,
        'response_format': {'type': 'json_object'},
      };

      final response = await http
          .post(
            Uri.parse(ApiConstants.mistralBaseUrl),
            headers: {
              'Content-Type': ApiConstants.contentType,
              'Authorization': 'Bearer ${ApiConstants.mistralApiKey}',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(
            const Duration(seconds: 60),
            onTimeout: () {
              throw Exception('Request timeout. Please try again.');
            },
          );

      if (response.statusCode != 200) {
        // Mistral specific error handling
        throw Exception(
          'Mistral API Error: ${response.statusCode} - ${response.body}',
        );
      }

      final responseData = jsonDecode(response.body);
      final choices = responseData['choices'];
      if (choices == null || choices is! List || choices.isEmpty) {
        throw Exception('No choices field in Mistral API response');
      }

      final content = choices[0]['message']['content'];
      String contentText = content.toString();

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
          'Failed to decode JSON from Mistral: $e\nContent: $jsonContent',
        );
      }
    } catch (e) {
      throw Exception('Mistral Model $model failed: ${e.toString()}');
    }
  }
}
