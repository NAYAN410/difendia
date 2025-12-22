import 'package:flutter/material.dart';

/// App wide color palette.
/// Sirf yahi colors use karoge taaki UI consistent rahe.
class AppColors {
  AppColors._(); // private constructor

  // Brand / primary colors
  static const Color primary = Color(0xFF1E88E5); // blue tone
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color accent = Color(0xFFFFC107); // amber for highlights

  // Backgrounds
  static const Color background = Color(0xFF0F172A); // dark slate
  static const Color cardBackground = Color(0xFF111827);
  static const Color inputBackground = Color(0xFF1F2933);

  // Text colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF9CA3AF); // grey
  static const Color textDanger = Color(0xFFEF4444);

  // Borders / dividers
  static const Color border = Color(0xFF374151);
  static const Color divider = Color(0xFF1F2937);

  // Status colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFFBBF24);
  static const Color error = Color(0xFFEF4444);

  // Misc
  static const Color icon = Color(0xFF9CA3AF);
  static const Color disabled = Color(0xFF4B5563);
}
