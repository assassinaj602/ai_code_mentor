import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/repositories/llm_repository.dart';
import '../../../core/utils/storage_service.dart';
import '../models/analysis_result.dart';

// Code input state
class CodeInputState {
  final String code;
  final String logs;
  final String? imagePath;

  CodeInputState({this.code = '', this.logs = '', this.imagePath});

  CodeInputState copyWith({String? code, String? logs, String? imagePath}) {
    return CodeInputState(
      code: code ?? this.code,
      logs: logs ?? this.logs,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

// Code input provider
class CodeInputNotifier extends StateNotifier<CodeInputState> {
  CodeInputNotifier() : super(CodeInputState());

  void updateCode(String code) {
    state = state.copyWith(code: code);
  }

  void updateLogs(String logs) {
    state = state.copyWith(logs: logs);
  }

  void updateImage(String? imagePath) {
    state = state.copyWith(imagePath: imagePath);
  }

  void clear() {
    state = CodeInputState();
  }
}

final codeInputProvider =
    StateNotifierProvider<CodeInputNotifier, CodeInputState>((ref) {
      return CodeInputNotifier();
    });

// Analysis state
enum AnalysisStatus { idle, loading, success, error }

class AnalysisState {
  final AnalysisStatus status;
  final AnalysisResult? result;
  final String? error;

  AnalysisState({this.status = AnalysisStatus.idle, this.result, this.error});

  AnalysisState copyWith({
    AnalysisStatus? status,
    AnalysisResult? result,
    String? error,
  }) {
    return AnalysisState(
      status: status ?? this.status,
      result: result ?? this.result,
      error: error ?? this.error,
    );
  }
}

// Analysis provider
class AnalysisNotifier extends StateNotifier<AnalysisState> {
  final LlmRepository _repository;

  AnalysisNotifier(this._repository) : super(AnalysisState());

  Future<void> analyzeCode({
    required String code,
    required String logs,
    required String focus,
    required String provider,
  }) async {
    state = state.copyWith(status: AnalysisStatus.loading);

    try {
      final response = await _repository.analyzeCode(
        code: code,
        logs: logs,
        focus: focus,
        provider: provider,
      );

      final result = AnalysisResult.fromJson({
        ...response,
        'original_code': code,
        'logs': logs,
        'focus': focus,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Save to history
      await StorageService.saveAnalysis(result.toJson());

      state = state.copyWith(
        status: AnalysisStatus.success,
        result: result,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(status: AnalysisStatus.error, error: e.toString());
    }
  }

  void reset() {
    state = AnalysisState();
  }
}

final analysisProvider = StateNotifierProvider<AnalysisNotifier, AnalysisState>(
  (ref) {
    return AnalysisNotifier(LlmRepository());
  },
);

// History provider
final historyProvider = FutureProvider<List<AnalysisResult>>((ref) async {
  final history = await StorageService.getHistory();
  return history.map((json) => AnalysisResult.fromJson(json)).toList();
});

// Theme mode provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, String>((
  ref,
) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<String> {
  ThemeModeNotifier() : super('system') {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final mode = await StorageService.getThemeMode();
    if (mode != null) {
      state = mode;
    }
  }

  Future<void> setThemeMode(String mode) async {
    state = mode;
    await StorageService.saveThemeMode(mode);
  }
}

// LLM Provider Notifier
final llmProviderNotifierProvider =
    StateNotifierProvider<LlmProviderNotifier, String>((ref) {
      return LlmProviderNotifier();
    });

class LlmProviderNotifier extends StateNotifier<String> {
  LlmProviderNotifier() : super('openrouter') {
    _loadProvider();
  }

  Future<void> _loadProvider() async {
    final provider = await StorageService.getLlmProvider();
    state = provider;
  }

  Future<void> setProvider(String provider) async {
    state = provider;
    await StorageService.saveLlmProvider(provider);
  }
}
