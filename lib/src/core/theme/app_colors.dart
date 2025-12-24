import 'package:flutter/material.dart';

class AppColors {
  // Primary (Baby Blue Eyes)
  static const Color primary = Color(
    0xFFA2D2FF,
  ); // User Requested Specific Pastel
  static const Color primaryLight = Color(0xFFE1F0FF); // Lighter variation
  static const Color primaryDark = Color(0xFF72A8DE); // Darker variation

  // Secondary
  static const Color secondary = Color(0xFFD6EAF8); // Pale Blue Surface
  static const Color accent = Color(0xFFAED6F1); // Soft Blue Accent

  // Neutral/Background
  static const Color background = Color(0xFFF4F9FF); // Very Light Alice Blue
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFE57373); // Softer Red

  // Tone Colors
  static const Color toneFocused = Color(0xFF5C6BC0); // Indigo
  static const Color toneCalm = Color(0xFF26A69A); // Teal
  static const Color toneProductive = Color(0xFFEF5350); // Red
  static const Color toneCreative = Color(0xFFF06292); // Sweet Pink
  static const Color toneRelaxed = Color(0xFF95D5B2); // Soft Sage Green

  // Helper to get color from Tone string
  static Color getColorForTone(String tone) {
    switch (tone) {
      case 'Focused':
        return toneFocused;
      case 'Calm':
        return toneCalm;
      case 'Productive':
        return toneProductive;
      case 'Creative':
        return toneCreative;
      case 'Relaxed':
        return toneRelaxed;
      default:
        return primary; // Default Peaceful Blue
    }
  }

  // Text
  static const Color textPrimary = Color(0xFF2C3E50); // Dark Blue Grey
  static const Color textSecondary = Color(0xFF546E7A); // Slate Grey
  static const Color textDisabled = Color(0xFFB0BEC5);
}
