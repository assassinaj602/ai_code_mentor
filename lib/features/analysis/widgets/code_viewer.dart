import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart'; // Better dark theme
import 'package:flutter_highlight/themes/github.dart';
import 'package:google_fonts/google_fonts.dart';

class CodeViewer extends StatelessWidget {
  final String code;
  final String language;

  const CodeViewer({super.key, required this.code, required this.language});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Use Atom One Dark for dark mode, GitHub for light
    final highlightTheme = isDark ? atomOneDarkTheme : githubTheme;
    final bgColor = isDark ? const Color(0xff282c34) : const Color(0xfff6f8fa);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: HighlightView(
            code,
            language: _mapLanguage(language),
            theme: highlightTheme,
            padding: const EdgeInsets.all(16),
            textStyle: GoogleFonts.jetBrainsMono(
              fontSize: 13,
              height: 1.5,
              color: isDark ? const Color(0xffabb2bf) : const Color(0xff24292e),
            ),
          ),
        ),
      ),
    );
  }

  String _mapLanguage(String lang) {
    final normalized = lang.toLowerCase();

    // Map common language names to highlight.js language codes
    final languageMap = {
      'javascript': 'javascript',
      'typescript': 'typescript',
      'python': 'python',
      'java': 'java',
      'c++': 'cpp',
      'c#': 'csharp',
      'csharp': 'csharp',
      'go': 'go',
      'rust': 'rust',
      'ruby': 'ruby',
      'php': 'php',
      'swift': 'swift',
      'kotlin': 'kotlin',
      'dart': 'dart',
      'html': 'xml',
      'css': 'css',
      'sql': 'sql',
      'bash': 'bash',
      'shell': 'bash',
      'json': 'json',
      'yaml': 'yaml',
      'xml': 'xml',
      'markdown': 'markdown',
    };

    return languageMap[normalized] ?? 'plaintext';
  }
}
