import '../api/openrouter_service.dart';
import '../api/gemini_service.dart';
import '../api/groq_service.dart';
import '../api/mistral_service.dart';

class LlmRepository {
  final GroqService _groqService;
  final GeminiService _geminiService;
  final OpenRouterService _openRouterService;
  final MistralService _mistralService;

  LlmRepository()
    : _groqService = GroqService(),
      _geminiService = GeminiService(),
      _openRouterService = OpenRouterService(),
      _mistralService = MistralService();

  Future<Map<String, dynamic>> analyzeCode({
    required String code,
    required String logs,
    required String focus,
    required String provider,
  }) async {
    // Define the fallback chain order
    final List<String> providerChain = [
      provider.toLowerCase(), // Try selected first
      'groq', // Fast & Free
      'gemini', // Reliable & Free tiers
      'mistral', // Open Source
      'openrouter', // Aggregator (last resort)
    ];

    // Remove duplicates while preserving order (in case selected is in the list)
    final uniqueChain = providerChain.toSet().toList();

    Exception? lastError;

    for (final currentProvider in uniqueChain) {
      try {
        print('Attempting analysis with: $currentProvider');
        switch (currentProvider) {
          case 'groq':
            return await _groqService.analyzeCode(
              code: code,
              logs: logs,
              focus: focus,
            );
          case 'gemini':
            return await _geminiService.analyzeCode(
              code: code,
              logs: logs,
              focus: focus,
            );
          case 'mistral':
            return await _mistralService.analyzeCode(
              code: code,
              logs: logs,
              focus: focus,
            );
          case 'openrouter':
            return await _openRouterService.analyzeCode(
              code: code,
              logs: logs,
              focus: focus,
            );
          default:
            // Should not happen as we control the chain, but skip if unknown
            continue;
        }
      } catch (e) {
        print('Provider $currentProvider failed: $e');
        lastError = Exception('Provider $currentProvider failed: $e');
        // Continue to next provider in the chain
        continue;
      }
    }

    // If loop finishes without returning, all failed
    throw lastError ??
        Exception(
          'All AI services failed. Please check your internet connection.',
        );
  }
}
