import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class StorageService {
  static Future<void> saveAnalysis(Map<String, dynamic> analysis) async {
    final prefs = await SharedPreferences.getInstance();

    // Add timestamp
    analysis['timestamp'] = DateTime.now().toIso8601String();

    // Get existing history
    final history = await getHistory();

    // Add new analysis at the beginning
    history.insert(0, analysis);

    // Limit history size
    if (history.length > AppConstants.maxHistoryItems) {
      history.removeRange(AppConstants.maxHistoryItems, history.length);
    }

    // Save to SharedPreferences
    final jsonString = jsonEncode(history);
    await prefs.setString(AppConstants.historyKey, jsonString);
  }

  static Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(AppConstants.historyKey);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((item) => item as Map<String, dynamic>).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.historyKey);
  }

  static Future<void> deleteHistoryItem(int index) async {
    final history = await getHistory();

    if (index >= 0 && index < history.length) {
      history.removeAt(index);

      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(history);
      await prefs.setString(AppConstants.historyKey, jsonString);
    }
  }

  static Future<void> saveThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.themeKey, mode);
  }

  static Future<String?> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.themeKey);
  }

  static Future<void> saveLlmProvider(String provider) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.llmProviderKey, provider);
  }

  static Future<String> getLlmProvider() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.llmProviderKey) ?? 'openrouter';
  }
}
