import 'package:flutter/material.dart';

/// Veyro design tokens, exposed as a theme extension.
@immutable
class VeyroColors extends ThemeExtension<VeyroColors> {
  const VeyroColors({
    required this.bg,
    required this.card,
    required this.ink,
    required this.mute,
    required this.line,
    required this.acc,
  });

  static const accent = Color(0xFFFF5A2B);

  /// Text/icon colour on top of the accent.
  static const onAccent = Color(0xFF160D08);
  static const danger = Color(0xFFE5484D);
  static const success = Color(0xFF2FB26B);

  static const light = VeyroColors(
    bg: Color(0xFFF4F1EC),
    card: Color(0xFFFFFFFF),
    ink: Color(0xFF171513),
    mute: Color(0xFF756F69),
    line: Color(0x14000000),
    acc: accent,
  );

  static const dark = VeyroColors(
    bg: Color(0xFF0E0D0C),
    card: Color(0xFF1C1A18),
    ink: Color(0xFFF5F3F0),
    mute: Color(0xFF9A948F),
    line: Color(0x17FFFFFF),
    acc: accent,
  );

  final Color bg;
  final Color card;
  final Color ink;
  final Color mute;
  final Color line;
  final Color acc;

  @override
  VeyroColors copyWith({
    Color? bg,
    Color? card,
    Color? ink,
    Color? mute,
    Color? line,
    Color? acc,
  }) => VeyroColors(
    bg: bg ?? this.bg,
    card: card ?? this.card,
    ink: ink ?? this.ink,
    mute: mute ?? this.mute,
    line: line ?? this.line,
    acc: acc ?? this.acc,
  );

  @override
  VeyroColors lerp(VeyroColors? other, double t) {
    if (other == null) return this;
    return VeyroColors(
      bg: Color.lerp(bg, other.bg, t)!,
      card: Color.lerp(card, other.card, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      mute: Color.lerp(mute, other.mute, t)!,
      line: Color.lerp(line, other.line, t)!,
      acc: Color.lerp(acc, other.acc, t)!,
    );
  }
}

extension VeyroColorsContext on BuildContext {
  VeyroColors get veyro => Theme.of(this).extension<VeyroColors>()!;
}
