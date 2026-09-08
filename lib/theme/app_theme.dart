import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central color + typography definitions for Study Clips.
/// UI background is kept white/near-white throughout, with a deep-ink
/// header/nav and a marigold accent for CTAs and highlights.
class AppColors {
  static const ink = Color(0xFF14213D);
  static const inkSoft = Color(0xFF22305A);
  static const marigold = Color(0xFFF2A20C);
  static const marigoldDeep = Color(0xFFC97F00);
  static const background = Color(0xFFFFFFFF);
  static const surface = Color(0xFFFFFFFF);
  static const line = Color(0xFFE7E2D6);
  static const slate = Color(0xFF6B7280);
  static const slateLight = Color(0xFF9CA3AF);
  static const coral = Color(0xFFE5484D);
  static const green = Color(0xFF2E8B57);
  static const blueTick = Color(0xFF3897F0);
}

class AppTheme {
  /// Text theme mixes Inter (Latin/UI chrome) with Noto Sans Gujarati
  /// (Gujarati script) so both languages render cleanly side by side.
  static TextTheme _textTheme(TextTheme base) {
    return GoogleFonts.interTextTheme(base).copyWith(
      bodyLarge: GoogleFonts.notoSansGujarati(
        textStyle: GoogleFonts.inter(fontSize: 15, height: 1.5, color: const Color(0xFF2A2A2A)),
      ),
      bodyMedium: GoogleFonts.notoSansGujarati(
        textStyle: GoogleFonts.inter(fontSize: 14, height: 1.5, color: const Color(0xFF2A2A2A)),
      ),
    );
  }

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.ink,
        secondary: AppColors.marigold,
        surface: AppColors.surface,
      ),
      textTheme: _textTheme(base.textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.ink,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 19,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: -0.3,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.ink,
        unselectedItemColor: AppColors.slateLight,
        selectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.line),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.line, thickness: 1),
    );
  }
}
