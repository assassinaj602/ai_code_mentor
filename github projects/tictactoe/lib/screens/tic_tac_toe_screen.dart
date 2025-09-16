import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// GamePalette ThemeExtension definition (unique cohesive color system)
class GamePalette extends ThemeExtension<GamePalette> {
  final List<Color> backgroundGradient;
  final List<Color> turnIndicatorGradient;
  final List<Color> bottomSheetGradient;
  final List<Color> tileEmptyGradient;
  final List<Color> tileOccupiedGradient;
  final List<Color> tileWinGradient;
  final Color tileBorder;
  final Color tileWinBorder;
  final Color glow;
  final Color overlayScrim;

  const GamePalette({
    required this.backgroundGradient,
    required this.turnIndicatorGradient,
    required this.bottomSheetGradient,
    required this.tileEmptyGradient,
    required this.tileOccupiedGradient,
    required this.tileWinGradient,
    required this.tileBorder,
    required this.tileWinBorder,
    required this.glow,
    required this.overlayScrim,
  });

  static GamePalette generate(ColorScheme scheme, {required bool dark}) {
    Color shift(Color c, double lDelta, {double satMul = 1}) {
      final hsl = HSLColor.fromColor(c);
      return hsl
          .withLightness((hsl.lightness + lDelta).clamp(0.0, 1.0))
          .withSaturation((hsl.saturation * satMul).clamp(0.0, 1.0))
          .toColor();
    }

    final primary = scheme.primary;
    final secondary = scheme.secondary;
    final surface = scheme.surface;

    final bg1 = shift(primary, dark ? -0.55 : 0.55, satMul: 1.05);
    final bg2 = shift(secondary, dark ? -0.4 : 0.45, satMul: 1.05);
    final bg3 = shift(primary, dark ? -0.2 : 0.25).withOpacity(0.35);
    final bg4 = surface;

    final turnA = shift(primary, dark ? 0.1 : -0.05, satMul: 1.1);
    final turnB = shift(secondary, dark ? 0.05 : 0.05, satMul: 1.05);
    final turnC = shift(primary, dark ? 0.2 : -0.15).withOpacity(0.55);

    final emptyA = shift(surface, dark ? 0.05 : 0.0);
    final emptyB = shift(surface, dark ? -0.08 : 0.08);
    final occA = shift(secondary, dark ? -0.1 : 0.15);
    final occB = shift(primary, dark ? -0.05 : 0.25).withOpacity(0.9);
    final winA = shift(primary, dark ? 0.15 : -0.05);
    final winB = shift(primary, dark ? 0.25 : 0.15).withOpacity(0.75);
    final winC = shift(secondary, dark ? 0.20 : 0.05);

    return GamePalette(
      backgroundGradient: [bg1, bg2, bg3, bg4],
      turnIndicatorGradient: [turnA, turnB, turnC],
      bottomSheetGradient: [
        shift(surface, dark ? 0.08 : 0.02),
        surface,
        shift(surface, dark ? -0.05 : 0.06)
      ],
      tileEmptyGradient: [emptyA, emptyB],
      tileOccupiedGradient: [occA, occB],
      tileWinGradient: [winA, winB, winC],
      tileBorder: scheme.outline.withOpacity(0.12),
      tileWinBorder: primary.withOpacity(0.45),
      glow: primary.withOpacity(0.22),
      overlayScrim: Colors.black.withOpacity(0.55),
    );
  }

  // Cyber neon palette inspired by the provided reference (teal, cyan, magenta, deep violet background).
  static GamePalette cyberNeon() {
    // Core hues
    const bgDeep = Color(0xFF0C0D21); // near-black indigo / violet
    const bgMid = Color(0xFF14163A);
    const accentCyan = Color(0xFF00E5FF);
    const accentTeal = Color(0xFF00FFC6);
    const accentMagenta = Color(0xFFFF2DD5);
    const accentPurple = Color(0xFF7A3BFF);
    const glowBase = Color(0xFF5B2BFF);

    return const GamePalette(
      backgroundGradient: [bgDeep, bgMid, Color(0xFF1F2450), Color(0xFF0A0B1A)],
      turnIndicatorGradient: [accentPurple, accentMagenta, accentCyan],
      bottomSheetGradient: [
        Color(0xFF1B1F3E),
        Color(0xFF12152E),
        Color(0xFF0D1025)
      ],
      tileEmptyGradient: [Color(0xFF1E233F), Color(0xFF14182C)],
      tileOccupiedGradient: [accentTeal, accentCyan],
      tileWinGradient: [accentMagenta, accentPurple, accentCyan],
      tileBorder: Color(0xFF6B6F8F),
      tileWinBorder: accentMagenta,
      glow: glowBase,
      overlayScrim: Color(0xCC05060F),
    );
  }

