import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class DocumentationScreen extends StatelessWidget {
  const DocumentationScreen({super.key});

  static const String _docContent = """
# AI Code Mentor Documentation

Welcome to AI Code Mentor! This tool helps you analyze, debug, and optimize your code using advanced AI models.

## Features

### 1. Code Analysis
- **General Review**: Get a comprehensive overview of your code quality.
- **Performance**: Identify bottlenecks and optimization opportunities.
- **Security**: Detect vulnerabilities and safety risks.
- **Clean Code**: Suggestions for readability and maintainability.

### 2. How to Use
1.  Navigate to the **Home Screen**.
2.  Click **"Analyze Code"** or the **Sparkles** icon.
3.  Select your **Focus Area** (e.g., Performance).
4.  Paste your code snippet or error logs.
5.  Click **Run Analysis**.
6.  View detailed results, scores, and fix suggestions.

### 3. Settings
- Configure your preferred AI Model (Gemini, etc.).
- Switch between Dark and Light themes.

## FAQ
**Q: Is my code saved safely?**
A: Your code is analyzed for the session and not permanently stored on external servers beyond the analysis request.

**Q: Can I analyze Python code?**
A: Yes! The tool supports multiple languages including Dart, Python, JavaScript, and more.
""";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Documentation", style: theme.textTheme.headlineSmall),
        centerTitle: true,
      ),
      body: Markdown(
        data: _docContent,
        padding: const EdgeInsets.all(24),
        styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
          h1: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold),
          h2: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            height: 2,
          ),
          p: GoogleFonts.plusJakartaSans(fontSize: 16, height: 1.6),
          code: GoogleFonts.jetBrainsMono(
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
          ),
        ),
      ),
    );
  }
}
