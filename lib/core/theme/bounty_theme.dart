import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bounty_colors.dart';

/// [BountyTheme] — Applies the full Ghost App Design System to MaterialApp.
///
/// Usage:
///   MaterialApp.router(
///     theme: BountyTheme.darkTheme,
///   )
abstract final class BountyTheme {
  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: BountyColors.backgroundDeep,

      // ── Color Scheme ──────────────────────────────────────────────────────
      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        surface: BountyColors.backgroundCard,
        primary: BountyColors.neonCyan,
        onPrimary: BountyColors.backgroundDeep,
        secondary: BountyColors.neonGreen,
        onSecondary: BountyColors.backgroundDeep,
        error: BountyColors.neonRed,
        onError: BountyColors.backgroundDeep,
        onSurface: BountyColors.textPrimary,
        outline: BountyColors.divider,
        surfaceContainerHighest: BountyColors.backgroundLayer,
      ),

      // ── Typography — Poppins ──────────────────────────────────────────────
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: BountyColors.textPrimary,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: BountyColors.textPrimary,
        ),
        headlineLarge: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: BountyColors.textPrimary,
          letterSpacing: 0.5,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: BountyColors.textPrimary,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: BountyColors.textPrimary,
          letterSpacing: 0.2,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: BountyColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          color: BountyColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          color: BountyColors.textSecondary,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          color: BountyColors.textSecondary,
        ),
        labelLarge: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: BountyColors.backgroundDeep,
          letterSpacing: 0.5,
        ),
        labelSmall: GoogleFonts.poppins(
          fontSize: 10,
          color: BountyColors.textDisabled,
          letterSpacing: 1.2,
        ),
      ),

      // ── AppBar ────────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: BountyColors.backgroundDeep,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          color: BountyColors.neonCyan,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.5,
        ),
        iconTheme: const IconThemeData(color: BountyColors.neonCyan),
        actionsIconTheme: const IconThemeData(color: BountyColors.neonCyan),
      ),

      // ── Cards ─────────────────────────────────────────────────────────────
      cardTheme: const CardThemeData(
        color: BountyColors.backgroundCard,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: BountyColors.divider, width: 0.5),
        ),
      ),

      // ── Dividers ──────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: BountyColors.divider,
        thickness: 0.5,
        space: 0,
      ),

      // ── FAB ───────────────────────────────────────────────────────────────
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: BountyColors.neonCyan,
        foregroundColor: BountyColors.backgroundDeep,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: CircleBorder(),
      ),

      // ── Bottom Navigation Bar ─────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: BountyColors.backgroundCard,
        surfaceTintColor: Colors.transparent,
        indicatorColor: BountyColors.glowCyan,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: BountyColors.neonCyan, size: 24);
          }
          return const IconThemeData(color: BountyColors.divider, size: 22);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: BountyColors.neonCyan,
            );
          }
          return GoogleFonts.poppins(
            fontSize: 11,
            color: BountyColors.textDisabled,
          );
        }),
        elevation: 0,
        height: 64,
      ),

      // ── Input Fields ──────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: BountyColors.backgroundLayer,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: BountyColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: BountyColors.divider, width: 0.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: BountyColors.neonCyan, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: BountyColors.neonRed, width: 1.5),
        ),
        labelStyle: GoogleFonts.poppins(color: BountyColors.textSecondary, fontSize: 14),
        hintStyle: GoogleFonts.poppins(color: BountyColors.textDisabled, fontSize: 14),
        errorStyle: GoogleFonts.poppins(color: BountyColors.neonRed, fontSize: 12),
        prefixIconColor: BountyColors.textSecondary,
        suffixIconColor: BountyColors.textSecondary,
      ),

      // ── Elevated Buttons ──────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: BountyColors.neonCyan,
          foregroundColor: BountyColors.backgroundDeep,
          disabledBackgroundColor: BountyColors.divider,
          disabledForegroundColor: BountyColors.textDisabled,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),

      // ── Text Buttons ──────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: BountyColors.neonCyan,
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14),
        ),
      ),

      // ── Outlined Buttons ──────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: BountyColors.neonCyan,
          side: const BorderSide(color: BountyColors.neonCyan, width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),

      // ── Bottom Sheet ──────────────────────────────────────────────────────
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: BountyColors.backgroundCard,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: BountyColors.backgroundCard,
        elevation: 0,
        modalElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          side: BorderSide(color: BountyColors.divider, width: 0.5),
        ),
      ),

      // ── Dialog ────────────────────────────────────────────────────────────
      dialogTheme: const DialogThemeData(
        backgroundColor: BountyColors.backgroundLayer,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: BountyColors.divider, width: 0.5),
        ),
        titleTextStyle: TextStyle(
          color: BountyColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),

      // ── Chip ──────────────────────────────────────────────────────────────
      chipTheme: const ChipThemeData(
        backgroundColor: BountyColors.backgroundLayer,
        selectedColor: BountyColors.glowCyan,
        disabledColor: BountyColors.backgroundLayer,
        labelStyle: TextStyle(color: BountyColors.textSecondary, fontSize: 12),
        side: BorderSide(color: BountyColors.divider, width: 0.5),
        shape: StadiumBorder(),
        elevation: 0,
        pressElevation: 0,
      ),

      // ── SnackBar ──────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: BountyColors.backgroundLayer,
        contentTextStyle: GoogleFonts.poppins(color: BountyColors.textPrimary),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          side: BorderSide(color: BountyColors.divider, width: 0.5),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // ── Progress Indicator ────────────────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: BountyColors.neonCyan,
        circularTrackColor: BountyColors.backgroundLayer,
      ),

      // ── Switch ────────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? BountyColors.neonCyan
                : BountyColors.divider),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? BountyColors.glowCyan
                : BountyColors.backgroundLayer),
      ),
    );
  }
}