  @override
  GamePalette copyWith({
    List<Color>? backgroundGradient,
    List<Color>? turnIndicatorGradient,
    List<Color>? bottomSheetGradient,
    List<Color>? tileEmptyGradient,
    List<Color>? tileOccupiedGradient,
    List<Color>? tileWinGradient,
    Color? tileBorder,
    Color? tileWinBorder,
    Color? glow,
    Color? overlayScrim,
  }) =>
      GamePalette(
        backgroundGradient: backgroundGradient ?? this.backgroundGradient,
        turnIndicatorGradient:
            turnIndicatorGradient ?? this.turnIndicatorGradient,
        bottomSheetGradient: bottomSheetGradient ?? this.bottomSheetGradient,
        tileEmptyGradient: tileEmptyGradient ?? this.tileEmptyGradient,
        tileOccupiedGradient: tileOccupiedGradient ?? this.tileOccupiedGradient,
        tileWinGradient: tileWinGradient ?? this.tileWinGradient,
        tileBorder: tileBorder ?? this.tileBorder,
        tileWinBorder: tileWinBorder ?? this.tileWinBorder,
        glow: glow ?? this.glow,
        overlayScrim: overlayScrim ?? this.overlayScrim,
      );

  @override
  ThemeExtension<GamePalette> lerp(
      ThemeExtension<GamePalette>? other, double t) {
    if (other is! GamePalette) return this;
    Color lc(Color a, Color b) => Color.lerp(a, b, t)!;
    List<Color> ll(List<Color> a, List<Color> b) {
      final len = a.length < b.length ? a.length : b.length;
      return List.generate(len, (i) => lc(a[i], b[i]));
    }

    return GamePalette(
      backgroundGradient: ll(backgroundGradient, other.backgroundGradient),
      turnIndicatorGradient:
          ll(turnIndicatorGradient, other.turnIndicatorGradient),
      bottomSheetGradient: ll(bottomSheetGradient, other.bottomSheetGradient),
      tileEmptyGradient: ll(tileEmptyGradient, other.tileEmptyGradient),
      tileOccupiedGradient:
          ll(tileOccupiedGradient, other.tileOccupiedGradient),
      tileWinGradient: ll(tileWinGradient, other.tileWinGradient),
      tileBorder: lc(tileBorder, other.tileBorder),
      tileWinBorder: lc(tileWinBorder, other.tileWinBorder),
      glow: lc(glow, other.glow),
      overlayScrim: lc(overlayScrim, other.overlayScrim),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({super.key});

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen>
    with TickerProviderStateMixin {
  // Game state
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  bool gameEnded = false;
  String winner = '';
  // Track winning tile indices for highlight animation
  final Set<int> winningIndices = <int>{};

  // Score tracking
  int xWins = 0;
  int oWins = 0;
  int draws = 0;

  // Settings
  bool isDarkMode = true; // forced dark for always-neon
  bool isHapticFeedbackEnabled = true;

  // Animation controllers
  late AnimationController _celebrationController;
  late AnimationController _pulseController;
  late AnimationController _slideController;

  // Animations
  late Animation<double> _celebrationAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  // Add accent color support with improved color palette
  // Accent palette removed (always neon)
  ThemeData? _currentTheme;

  // Game state icon animation
  late AnimationController _gameIconController;

  bool _snackbarShownForGame = false;

  @override
  void initState() {
    super.initState();
    _buildTheme(); // Build theme immediately with default values
    _initializeAnimations();
    _gameIconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _loadSettings();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _buildTheme();
  }

  void _buildTheme() {
    try {
      // Always dark neon scheme
      final scheme = const ColorScheme.dark();
      final palette = GamePalette.cyberNeon();
      final base = ThemeData(useMaterial3: true, brightness: Brightness.dark);
      _currentTheme = base.copyWith(
        colorScheme: scheme,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: base.textTheme.apply(
          bodyColor: scheme.onSurface,
          displayColor: scheme.onSurface,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        extensions: [palette],
      );
    } catch (e) {
      _currentTheme = ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo, brightness: Brightness.dark),
        useMaterial3: true,
      );
    }
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (mounted) {
        setState(() {
          isDarkMode = true; // force dark
          isHapticFeedbackEnabled = prefs.getBool('haptic_feedback') ?? true;
          xWins = prefs.getInt('x_wins') ?? 0;
          oWins = prefs.getInt('o_wins') ?? 0;
          draws = prefs.getInt('draws') ?? 0;
          // accent removed
        });
        _buildTheme();
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
      // Use default values if loading fails
      if (mounted) {
        setState(() {
          isDarkMode = true;
          isHapticFeedbackEnabled = true;
          xWins = 0;
          oWins = 0;
          draws = 0;
          // accent removed
        });
        _buildTheme();
      }
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.setBool('dark_mode', true),
        prefs.setBool('haptic_feedback', isHapticFeedbackEnabled),
        prefs.setInt('x_wins', xWins),
        prefs.setInt('o_wins', oWins),
        prefs.setInt('draws', draws),
        // Accent & neon toggle persistence removed
      ]);
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }

  // _changeAccent removed (always neon)

  // _toggleTheme removed (always dark neon)

  void _initializeAnimations() {
    try {
      _celebrationController = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      );

      _pulseController = AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: this,
      );

      _slideController = AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );

