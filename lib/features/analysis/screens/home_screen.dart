import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'input_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../documentation/screens/documentation_screen.dart';
import '../../auth/providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final user = ref.watch(authProvider).user;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Dynamic Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(color: theme.colorScheme.surface),
              child: CustomPaint(
                painter: BackgroundMeshPainter(
                  color1: theme.colorScheme.primary.withOpacity(
                    isDark ? 0.2 : 0.1,
                  ),
                  color2: theme.colorScheme.secondary.withOpacity(
                    isDark ? 0.2 : 0.1,
                  ),
                  isDark: isDark,
                ),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Row(
                  children: [
                    // Desktop Sidebar (Visible > 900px)
                    if (MediaQuery.of(context).size.width > 900)
                      _buildSidebar(context, theme),

                    // Main Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(context, theme, user?.name),
                            const SizedBox(height: 32),
                            _buildHeroSection(context, theme),
                            const SizedBox(height: 32),
                            Text(
                              "Quick Actions",
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ).animate().fadeIn().moveX(),
                            const SizedBox(height: 16),
                            _buildActionGrid(context, theme),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, ThemeData theme) {
    return Container(
      width: 80,
      margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Icon(LucideIcons.code2, color: theme.colorScheme.primary, size: 32),
          const SizedBox(height: 48),
          _SidebarItem(icon: LucideIcons.home, isActive: true, onTap: () {}),
          const SizedBox(height: 24),
          _SidebarItem(
            icon: LucideIcons.history,
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HistoryScreen()),
                ),
          ),
          const SizedBox(height: 24),
          _SidebarItem(
            icon: LucideIcons.settings,
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                ),
          ),
          const Spacer(),
          _SidebarItem(
            icon: LucideIcons.user,
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    ).animate().fadeIn().moveX(begin: -20);
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, String? userName) {
    return Row(
      children: [
        if (MediaQuery.of(context).size.width <= 900) ...[
          IconButton(
            onPressed: () {},
            icon: Icon(LucideIcons.menu, color: theme.colorScheme.onSurface),
          ),
          const SizedBox(width: 16),
        ],
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome back,", style: theme.textTheme.bodyMedium),
            Text(
              userName ?? "Muhammad Assad Ullah",
              style: theme.textTheme.headlineMedium,
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              ),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: theme.colorScheme.primary, width: 2),
            ),
            child: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(LucideIcons.user),
            ),
          ),
        ),
      ],
    ).animate().fadeIn().moveY(begin: -20);
  }

  Widget _buildHeroSection(BuildContext context, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Pattern
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              LucideIcons.code,
              size: 200,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "AI Configured",
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Start New Analysis",
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Detect bugs, security risks, & performance issues instantly.",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InputScreen(),
                    ),
                  );
                },
                icon: const Icon(LucideIcons.sparkles, size: 18),
                label: const Text("Analyze Code"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().scale();
  }

  Widget _buildActionGrid(BuildContext context, ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 3 : 1;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _ActionCard(
              title: "View History",
              description: "Past analyses",
              icon: LucideIcons.history,
              color: theme.colorScheme.tertiary,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HistoryScreen(),
                  ),
                );
              },
            ),
            _ActionCard(
              title: "Settings",
              description: "Configure models",
              icon: LucideIcons.settings,
              color: const Color(0xFFF59E0B), // Amber
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
            _ActionCard(
              title: "Documentation",
              description: "Learn more",
              icon: LucideIcons.bookOpen,
              color: theme.colorScheme.secondary,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DocumentationScreen(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow:
              isActive
                  ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : null,
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.white : theme.colorScheme.onSurfaceVariant,
          size: 24,
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const Spacer(),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(description, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }
}

class BackgroundMeshPainter extends CustomPainter {
  final Color color1;
  final Color color2;
  final bool isDark;

  BackgroundMeshPainter({
    required this.color1,
    required this.color2,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100);

    paint.color = color1;
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.1), 200, paint);

    paint.color = color2;
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.6), 300, paint);

    if (!isDark) {
      paint.color = Colors.blue.withOpacity(0.1);
      canvas.drawCircle(
        Offset(size.width * 0.5, size.height * 0.5),
        150,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
