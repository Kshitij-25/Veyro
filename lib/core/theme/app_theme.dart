import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final v = brightness == Brightness.dark
        ? VeyroColors.dark
        : VeyroColors.light;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: VeyroColors.accent,
          brightness: brightness,
        ).copyWith(
          primary: v.acc,
          onPrimary: VeyroColors.onAccent,
          surface: v.bg,
          onSurface: v.ink,
          surfaceContainerHighest: v.card,
          outline: v.mute,
          outlineVariant: v.line,
          error: VeyroColors.danger,
        );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: v.bg,
      extensions: [v],
      textTheme: ThemeData(brightness: brightness).textTheme.apply(
        fontFamily: GoogleFonts.instrumentSans().fontFamily,
        bodyColor: v.ink,
        displayColor: v.ink,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: v.bg,
        foregroundColor: v.ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: VeyroText.display(34, color: v.ink),
      ),
      cardTheme: CardThemeData(
        color: v.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      dividerTheme: DividerThemeData(color: v.line, space: 1, thickness: 1),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: v.acc,
          foregroundColor: VeyroColors.onAccent,
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: VeyroText.body(16, weight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: v.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
