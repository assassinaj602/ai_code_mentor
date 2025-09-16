import 'package:flutter/material.dart';

/// A simple, reusable Tic Tac Toe board widget.
/// Delegates tap handling and rendering of each cell's symbol.
class SimpleBoard extends StatelessWidget {
  final List<String> flatBoard; // length 9, row-major
  final void Function(int index) onTap;
  final Set<int> highlight; // indices to highlight as winning
  final bool enabled;

  const SimpleBoard({
    super.key,
    required this.flatBoard,
    required this.onTap,
    this.highlight = const {},
    this.enabled = true,
  }) : assert(flatBoard.length == 9, 'Board must have exactly 9 cells');

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest.shortestSide;
        final boardSize =
            size == double.infinity ? 320.0 : size.clamp(240.0, 420.0);
        return SizedBox(
          width: boardSize,
          height: boardSize,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 9,
            itemBuilder: (context, index) => _Tile(
              value: flatBoard[index],
              highlighted: highlight.contains(index),
              onPressed: enabled && flatBoard[index].isEmpty
                  ? () => onTap(index)
                  : null,
            ),
          ),
        );
      },
    );
  }
}

class _Tile extends StatelessWidget {
  final String value;
  final bool highlighted;
  final VoidCallback? onPressed;

  const _Tile({
    required this.value,
    required this.highlighted,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final Color baseBorder =
        highlighted ? scheme.primary : scheme.outlineVariant.withOpacity(0.6);
    final List<Color> gradient = highlighted
        ? [scheme.primaryContainer, scheme.primary.withOpacity(0.45)]
        : [scheme.surfaceVariant, scheme.surface];

    return AnimatedScale(
      scale: highlighted ? 1.05 : 1.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: baseBorder,
            width: highlighted ? 3 : 2,
          ),
          boxShadow: [
            if (highlighted)
              BoxShadow(
                color: scheme.primary.withOpacity(0.35),
                blurRadius: 12,
                spreadRadius: 1,
              ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onPressed,
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: value.isEmpty
                    ? const SizedBox.shrink()
                    : FittedBox(
                        key: ValueKey(value),
                        child: Icon(
                          value == 'X' ? Icons.close : Icons.circle_outlined,
                          color: value == 'X' ? scheme.error : scheme.primary,
                          size: 64,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
