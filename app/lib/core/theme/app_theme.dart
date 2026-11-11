import 'package:flutter/material.dart';

/// Mazdoor Sathi v2 theme — Deep Navy Blue primary, Construction Orange
/// secondary, Material Design 3, light + dark.
class AppTheme {
  static const Color navy = Color(0xFF0F2A4A);
  static const Color navyLight = Color(0xFF1D4E79);
  static const Color orange = Color(0xFFF97316);
  static const Color orangeDark = Color(0xFFEA580C);
  static const Color bg = Color(0xFFF4F5F7);
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFDC2626);

  static const Color darkBg = Color(0xFF0B1522);
  static const Color darkCard = Color(0xFF16263C);

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness b) {
    final dark = b == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: navy,
      primary: dark ? const Color(0xFF7FB2E5) : navy,
      secondary: orange,
      tertiary: success,
      brightness: b,
      surface: dark ? darkCard : Colors.white,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: dark ? darkBg : bg,
      cardTheme: CardThemeData(
        elevation: 0.5,
        color: dark ? darkCard : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: dark ? Colors.white12 : const Color(0xFFE5E7EB),
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark ? darkCard : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: orange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: navy,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: dark ? darkBg : navy,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: orange.withValues(alpha: 0.2),
      ),
    );
  }
}
