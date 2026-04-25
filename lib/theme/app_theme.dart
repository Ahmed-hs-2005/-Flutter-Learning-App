import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  AppTheme._();

  // ── Core Palette — "Midnight Pro" ─────────────────────────────────────────
  static const Color background    = Color(0xFF0D1117);  // deep GitHub-dark black
  static const Color surface       = Color(0xFF161B22);  // card background
  static const Color surfaceHigh   = Color(0xFF1C2333);  // elevated surfaces
  static const Color surfaceBorder = Color(0xFF21262D);  // subtle card borders
  static const Color border        = Color(0xFF30363D);  // standard borders
  static const Color textPrimary   = Color(0xFFF0F6FC);  // crisp white
  static const Color textSecondary = Color(0xFF8B949E);  // soft grey
  static const Color textMuted     = Color(0xFF484F58);  // very muted

  // ── Accent Colors ─────────────────────────────────────────────────────────
  static const Color accentAmber  = Color(0xFFF7BE38);
  static const Color accentTeal   = Color(0xFF2DD4BF);
  static const Color accentCoral  = Color(0xFFFF6B6B);
  static const Color accentBlue   = Color(0xFF79C0FF);
  static const Color accentViolet = Color(0xFFD2A8FF);

  // ── Topic Color Pairs ─────────────────────────────────────────────────────
  static const List<List<Color>> topicColors = [
    [Color(0xFFF7BE38), Color(0xFFFFD97D)],   // Widgets    — warm gold
    [Color(0xFF2DD4BF), Color(0xFF5EEAD4)],   // Layouts    — teal
    [Color(0xFF79C0FF), Color(0xFFB3D7FF)],   // Navigation — sky blue
    [Color(0xFFD2A8FF), Color(0xFFE5C8FF)],   // State Mgmt — lavender
    [Color(0xFFFF6B6B), Color(0xFFFF9A9A)],   // Animations — coral
  ];

  // ── Radius & Spacing ──────────────────────────────────────────────────────
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 22.0;
  static const double paddingSm = 12.0;
  static const double paddingMd = 16.0;
  static const double paddingLg = 22.0;

  // ── Shadows ───────────────────────────────────────────────────────────────
  static List<BoxShadow> cardShadow(Color accent) => [
    BoxShadow(color: Colors.black.withOpacity(0.40), blurRadius: 24, offset: const Offset(0, 8)),
    BoxShadow(color: accent.withOpacity(0.07),       blurRadius: 20, offset: const Offset(0, 4)),
  ];

  static List<BoxShadow> get subtleShadow => [
    BoxShadow(color: Colors.black.withOpacity(0.30), blurRadius: 12, offset: const Offset(0, 4)),
  ];

  static List<BoxShadow> glowShadow(Color color) => [
    BoxShadow(color: color.withOpacity(0.40), blurRadius: 16, offset: const Offset(0, 4)),
  ];

  static List<BoxShadow> strongGlow(Color color) => [
    BoxShadow(color: color.withOpacity(0.28), blurRadius: 28, spreadRadius: 2),
  ];

  // ── Typography ────────────────────────────────────────────────────────────
  static const TextStyle headingLg = TextStyle(color: textPrimary,   fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.3, height: 1.2);
  static const TextStyle headingMd = TextStyle(color: textPrimary,   fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: -0.2);
  static const TextStyle headingSm = TextStyle(color: textPrimary,   fontSize: 13.5, fontWeight: FontWeight.w600, letterSpacing: -0.1);
  static const TextStyle body      = TextStyle(color: textSecondary, fontSize: 13.5, height: 1.7, letterSpacing: 0.1);
  static const TextStyle caption   = TextStyle(color: textMuted,     fontSize: 11,   fontWeight: FontWeight.w500, letterSpacing: 0.3);
  static const TextStyle labelBold = TextStyle(color: textPrimary,   fontSize: 10,   fontWeight: FontWeight.bold, letterSpacing: 0.6);

  // ── Decorations ───────────────────────────────────────────────────────────
  static BoxDecoration cardDecoration({Color? accent, bool elevated = false}) => BoxDecoration(
    color: elevated ? surfaceHigh : surface,
    borderRadius: BorderRadius.circular(radiusLg),
    border: Border.all(color: accent != null ? accent.withOpacity(0.18) : surfaceBorder, width: 1),
    boxShadow: accent != null ? cardShadow(accent) : subtleShadow,
  );

  static BoxDecoration iconBadge(Color primary, Color secondary) => BoxDecoration(
    gradient: LinearGradient(colors: [primary, secondary], begin: Alignment.topLeft, end: Alignment.bottomRight),
    borderRadius: BorderRadius.circular(radiusMd),
    boxShadow: glowShadow(primary),
  );

  static BoxDecoration pillBadge(Color color) => BoxDecoration(
    color: color.withOpacity(0.12),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: color.withOpacity(0.28)),
  );

  static BoxDecoration tintedSection(Color accent) => BoxDecoration(
    color: accent.withOpacity(0.05),
    borderRadius: BorderRadius.circular(radiusMd),
    border: Border.all(color: accent.withOpacity(0.15)),
  );

  // ── Flutter ThemeData ─────────────────────────────────────────────────────
  static ThemeData get themeData => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      primary: accentAmber,
      secondary: accentTeal,
      surface: surface,
      onSurface: textPrimary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceHigh,
      foregroundColor: textPrimary,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    ),
  );

  // ── Helpers ───────────────────────────────────────────────────────────────
  static Color topicPrimary(int i)   => topicColors[i % topicColors.length][0];
  static Color topicSecondary(int i) => topicColors[i % topicColors.length][1];
}