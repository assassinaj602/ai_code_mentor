import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  // OpenRouter API
  static const String openRouterBaseUrl =
      'https://openrouter.ai/api/v1/chat/completions';
  static String get openRouterApiKey => dotenv.env['OPENROUTER_API_KEY'] ?? '';

  // Gemini API
  // Note: Gemini often uses a different URL structure or client SDK, but for REST it's usually this:
  static const String geminiBaseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';
  // For vision models it might differ, but we'll abstract that in the service.
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  // Groq API
  static const String groqBaseUrl =
      'https://api.groq.com/openai/v1/chat/completions';
  static String get groqApiKey => dotenv.env['GROQ_API_KEY'] ?? '';

  // Mistral API
  static const String mistralBaseUrl =
      'https://api.mistral.ai/v1/chat/completions';
  static String get mistralApiKey => dotenv.env['MISTRAL_API_KEY'] ?? '';

  // API Headers
  static const String contentType = 'application/json';

  // Model Selection
  static const String defaultModel = 'meta-llama/llama-3.3-70b-instruct:free';

  // Fallback models (all free)
  static const List<String> fallbackModels = [
    'meta-llama/llama-3.3-70b-instruct:free',
    'google/gemini-2.0-flash-exp:free',
    'mistralai/mistral-7b-instruct:free',
    'qwen/qwen-2-7b-instruct:free',
    'huggingfaceh4/zephyr-7b-beta:free',
  ];

  // Vision-capable models for image analysis
  static const List<String> visionModels = [
    'google/gemini-2.0-flash-exp:free',
    'meta-llama/llama-3.2-11b-vision-instruct:free',
    'qwen/qwen-2-vl-7b-instruct:free',
  ];

  // Groq Models
  static const List<String> groqModels = [
    'llama-3.1-70b-versatile', // High performance
    'llama-3.1-8b-instant', // Fast
    'gemma2-9b-it', // Re-adding as it might be available, otherwise stick to LlaMas
  ];
  // Re-verify gemma2-9b-it status. User logs said "gemma2-9b-it" was decommissioned in previous turn?
  // Wait, the log in Step 649 said: "The model `gemma2-9b-it` has been decommissioned".
  // The log in Step 712 said: "The model `mixtral-8x7b-32768` has been decommissioned".
  // So BOTH are out. Use Llama 3.3 if available or 3.1.

  static const List<String> groqTextModels = [
    'llama-3.3-70b-versatile',
    'llama-3.1-8b-instant',
    'llama-3.1-70b-versatile',
  ];

  static const List<String> groqVisionModels = [
    'llama-3.2-11b-vision-preview',
    'llama-3.2-90b-vision-preview',
  ];

  // Gemini Models
  static const List<String> geminiModels = [
    'gemini-1.5-flash',
    'gemini-1.5-pro',
  ];

  // Mistral Models
  static const List<String> mistralModels = [
    'mistral-tiny', // Cheapest/Free
    'mistral-small',
    'mistral-medium',
  ];

  // System Prompt
  static const String systemPrompt = '''
You are an expert AI Code Mentor. Your task is to analyze code, error logs, or screenshots provided by the user.

IMPORTANT: You must ALWAYS respond with a raw, valid JSON object.
- Do NOT wrap the JSON in markdown code blocks (like ```json ... ``` or ``` ... ```).
- Do NOT include any text outside the JSON object.
- Do NOT use triple quotes (""") for strings. Use standard double quotes (") and escape newlines with \\n.
- Do NOT use keys that are not defined in the structure below.

The JSON structure must be exactly as follows:
{
  "language": "detected programming language (e.g. 'Dart', 'Python', 'Unknown')",
  "root_cause": "Concise bullet points explaining the main issue or error found.",
  "fixed_code": "The corrected and optimized version of the code.",
  "explanation_beginner": "A simple, non-technical explanation. Use bullet points for steps if needed.",
  "explanation_intermediate": "Detailed explanation with tech concepts. Use bullet points for clarity.",
  "explanation_expert": "Deep dive into mechanics and performance. Structured with bullet points.",
  "best_practices": "A bulleted list of best practices.",
  "alternative_solution": "Brief description of a different approach.",
  "score": 0
}

Guidelines:
1. **Analyze Deeply**: Don't just look for syntax errors. Look for logic bugs, performance issues, and bad practices.
2. **Be Specific**: Avoid generic advice. Tailor the "best_practices" and "explanations" to the exact code provided.
3. **Handle Missing Context**: If the code snippet is too short or ambiguous to find an error, assume standard context or ask for clarification in the "root_cause" field. Do NOT return "N/A" unless absolutely necessary.
4. **Formatting**: Espace all double quotes and special characters within the JSON strings properly (e.g. \" for quotes, \\n for newlines).
5. **Score**: Provide an integer score from 0 to 100 representing the quality and correctness of the original code.
''';
}
