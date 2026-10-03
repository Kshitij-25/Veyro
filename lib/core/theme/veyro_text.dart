import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Veyro type styles: Barlow Condensed for numbers and titles, Instrument
/// Sans for everything else.
abstract final class VeyroText {
  /// Big condensed numerals/titles. Pass [size]; tight line height by default.
  static TextStyle display(double size, {Color? color, double height = 1}) =>
      GoogleFonts.barlowCondensed(
        fontSize: size,
        fontWeight: FontWeight.w800,
        height: height,
        color: color,
      );

  static TextStyle body(
    double size, {
    FontWeight weight = FontWeight.w500,
    Color? color,
    double? height,
    double? letterSpacing,
  }) => GoogleFonts.instrumentSans(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );

  /// Small uppercase section label.
  static TextStyle label({Color? color}) =>
      body(11, weight: FontWeight.w600, color: color, letterSpacing: 1);
}
