import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:highlight/languages/dart.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/analysis_provider.dart';
import 'result_screen.dart';

class InputScreen extends ConsumerStatefulWidget {
  const InputScreen({super.key});

  @override
  ConsumerState<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends ConsumerState<InputScreen> {
  final CodeController _codeController = CodeController(
    text: '',
    language: dart,
  );

  final TextEditingController _logsController = TextEditingController();

  String _selectedFocus = 'General Review';
  final List<String> _focusOptions = [
    'General Review',
    'Performance',
    'Security',
    'Clean Code',
  ];

  final Map<String, IconData> _focusIcons = {
    'General Review': LucideIcons.scanLine,
    'Performance': LucideIcons.zap,
    'Security': LucideIcons.shieldAlert,
    'Clean Code': LucideIcons.sparkles,
  };

  bool _isAnalyzing = false;
  String? _error;

  @override
  void dispose() {
    _codeController.dispose();
    _logsController.dispose();
    super.dispose();
  }

  Future<void> _analyze() async {
    String code = _codeController.text.trim();
    String logs = _logsController.text.trim();

    if (code.isEmpty && logs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide code or logs for analysis'),
        ),
      );
      return;
    }

    setState(() => _isAnalyzing = true);

    try {
      final provider = ref.read(llmProviderNotifierProvider);
      await ref
          .read(analysisProvider.notifier)
          .analyzeCode(
            code: code,
            logs: logs,
            focus: _selectedFocus,
            provider: provider,
          );

      if (mounted) {
        setState(() => _isAnalyzing = false);
        final analysisState = ref.read(analysisProvider);
        if (analysisState.status == AnalysisStatus.success) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ResultScreen()),
          );
        } else if (analysisState.status == AnalysisStatus.error) {
          _showError(analysisState.error ?? 'Analysis failed');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isAnalyzing = false);
        _showError('Error: ${e.toString()}');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: const Icon(LucideIcons.arrowLeft, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.surfaceContainer,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text("New Analysis", style: theme.textTheme.headlineSmall),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Ambient Glow
          Positioned(
            top: -100,
            left: -100,
            child:
                Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.primary.withOpacity(0.15),
                        backgroundBlendMode: BlendMode.screen,
                      ),
                    )
                    .animate()
                    .scale(duration: 2000.ms, curve: Curves.easeInOut)
                    .fadeIn(),
          ),

          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(24),
                        children: [
                          _buildFocusSelector(theme),
                          const SizedBox(height: 24),
                          _buildCodeEditor(theme),
                          const SizedBox(height: 24),
                          _buildLogsInput(theme),
                          const SizedBox(
                            height: 100,
                          ), // Spacing for fab/bottom bar
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(child: _buildFloatingActionButton(theme)),
          ),
        ],
      ),
    );
  }

  Widget _buildFocusSelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Analysis Focus", style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _focusOptions.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final focus = _focusOptions[index];
              final isSelected = _selectedFocus == focus;
              return GestureDetector(
                onTap: () => setState(() => _selectedFocus = focus),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 100,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          isSelected
                              ? Colors.transparent
                              : theme.colorScheme.outline.withOpacity(0.3),
                    ),
                    boxShadow:
                        isSelected
                            ? [
                              BoxShadow(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.4,
                                ),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                            : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _focusIcons[focus],
                        color:
                            isSelected
                                ? Colors.white
                                : theme.colorScheme.onSurface,
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        focus.split(' ')[0], // First word only for layout
                        style: theme.textTheme.labelSmall?.copyWith(
                          color:
                              isSelected
                                  ? Colors.white
                                  : theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ).animate().fadeIn().slideX();
  }

  Widget _buildCodeEditor(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Code Snippet", style: theme.textTheme.titleMedium),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Dart",
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xff282c34),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // Editor Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                color: Colors.black12,
                child: Row(
                  children: [
                    _buildWindowDot(const Color(0xFFFF5F56)),
                    const SizedBox(width: 8),
                    _buildWindowDot(const Color(0xFFFFBD2E)),
                    const SizedBox(width: 8),
                    _buildWindowDot(const Color(0xFF27C93F)),
                  ],
                ),
              ),
              CodeTheme(
                data: CodeThemeData(styles: atomOneDarkTheme),
                child: CodeField(
                  controller: _codeController,
                  textStyle: GoogleFonts.jetBrainsMono(fontSize: 14),
                  minLines: 12,
                  decoration: const BoxDecoration(),
                ),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn().slideY(begin: 0.1, delay: 100.ms);
  }

  Widget _buildWindowDot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildLogsInput(ThemeData theme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          backgroundColor: theme.colorScheme.surfaceContainer,
          collapsedBackgroundColor: theme.colorScheme.surfaceContainer,
          title: Row(
            children: [
              Icon(
                LucideIcons.terminal,
                size: 20,
                color: theme.colorScheme.tertiary,
              ),
              const SizedBox(width: 12),
              const Text("Error Logs / Trace"),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _logsController,
                maxLines: 6,
                style: GoogleFonts.jetBrainsMono(fontSize: 13),
                decoration: InputDecoration(
                  hintText: "Paste runtime errors here...",
                  filled: true,
                  fillColor:
                      theme.brightness == Brightness.dark
                          ? const Color(0xFF1E1E1E)
                          : Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.1, delay: 200.ms);
  }

  Widget _buildFloatingActionButton(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: _isAnalyzing ? null : _analyze,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        icon:
            _isAnalyzing
                ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                : const Icon(LucideIcons.sparkles),
        label: Text(
          _isAnalyzing ? "Analyzing..." : "Run Analysis",
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    ).animate().scale(delay: 500.ms);
  }
}
