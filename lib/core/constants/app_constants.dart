class AppConstants {
  // App Info
  static const String appName = 'Ai Code mentor';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String historyKey = 'analysis_history';
  static const String themeKey = 'theme_mode';
  static const String llmProviderKey = 'llm_provider';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double cardElevation = 2.0;

  // Code Editor
  static const int maxCodeLength = 50000; // 50KB max
  static const int tabSize = 2;

  // History
  static const int maxHistoryItems = 50;

  // API
  static const int apiTimeoutSeconds = 60;
}
