import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF0288D1);
  static const Color primaryLight = Color(0xFF4FC3F7);
  static const Color primaryDark = Color(0xFF01579B);
  static const Color accent = Color(0xFF00BCD4);
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color backgroundLight = Color(0xFFF5F9FF);
  static const Color backgroundDark = Color(0xFF0A1929);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1A2332);

  static const LinearGradient waterGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[primaryLight, primary],
  );
}
