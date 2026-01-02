class AnalysisResult {
  final String language;
  final String rootCause;
  final String fixedCode;
  final String explanationBeginner;
  final String explanationIntermediate;
  final String explanationExpert;
  final String bestPractices;
  final String alternativeSolution;
  final String originalCode;
  final String logs;
  final String focus;
  final DateTime timestamp;

  AnalysisResult({
    required this.language,
    required this.rootCause,
    required this.fixedCode,
    required this.explanationBeginner,
    required this.explanationIntermediate,
    required this.explanationExpert,
    required this.bestPractices,
    required this.alternativeSolution,
    required this.originalCode,
    required this.logs,
    this.focus = 'General Review',
    required this.timestamp,
    this.score = 0,
  });

  final int score;

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      language: json['language']?.toString() ?? 'Unknown',
      rootCause: json['root_cause']?.toString() ?? 'N/A',
      fixedCode: json['fixed_code']?.toString() ?? '',
      explanationBeginner: json['explanation_beginner']?.toString() ?? 'N/A',
      explanationIntermediate:
          json['explanation_intermediate']?.toString() ?? 'N/A',
      explanationExpert: json['explanation_expert']?.toString() ?? 'N/A',
      bestPractices: json['best_practices']?.toString() ?? 'N/A',
      alternativeSolution: json['alternative_solution']?.toString() ?? 'N/A',
      originalCode: json['original_code']?.toString() ?? '',
      logs: json['logs']?.toString() ?? '',
      focus: json['focus']?.toString() ?? 'General Review',
      timestamp:
          json['timestamp'] != null
              ? DateTime.tryParse(json['timestamp'].toString()) ??
                  DateTime.now()
              : DateTime.now(),
      score: int.tryParse(json['score']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'root_cause': rootCause,
      'fixed_code': fixedCode,
      'explanation_beginner': explanationBeginner,
      'explanation_intermediate': explanationIntermediate,
      'explanation_expert': explanationExpert,
      'best_practices': bestPractices,
      'alternative_solution': alternativeSolution,
      'original_code': originalCode,
      'logs': logs,
      'focus': focus,
      'timestamp': timestamp.toIso8601String(),
      'score': score,
    };
  }

  AnalysisResult copyWith({
    String? language,
    String? rootCause,
    String? fixedCode,
    String? explanationBeginner,
    String? explanationIntermediate,
    String? explanationExpert,
    String? bestPractices,
    String? alternativeSolution,
    String? originalCode,
    String? logs,
    String? focus,
    DateTime? timestamp,
    int? score,
  }) {
    return AnalysisResult(
      language: language ?? this.language,
      rootCause: rootCause ?? this.rootCause,
      fixedCode: fixedCode ?? this.fixedCode,
      explanationBeginner: explanationBeginner ?? this.explanationBeginner,
      explanationIntermediate:
          explanationIntermediate ?? this.explanationIntermediate,
      explanationExpert: explanationExpert ?? this.explanationExpert,
      bestPractices: bestPractices ?? this.bestPractices,
      alternativeSolution: alternativeSolution ?? this.alternativeSolution,
      originalCode: originalCode ?? this.originalCode,
      logs: logs ?? this.logs,
      focus: focus ?? this.focus,
      timestamp: timestamp ?? this.timestamp,
      score: score ?? this.score,
    );
  }
}
