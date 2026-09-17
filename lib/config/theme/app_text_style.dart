import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class AppTextStyle {
  AppTextStyle._();

  static TextStyle alexandria({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
    FontStyle fontStyle = FontStyle.normal,
  }) {
    return GoogleFonts.alexandria(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
      fontStyle: fontStyle,
    );
  }


  static TextStyle regular({
    required double fontSize,
    Color? color,
    double? height,
    double? letterSpacing,
  }) =>
      alexandria(
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );

  static TextStyle medium({
    required double fontSize,
    Color? color,
    double? height,
    double? letterSpacing,
  }) =>
      alexandria(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );

  static TextStyle semiBold({
    required double fontSize,
    Color? color,
    double? height,
    double? letterSpacing,
  }) =>
      alexandria(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );

  static TextStyle bold({
    required double fontSize,
    Color? color,
    double? height,
    double? letterSpacing,
  }) =>
      alexandria(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );
}