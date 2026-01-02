import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import 'llm_service.dart';

class OpenRouterService extends LlmService {
  @override
  Future<Map<String, dynamic>> analyzeCode({
    required String code,
    required String logs,
    required String focus,
  }) async {
    // Choose appropriate model list - all text now, or if we had vision we would select based on capability.
    // Since we removed image input, we use fallback/text models.
    final modelList = ApiConstants.fallbackModels;

    // Try each model in the appropriate list
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
        // If this is the last model, throw the error
        if (i == modelList.length - 1) {
          throw Exception('All models failed. Last error: ${e.toString()}');
        }
        // Otherwise, try next model
        continue;
      }
    }
    throw Exception('Failed to analyze code with any available model');
  }

  Future<Map<String, dynamic>> _tryAnalyzeWithModel({
    required String model,
    required String code,
    required String logs,
    required String focus,
  }) async {
    try {
      // Construct user message
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

      userContent = textMessage;

      if (textMessage.isEmpty) {
        throw Exception('No input provided. Please provide code or logs.');
      }

      // Prepare request body
      final requestBody = {
        'model': model,
        'messages': [
          {'role': 'system', 'content': ApiConstants.systemPrompt},
          {'role': 'user', 'content': userContent},
        ],
        'temperature': 0.2,
        'max_tokens': 4000,
        'response_format': {'type': 'json_object'},
      };

      // Make API request (using openRouterBaseUrl)
      final response = await http
          .post(
            Uri.parse(ApiConstants.openRouterBaseUrl),
            headers: {
              'Content-Type': ApiConstants.contentType,
              'Authorization': 'Bearer ${ApiConstants.openRouterApiKey}',
              'HTTP-Referer': 'https://ai-code-mentor.app',
              'X-Title': 'AI Code Mentor',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(
            const Duration(seconds: 60),
            onTimeout: () {
              throw Exception('Request timeout. Please try again.');
            },
          );

      // Check response status
      if (response.statusCode == 404) {
        throw Exception('Model endpoint not found. Trying next model...');
      } else if (response.statusCode != 200) {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }

      // Parse response
      final dynamic responseData;
      try {
        responseData = jsonDecode(response.body);
      } catch (e) {
        throw Exception('Failed to parse API response body: ${e.toString()}');
      }

      if (responseData is! Map<String, dynamic>) {
        throw Exception('Invalid API response format');
      }

      // Extract AI response content with better error handling
      final choices = responseData['choices'];
      if (choices == null || choices is! List || choices.isEmpty) {
        throw Exception('No choices field in API response');
      }

      final firstChoice = choices[0];
      final message = firstChoice['message'];
      final content = message['content'];

      String contentText;
      if (content is String) {
        contentText = content;
      } else if (content is List && content.isNotEmpty) {
        final textParts =
            content
                .where((item) => item is Map && item['type'] == 'text')
                .map((item) => item['text'] as String)
                .toList();
        contentText = textParts.join('\n');
      } else {
        throw Exception('Invalid content format');
      }

      if (contentText.isEmpty) throw Exception('Empty content');

      // Sanitize and Parse JSON using base class method
      String jsonContent = sanitizeJson(contentText);

      try {
        final analysisResult = jsonDecode(jsonContent) as Map<String, dynamic>;

        // Validate required fields
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
          'Failed to decode JSON from AI: $e\nContent: $jsonContent',
        );
      }
    } catch (e) {
      throw Exception('Model $model failed: ${e.toString()}');
    }
  }

  // _sanitizeJson removed as it is now in base class
}
