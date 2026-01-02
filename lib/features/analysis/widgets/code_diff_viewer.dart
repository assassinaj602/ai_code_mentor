import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CodeDiffViewer extends StatelessWidget {
  final String originalCode;
  final String fixedCode;

  const CodeDiffViewer({
    super.key,
    required this.originalCode,
    required this.fixedCode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Split code into lines
    final originalLines = originalCode.split('\n');
    final fixedLines = fixedCode.split('\n');

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff282c34) : const Color(0xffffffff),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withOpacity(
                  0.5,
                ),
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.3),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Icons.remove_circle_outline,
                            color: Colors.red[400],
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Original Code',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 20,
                    color: theme.colorScheme.outline.withOpacity(0.3),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Icons.add_circle_outline,
                            color: Colors.green[400],
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Fixed Code',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Diff Content - Scrollable
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: IntrinsicWidth(
                  child: _buildSimpleDiff(context, originalLines, fixedLines),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleDiff(
    BuildContext context,
    List<String> originalLines,
    List<String> fixedLines,
  ) {
    final maxLines =
        originalLines.length > fixedLines.length
            ? originalLines.length
            : fixedLines.length;

    List<Widget> rows = [];

    for (int i = 0; i < maxLines; i++) {
      final originalLine = i < originalLines.length ? originalLines[i] : '';
      final fixedLine = i < fixedLines.length ? fixedLines[i] : '';

      // Determine if lines are different
      final isDifferent = originalLine != fixedLine;
      final isOnlyInOriginal = i >= fixedLines.length;
      final isOnlyInFixed = i >= originalLines.length;

      rows.add(
        _buildDiffRow(
          context: context,
          lineNumber: i + 1,
          leftLine: originalLine,
          rightLine: fixedLine,
          isDifferent: isDifferent,
          isOnlyInOriginal: isOnlyInOriginal,
          isOnlyInFixed: isOnlyInFixed,
        ),
      );
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows);
  }

  Widget _buildDiffRow({
    required BuildContext context,
    required int lineNumber,
    required String leftLine,
    required String rightLine,
    required bool isDifferent,
    required bool isOnlyInOriginal,
    required bool isOnlyInFixed,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color? bgColor;
    Color? borderColor;
    Color textColor =
        isDark ? const Color(0xffabb2bf) : const Color(0xff24292e);

    if (isOnlyInOriginal) {
      // Line only in original (removed)
      bgColor = isDark ? const Color(0xff4b1d22) : const Color(0xffffeef0);
      borderColor = isDark ? const Color(0xffe06c75) : const Color(0xffcb2431);
    } else if (isOnlyInFixed) {
      // Line only in fixed (added)
      bgColor = isDark ? const Color(0xff163825) : const Color(0xffe6ffed);
      borderColor = isDark ? const Color(0xff98c379) : const Color(0xff22863a);
    } else if (isDifferent) {
      // Line modified
      bgColor = isDark ? const Color(0xff45381f) : const Color(0xfffff5b1);
      borderColor = isDark ? const Color(0xffe5c07b) : const Color(0xffb08800);
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border:
            borderColor != null
                ? Border(left: BorderSide(color: borderColor, width: 3))
                : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // For IntrinsicWidth
          children: [
            // Line number
            SizedBox(
              width: 40,
              child: Text(
                '$lineNumber',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                ),
              ),
            ),

            // Original code (left)
            Container(
              constraints: const BoxConstraints(minWidth: 300, maxWidth: 500),
              child: Text(
                leftLine,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12,
                  color:
                      isOnlyInOriginal
                          ? (isDark
                              ? const Color(0xffe06c75)
                              : const Color(0xffcb2431))
                          : textColor,
                  decoration:
                      isOnlyInOriginal ? TextDecoration.lineThrough : null,
                ),
              ),
            ),

            // Divider
            Container(
              width: 1,
              height: 20,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              color: theme.colorScheme.outline.withOpacity(0.3),
            ),

            // Fixed code (right)
            Container(
              constraints: const BoxConstraints(minWidth: 300, maxWidth: 500),
              child: Text(
                rightLine,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12,
                  color:
                      isOnlyInFixed
                          ? (isDark
                              ? const Color(0xff98c379)
                              : const Color(0xff22863a))
                          : textColor,
                  fontWeight:
                      isOnlyInFixed || (isDifferent && !isOnlyInOriginal)
                          ? FontWeight.bold
                          : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
