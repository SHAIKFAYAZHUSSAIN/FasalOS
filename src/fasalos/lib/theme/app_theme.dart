import 'package:flutter/material.dart';

/// FasalOS Design Language
/// Restrained Agricultural Greens, Warm Off-White, Natural Typography,
/// Purposeful Rounded Corners, Subtle Shadows, Large Readable Numbers.
class FasalColors {
  // Backgrounds & Surfaces
  static const Color background = Color(0xFFF7F8F4); // Warm off-white
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF1F3ED);
  static const Color surfaceElevated = Color(0xFFFFFFFF);

  // Agricultural Palette (Natural & Restrained)
  static const Color primaryGreen = Color(0xFF1B4D24); // Deep farm green
  static const Color primaryGreenLight = Color(0xFF2E6B39);
  static const Color primaryGreenSubtle = Color(0xFFE8F3EA);
  static const Color primaryGreenDark = Color(0xFF13381A);

  // Harvest Amber / Turmeric
  static const Color harvestAmber = Color(0xFFD97706);
  static const Color harvestAmberLight = Color(0xFFFEF3C7);
  static const Color harvestAmberDark = Color(0xFF92400E);

  // Cold Chain Frost Blue
  static const Color coldBlue = Color(0xFF0284C7);
  static const Color coldBlueLight = Color(0xFFE0F2FE);
  static const Color coldBlueDark = Color(0xFF0369A1);

  // Earth / Soil
  static const Color soilBrown = Color(0xFF6D4C41);
  static const Color soilBrownLight = Color(0xFFEFEBE9);

  // Status & Feedback
  static const Color success = Color(0xFF2E7D32);
  static const Color successSubtle = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFED6C02);
  static const Color warningSubtle = Color(0xFFFFF3E0);
  static const Color error = Color(0xFFD32F2F);
  static const Color errorSubtle = Color(0xFFFFEBEE);

  // Neutral Text & Borders
  static const Color textPrimary = Color(0xFF1A261D);
  static const Color textSecondary = Color(0xFF4A5A4D);
  static const Color textMuted = Color(0xFF758578);
  static const Color borderSubtle = Color(0xFFDFE4DC);
  static const Color borderStrong = Color(0xFFBDC7B9);
}

class FasalSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;

  static const double touchTargetMin = 48.0;
}

class FasalTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: FasalColors.background,
      fontFamily: 'Roboto',
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: FasalColors.primaryGreen,
        onPrimary: Colors.white,
        primaryContainer: FasalColors.primaryGreenSubtle,
        onPrimaryContainer: FasalColors.primaryGreenDark,
        secondary: FasalColors.harvestAmber,
        onSecondary: Colors.white,
        secondaryContainer: FasalColors.harvestAmberLight,
        onSecondaryContainer: FasalColors.harvestAmberDark,
        tertiary: FasalColors.coldBlue,
        onTertiary: Colors.white,
        tertiaryContainer: FasalColors.coldBlueLight,
        onTertiaryContainer: FasalColors.coldBlueDark,
        error: FasalColors.error,
        onError: Colors.white,
        errorContainer: FasalColors.errorSubtle,
        onErrorContainer: FasalColors.error,
        surface: FasalColors.surface,
        onSurface: FasalColors.textPrimary,
        outline: FasalColors.borderSubtle,
        outlineVariant: FasalColors.borderStrong,
      ),
      cardTheme: CardThemeData(
        color: FasalColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: FasalColors.borderSubtle, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: FasalColors.background,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        foregroundColor: FasalColors.textPrimary,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: FasalColors.textPrimary,
          letterSpacing: -0.2,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: FasalColors.borderSubtle,
        thickness: 1,
        space: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: FasalColors.primaryGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size(FasalSpacing.touchTargetMin, FasalSpacing.touchTargetMin),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: FasalColors.primaryGreen,
          minimumSize: const Size(FasalSpacing.touchTargetMin, FasalSpacing.touchTargetMin),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          side: const BorderSide(color: FasalColors.primaryGreen, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: FasalColors.primaryGreen,
          minimumSize: const Size(FasalSpacing.touchTargetMin, FasalSpacing.touchTargetMin),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: FasalColors.borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: FasalColors.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: FasalColors.primaryGreen, width: 1.8),
        ),
        labelStyle: const TextStyle(color: FasalColors.textSecondary, fontSize: 14),
        hintStyle: const TextStyle(color: FasalColors.textMuted, fontSize: 14),
      ),
    );
  }
}