      _celebrationAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _celebrationController,
        curve: Curves.elasticOut,
      ));

      _pulseAnimation = Tween<double>(
        begin: 1.0,
        end: 1.2,
      ).animate(CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ));

      _slideAnimation = Tween<Offset>(
        begin: const Offset(0, -1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Curves.bounceOut,
      ));

      // Start the slide animation safely
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _slideController.forward();
        }
      });
    } catch (e) {
      debugPrint('Error initializing animations: $e');
    }
  }

  @override
  void dispose() {
    try {
      _celebrationController.dispose();
      _pulseController.dispose();
      _slideController.dispose();
      _gameIconController.dispose();
    } catch (e) {
      debugPrint('Error disposing controllers: $e');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      data: _currentTheme ?? Theme.of(context),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(),
        body: Stack(
          children: [
            // Base linear gradient
            Container(decoration: _buildBackgroundDecoration()),
            // Layered radial neon glows (non-interactive)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _NeonBackdropPainter(
                    palette: Theme.of(context).extension<GamePalette>(),
                  ),
                ),
              ),
            ),
            // Main content
            _buildBody(context),
          ],
        ),
        floatingActionButton: _buildFab(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Hero(
        tag: 'app_title',
        child: Material(
          color: Colors.transparent,
          child: ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (Rect bounds) => LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
            ).createShader(bounds),
            child: const Text(
              'Tic Tac Toe',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: _handleMenuSelection,
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings,
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    const Text('Settings'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'reset_scores',
                child: Row(
                  children: [
                    Icon(Icons.refresh,
                        color: Theme.of(context).colorScheme.error),
                    const SizedBox(width: 8),
                    const Text('Reset Scores'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'about',
                child: Row(
                  children: [
                    Icon(Icons.info,
                        color: Theme.of(context).colorScheme.secondary),
                    const SizedBox(width: 8),
                    const Text('About'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'help',
                child: Row(
                  children: [
                    Icon(Icons.help,
                        color: Theme.of(context).colorScheme.secondary),
                    const SizedBox(width: 8),
                    const Text('Help'),
                  ],
                ),
              ),
            ];
          },
        ),
      ],
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    final gp = Theme.of(context).extension<GamePalette>();
    final colors = gp?.backgroundGradient ??
        [
          Theme.of(context).colorScheme.surface,
          Theme.of(context).colorScheme.surfaceVariant,
        ];
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
        stops: colors.length == 4 ? const [0.0, 0.35, 0.72, 1.0] : null,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool wide = constraints.maxWidth >= 780;
        final content = wide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 4,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildPlayerTurnIndicator(),
                        const SizedBox(height: 20),
                        _buildScoreBoard(),
                        const SizedBox(height: 20),
                        _buildControlButtons(),
                        const SizedBox(height: 20),
                        _buildMoveHistoryPanel(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                  Flexible(
                    flex: 5,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: _buildGameBoard(),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPlayerTurnIndicator(),
                  const SizedBox(height: 20),
                  _buildScoreBoard(),
                  const SizedBox(height: 20),
                  _buildGameBoard(),
                  const SizedBox(height: 12),
                  _buildControlButtons(),
                  const SizedBox(height: 12),
                  _buildMoveHistoryPanel(),
                  const SizedBox(height: 20),
                ],
              );
        return Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: wide ? 48 : 16,
                vertical: 24,
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: SizedBox(
                    key: ValueKey(wide),
                    width: wide ? 1100 : double.infinity,
                    child: content,
                  ),
                ),
              ),
            ),
            if (gameEnded) _buildGameEndOverlay(),
          ],
        );
      },
    );
  }

  // Move history state & panel
  final List<_MoveRecord> _history = [];

  void _recordMove(int index, String player) {
    _history.add(
        _MoveRecord(player: player, index: index, order: _history.length + 1));
  }

  Widget _buildMoveHistoryPanel() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      child: _history.isEmpty
          ? Opacity(
              opacity: 0.6,
              child: Text('No moves yet',
                  style: Theme.of(context).textTheme.bodySmall),
            )
          : Container(
              constraints: const BoxConstraints(maxHeight: 260),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    (Theme.of(context)
                                .extension<GamePalette>()
                                ?.tileEmptyGradient
                                .first ??
                            Theme.of(context).colorScheme.surfaceContainerHigh)
                        .withOpacity(0.85),
                    (Theme.of(context)
                                .extension<GamePalette>()
                                ?.tileEmptyGradient
                                .last ??
                            Theme.of(context).colorScheme.surfaceContainer)
                        .withOpacity(0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: (Theme.of(context).extension<GamePalette>()?.glow ??
                          Theme.of(context).colorScheme.primary)
                      .withOpacity(0.25),
                  width: 1.1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (Theme.of(context).extension<GamePalette>()?.glow ??
                            Theme.of(context).colorScheme.shadow)
                        .withOpacity(0.25),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: (Theme.of(context).extension<GamePalette>()?.glow ??
                            Theme.of(context).colorScheme.primary)
                        .withOpacity(0.15),
                    blurRadius: 32,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: SingleChildScrollView(
                child: Theme(
                  // Tighten expansion panel visual density
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                  ),
                  child: ExpansionPanelList.radio(
                    expandedHeaderPadding: EdgeInsets.zero,
                    animationDuration: const Duration(milliseconds: 500),
                    elevation: 0,
                    children: _history.map((m) {
                      final gp = Theme.of(context).extension<GamePalette>();
                      return ExpansionPanelRadio(
                        value: m.order,
                        headerBuilder: (context, isOpen) {
                          final stripeColor = m.player == 'X'
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.primary;
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  (gp?.tileOccupiedGradient.first ??
                                          Theme.of(context)
                                              .colorScheme
                                              .surfaceContainerHighest)
                                      .withOpacity(0.25),
                                  (gp?.tileOccupiedGradient.last ??
                                          Theme.of(context)
                                              .colorScheme
                                              .surfaceContainer)
                                      .withOpacity(0.15),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: stripeColor
                                    .withOpacity(isOpen ? 0.55 : 0.30),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: stripeColor
                                      .withOpacity(0.45 * (isOpen ? 1 : 0.5)),
                                  blurRadius: isOpen ? 18 : 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                // Accent stripe
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  bottom: 0,
                                  width: 5,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          stripeColor.withOpacity(0.9),
                                          stripeColor.withOpacity(0.2),
                                        ],
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(14),
                                        bottomLeft: Radius.circular(14),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: Row(
                                    children: [
                                      // Ring avatar
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: [
                                              stripeColor.withOpacity(0.85),
                                              stripeColor.withOpacity(0.35),
                                            ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  stripeColor.withOpacity(0.55),
                                              blurRadius: 14,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                          border: Border.all(
                                            color: stripeColor.withOpacity(0.7),
                                            width: 1.2,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          m.player,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                            color: m.player == 'X'
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .onErrorContainer
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Move ${m.order}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                            Text(
                                              'Cell ${m.index + 1}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall
                                                  ?.copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .outline,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      AnimatedOpacity(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        opacity: isOpen ? 0.9 : 0.4,
                                        child: Icon(
                                          isOpen
                                              ? Icons.expand_less
                                              : Icons.expand_more,
                                          size: 20,
                                          color: stripeColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        body: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Board snapshot',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w600,
                                      )),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 3,
                                runSpacing: 3,
                                children: List.generate(9, (i) {
                                  // Determine symbol at snapshot time
                                  String symbol = '';
                                  if (i == m.index) {
                                    symbol = m.player;
                                  } else {
                                    // Walk history up to this move index
                                    for (final rec in _history
                                        .where((h) => h.order <= m.order)) {
                                      if (rec.index == i) {
                                        symbol = rec.player;
                                      }
                                    }
                                  }
                                  final isJustPlayed = i == m.index;
                                  final color = symbol == 'X'
                                      ? Theme.of(context).colorScheme.error
                                      : Theme.of(context).colorScheme.primary;
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: 22,
                                    height: 22,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      gradient: isJustPlayed
                                          ? LinearGradient(
                                              colors: [
                                                color.withOpacity(0.85),
                                                color.withOpacity(0.25),
                                              ],
                                            )
                                          : LinearGradient(
                                              colors: [
                                                (gp?.tileEmptyGradient.first ??
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .surfaceContainerHigh)
                                                    .withOpacity(0.4),
                                                (gp?.tileEmptyGradient.last ??
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .surfaceContainer)
                                                    .withOpacity(0.3),
                                              ],
                                            ),
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: isJustPlayed
                                            ? color.withOpacity(0.9)
                                            : (gp?.tileBorder ??
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .outline)
                                                .withOpacity(0.35),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        if (isJustPlayed)
                                          BoxShadow(
                                            color: color.withOpacity(0.6),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                          ),
                                      ],
                                    ),
                                    child: Text(
                                      symbol,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: symbol.isEmpty
                                            ? Theme.of(context)
                                                .colorScheme
                                                .outline
                                                .withOpacity(0.4)
                                            : (symbol == 'X'
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .error
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildPlayerTurnIndicator() {
    final gp = Theme.of(context).extension<GamePalette>();
    return SlideTransition(
      position: _slideAnimation,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gp?.turnIndicatorGradient ??
                [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.secondaryContainer,
                ],
            stops: const [0.0, 0.7, 1.0],
          ),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.22),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: (gp?.glow ?? Theme.of(context).colorScheme.primary)
                  .withOpacity(0.35),
              blurRadius: 24,
              offset: const Offset(0, 8),
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 18,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _pulseAnimation,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  currentPlayer == 'X' ? Icons.close : Icons.circle_outlined,
                  key: ValueKey(currentPlayer),
                  color: currentPlayer == 'X'
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.primary,
                  size: 26,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Text(
              gameEnded
                  ? (winner.isEmpty ? "It's a Draw!" : "Player $winner Wins!")
                  : "Player $currentPlayer's Turn",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBoard() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildScoreItem(
              'X', xWins, Icons.close, Theme.of(context).colorScheme.error),
          _buildScoreItem('Draw', draws, Icons.handshake,
              Theme.of(context).colorScheme.outline),
          _buildScoreItem('O', oWins, Icons.circle_outlined,
              Theme.of(context).colorScheme.primary),
        ],
      ),
    );
  }

  Widget _buildScoreItem(String label, int score, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 2),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: Text(
            score.toString(),
            key: ValueKey('${label}_$score'),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildControlButton(
          icon: Icons.refresh,
          label: 'New Game',
          onPressed: _resetGame,
          color: Theme.of(context).colorScheme.primary,
        ),
        _buildControlButton(
          icon: Icons.undo,
          label: 'Undo',
          onPressed:
              board.any((cell) => cell.isNotEmpty) ? _undoLastMove : null,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required Color color,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed != null ? color : color.withOpacity(0.3),
          foregroundColor: onPressed != null
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: onPressed != null ? 2 : 0,
        ),
      ),
    );
  }

  Widget _buildGameBoard() {
    final gp = Theme.of(context).extension<GamePalette>();
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            (gp?.tileEmptyGradient.first ?? const Color(0xFF1E233F))
                .withOpacity(0.9),
            (gp?.tileEmptyGradient.last ?? const Color(0xFF14182C))
                .withOpacity(0.9),
            (gp?.tileOccupiedGradient.first ?? const Color(0xFF00FFC6))
                .withOpacity(0.12),
          ],
          stops: const [0.0, 0.65, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (gp?.glow ?? Theme.of(context).colorScheme.shadow)
                .withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: (gp?.glow ?? Colors.cyan).withOpacity(0.25),
            blurRadius: 35,
            spreadRadius: 4,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: (gp?.glow ?? Colors.cyan).withOpacity(0.35),
          width: 1.2,
        ),
      ),
      child: Hero(
        tag: 'game_board',
        child: Material(
          color: Colors.transparent,
          child: _buildTicTacToeBoard(),
        ),
      ),
    );
  }

  Widget _buildGameEndOverlay() {
    return AnimatedBuilder(
      animation: _celebrationAnimation,
      builder: (context, child) {
        return Container(
          color: Colors.black.withOpacity(0.5 * _celebrationAnimation.value),
          child: Center(
            child: ScaleTransition(
              scale: _celebrationAnimation,
              child: Container(
                margin: const EdgeInsets.all(32),
                padding: const EdgeInsets.all(24),
                constraints: const BoxConstraints(
                  maxWidth: 400,
                  maxHeight: 300,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color:
                        Theme.of(context).colorScheme.outline.withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Theme.of(context).colorScheme.shadow.withOpacity(0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                      blurRadius: 40,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      winner.isEmpty
                          ? Icons.handshake
                          : (winner == 'X'
                              ? Icons.close
                              : Icons.circle_outlined),
                      size: 64,
                      color: winner.isEmpty
                          ? Theme.of(context).colorScheme.outline
                          : (winner == 'X'
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      winner.isEmpty ? "It's a Draw!" : "Player $winner Wins!",
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    // Consolidated action layout: primary Rematch, secondary Reset Scores (optional)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _resetGame,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Rematch'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).maybePop();
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onTileTapped(int index) {
    try {
      if (index < 0 || index >= board.length) return;

      if (board[index].isEmpty && !gameEnded) {
        if (isHapticFeedbackEnabled) {
          HapticFeedback.lightImpact();
        }

        _pulseController.forward().then((_) {
          if (mounted) {
            _pulseController.reverse();
          }
        });

        setState(() {
          board[index] = currentPlayer;
          _recordMove(index, currentPlayer);
          _checkGameState();
          if (!gameEnded) {
            currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
          }
        });
      }
    } catch (e) {
      debugPrint('Error in _onTileTapped: $e');
    }
  }

  void _checkGameState() {
    try {
      // Check for wins
      const List<List<int>> winPatterns = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
        [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
        [0, 4, 8], [2, 4, 6], // Diagonals
      ];

      for (var pattern in winPatterns) {
        if (pattern.every((index) => index < board.length) &&
            board[pattern[0]].isNotEmpty &&
            board[pattern[0]] == board[pattern[1]] &&
            board[pattern[1]] == board[pattern[2]]) {
          setState(() {
            gameEnded = true;
            winner = board[pattern[0]];
            winningIndices
              ..clear()
              ..addAll(pattern);
            if (winner == 'X') {
              xWins++;
            } else {
              oWins++;
            }
          });

          if (mounted) {
            _celebrationController.forward();
          }

          if (isHapticFeedbackEnabled) {
            HapticFeedback.heavyImpact();
          }
          _saveSettings();
          return;
        }
      }

      // Check for draw
      if (board.every((cell) => cell.isNotEmpty)) {
        setState(() {
          gameEnded = true;
          draws++;
        });

        if (mounted) {
          _celebrationController.forward();
        }

        if (isHapticFeedbackEnabled) {
          HapticFeedback.mediumImpact();
        }
        _saveSettings();
      }

      if (gameEnded && !_snackbarShownForGame) {
        _snackbarShownForGame = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              winner.isEmpty ? "It's a draw!" : 'Player $winner wins!',
              semanticsLabel:
                  winner.isEmpty ? 'Draw game' : 'Player $winner wins the game',
            ),
            action: SnackBarAction(
              label: 'New Game',
              onPressed: _resetGame,
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        if (mounted) {
          _gameIconController.forward();
        }
      }
    } catch (e) {
      debugPrint('Error in _checkGameState: $e');
    }
  }

  void _resetGame() {
    setState(() {
      board = List.filled(9, '');
      currentPlayer = 'X';
      gameEnded = false;
      winner = '';
      winningIndices.clear();
      _history.clear();
      _snackbarShownForGame = false;
    });
    _celebrationController.reset();
    _slideController.forward();
    _gameIconController.reverse();
  }

  void _undoLastMove() {
    if (_history.isEmpty || gameEnded) return;
    final last = _history.removeLast();
    setState(() {
      // Clear board slot of last move
      if (last.index >= 0 && last.index < board.length) {
        board[last.index] = '';
      }
      // Restore turn to the player who made the undone move
      currentPlayer = last.player;
      // Clear winning state if we undid the decisive move
      if (gameEnded) {
        // Re-evaluate game state from scratch (without last move)
        gameEnded = false;
        winner = '';
        winningIndices.clear();
      }
    });
    if (isHapticFeedbackEnabled) {
      HapticFeedback.selectionClick();
    }
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'settings':
        _showSettingsDialog();
        break;
      case 'reset_scores':
        _showResetScoresDialog();
        break;
      case 'about':
        _showAboutDialog();
        break;
      case 'help':
        _showHelpStepper();
        break;
    }
  }

  void _makeMove(int index) {
    _onTileTapped(index);
  }

  // Help Stepper dialog
  void _showHelpStepper() {
    int step = 0;
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setStep) {
          return AlertDialog(
            title: const Text('How to Play'),
            content: SizedBox(
              width: 400,
              height: 400,
              child: Stepper(
                currentStep: step,
                onStepTapped: (i) => setStep(() => step = i),
                controlsBuilder: (context, details) => const SizedBox.shrink(),
                steps: const [
                  Step(
                      title: Text('Goal'),
                      content: Text(
                          'Get three of your marks (X or O) in a row to win.')),
                  Step(
                      title: Text('Turns'),
                      content:
                          Text('Players alternate turns. X always starts.')),
                  Step(
                      title: Text('Win / Draw'),
                      content: Text(
                          'If all tiles fill with no 3-in-row, it\'s a draw.')),
                  Step(
                      title: Text('Extras'),
                      content: Text(
                          'Undo last move, change theme/accent in Quick sheet.')),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Close')),
            ],
          );
        });
      },
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dark mode toggle removed (always neon dark)
            SwitchListTile(
              value: isHapticFeedbackEnabled,
              onChanged: (v) {
                setState(() => isHapticFeedbackEnabled = v);
                _saveSettings();
                if (v) HapticFeedback.lightImpact();
              },
              title: const Text('Haptic Feedback'),
              secondary: const Icon(Icons.vibration),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showResetScoresDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Scores'),
        content: const Text('Are you sure you want to reset all scores?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                xWins = 0;
                oWins = 0;
                draws = 0;
              });
              _saveSettings();
              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AboutDialog(
        applicationName: 'Tic Tac Toe',
        applicationVersion: '1.0.0',
        applicationIcon: const Icon(Icons.games),
        children: const [
          Text('A modern Tic Tac Toe game built with Flutter.'),
        ],
      ),
    );
  }

  Widget _buildTicTacToeBoard() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        final isWinningTile = winningIndices.contains(index);
        final isEmpty = board[index].isEmpty;
        final gp = Theme.of(context).extension<GamePalette>();

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: isWinningTile
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gp?.tileWinGradient ??
                        [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.primaryContainer,
                        ],
                    stops: const [0.0, 0.55, 1.0],
                  )
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isEmpty
                        ? gp?.tileEmptyGradient ??
                            [
                              Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                              Theme.of(context).colorScheme.surfaceContainer,
                            ]
                        : gp?.tileOccupiedGradient ??
                            [
                              Theme.of(context).colorScheme.primaryContainer,
                              Theme.of(context).colorScheme.secondaryContainer,
                            ],
                  ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isWinningTile
                  ? (gp?.glow ?? Theme.of(context).colorScheme.primary)
                      .withOpacity(0.5)
                  : (gp?.tileBorder ?? Theme.of(context).colorScheme.outline)
                      .withOpacity(0.5),
              width: isWinningTile ? 2 : 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: (gp?.glow ?? Theme.of(context).colorScheme.shadow)
                    .withOpacity(isWinningTile ? 0.35 : 0.12),
                blurRadius: isWinningTile ? 14 : 6,
                offset: const Offset(0, 2),
                spreadRadius: isWinningTile ? 1 : 0,
              ),
              if (isWinningTile)
                BoxShadow(
                  color: (gp?.glow ?? Theme.of(context).colorScheme.primary)
                      .withOpacity(0.6),
                  blurRadius: 28,
                  offset: const Offset(0, 6),
                  spreadRadius: 2,
                ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _makeMove(index),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => ScaleTransition(
                    scale: animation,
                    child: child,
                  ),
                  child: board[index].isEmpty
                      ? const SizedBox.shrink()
                      : Icon(
                          board[index] == 'X'
                              ? Icons.close
                              : Icons.circle_outlined,
                          key: ValueKey(board[index]),
                          size: 36,
                          color: board[index] == 'X'
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.primary,
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFab() {
    final gp = Theme.of(context).extension<GamePalette>();
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: GestureDetector(
        onTap: _showQuickActionsSheet,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                (gp?.tileWinGradient.first ?? primary).withOpacity(0.95),
                (gp?.tileWinGradient.last ?? secondary).withOpacity(0.75),
                (gp?.tileOccupiedGradient.first ?? primary).withOpacity(0.55),
              ],
              stops: const [0.0, 0.55, 1.0],
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: (gp?.glow ?? primary).withOpacity(0.7),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: (gp?.glow ?? primary).withOpacity(0.65),
                blurRadius: 28,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.tune,
                  size: 20, color: Theme.of(context).colorScheme.onPrimary),
              const SizedBox(width: 10),
              Text(
                'Quick',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuickActionsSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              (Theme.of(context)
                          .extension<GamePalette>()
                          ?.tileOccupiedGradient
                          .first ??
                      Theme.of(context).colorScheme.surfaceContainerHigh)
                  .withOpacity(0.55),
              (Theme.of(context)
                          .extension<GamePalette>()
                          ?.tileEmptyGradient
                          .last ??
                      Theme.of(context).colorScheme.surfaceContainer)
                  .withOpacity(0.85),
              (Theme.of(context)
                          .extension<GamePalette>()
                          ?.tileWinGradient
                          .last ??
                      Theme.of(context).colorScheme.surface)
                  .withOpacity(0.9),
            ],
            stops: const [0.0, 0.55, 1.0],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(34)),
          border: Border.all(
            color: (Theme.of(context).extension<GamePalette>()?.glow ??
                    Theme.of(context).colorScheme.primary)
                .withOpacity(0.35),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: (Theme.of(context).extension<GamePalette>()?.glow ??
                      Theme.of(context).colorScheme.primary)
                  .withOpacity(0.4),
              blurRadius: 34,
              offset: const Offset(0, -6),
              spreadRadius: 4,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 50,
              offset: const Offset(0, -12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header capsule
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    (Theme.of(context)
                                .extension<GamePalette>()
                                ?.tileWinGradient
                                .first ??
                            Theme.of(context).colorScheme.primary)
                        .withOpacity(0.9),
                    (Theme.of(context)
                                .extension<GamePalette>()
                                ?.tileWinGradient
                                .last ??
                            Theme.of(context).colorScheme.secondary)
                        .withOpacity(0.65),
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: (Theme.of(context).extension<GamePalette>()?.glow ??
                            Theme.of(context).colorScheme.primary)
                        .withOpacity(0.6),
                    blurRadius: 18,
                    spreadRadius: 1,
                  ),
                ],
                border: Border.all(
                  color: (Theme.of(context).extension<GamePalette>()?.glow ??
                          Theme.of(context).colorScheme.primary)
                      .withOpacity(0.6),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.tune,
                      size: 18,
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                  const SizedBox(width: 8),
                  Text(
                    'Quick Settings',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            // Only haptic feedback switch remains
            _NeonSwitchTile(
              value: isHapticFeedbackEnabled,
              title: 'Haptic Feedback',
              icon: Icons.vibration,
              onChanged: (v) {
                setState(() => isHapticFeedbackEnabled = v);
                _saveSettings();
                if (v) HapticFeedback.lightImpact();
              },
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

// _AccentDot removed (no longer needed with fixed neon theme)

class _MoveRecord {
  final String player;
  final int index;
  final int order;

  _MoveRecord({
    required this.player,
    required this.index,
    required this.order,
  });
}

/// Neon styled switch tile used in the Quick Settings sheet.
class _NeonSwitchTile extends StatelessWidget {
  final bool value;
  final String title;
  final IconData icon;
  final ValueChanged<bool> onChanged;

  const _NeonSwitchTile({
    Key? key,
    required this.value,
    required this.title,
    required this.icon,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gp = Theme.of(context).extension<GamePalette>();
    final accent = Theme.of(context).colorScheme.primary;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              (gp?.tileEmptyGradient.first ??
                      Theme.of(context).colorScheme.surfaceContainerHigh)
                  .withOpacity(0.65),
              (gp?.tileEmptyGradient.last ??
                      Theme.of(context).colorScheme.surfaceContainer)
                  .withOpacity(0.55),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: (gp?.glow ?? accent).withOpacity(value ? 0.55 : 0.28),
            width: 1,
          ),
          boxShadow: [
            if (value)
              BoxShadow(
                color: (gp?.glow ?? accent).withOpacity(0.55),
                blurRadius: 24,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    accent.withOpacity(0.9),
                    accent.withOpacity(0.35),
                  ],
                ),
                border: Border.all(
                  color: accent.withOpacity(0.75),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accent.withOpacity(0.55),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(icon,
                  size: 20,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
              ),
            ),
            Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeColor: Theme.of(context).colorScheme.onPrimary,
              activeTrackColor: accent.withOpacity(0.65),
              inactiveTrackColor:
                  Theme.of(context).colorScheme.outline.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}

/// Painter that adds soft radial neon glows & subtle vignette behind content.
class _NeonBackdropPainter extends CustomPainter {
  final GamePalette? palette;
  _NeonBackdropPainter({required this.palette});

  @override
  void paint(Canvas canvas, Size size) {
    final gp = palette;
    if (gp == null) return;

    // Helper to draw radial glow
    void glow(Offset center, double radius, List<Color> colors,
        {double sigma = 60}) {
      final rect = Rect.fromCircle(center: center, radius: radius);
      final paint = Paint()
        ..shader = RadialGradient(
          colors: colors,
          stops: const [0.0, 0.4, 1.0],
        ).createShader(rect)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, sigma);
      canvas.drawCircle(center, radius, paint);
    }

    // Base layered glows
    glow(size.center(Offset.zero) + const Offset(0, -40),
        size.shortestSide * 0.55, [
      gp.tileOccupiedGradient.first.withOpacity(0.35),
      gp.glow.withOpacity(0.08),
      Colors.transparent
    ]);
    glow(Offset(size.width * 0.18, size.height * 0.68),
        size.shortestSide * 0.35, [
      gp.tileWinGradient.first.withOpacity(0.38),
      gp.glow.withOpacity(0.05),
      Colors.transparent
    ]);
    glow(Offset(size.width * 0.82, size.height * 0.60),
        size.shortestSide * 0.32, [
      gp.tileWinGradient.last.withOpacity(0.32),
      gp.glow.withOpacity(0.04),
      Colors.transparent
    ]);

    // Subtle vignette overlay
    final vignettePaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.95,
        colors: [Colors.transparent, Colors.black.withOpacity(0.40)],
        stops: const [0.55, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, vignettePaint);
  }

  @override
  bool shouldRepaint(covariant _NeonBackdropPainter oldDelegate) {
    return oldDelegate.palette != palette;
  }
}
