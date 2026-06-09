import 'package:flutter/material.dart';

// Tema visual centralizado da aplicação (estilo claro e profissional).
//
// Concentra cores e estilos para garantir consistência visual entre todas as
// telas (header navy, fundo claro, cards brancos arredondados).
class AppTheme {
  AppTheme._();

  // Paleta base.
  static const Color navy = Color(0xFF0D2A4A);
  static const Color navyDark = Color(0xFF0A2138);
  static const Color background = Color(0xFFEFF1F5);
  static const Color card = Colors.white;
  static const Color textPrimary = Color(0xFF1B2430);
  static const Color textSecondary = Color(0xFF6B7280);

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: navy,
      primary: navy,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: navy,
        indicatorColor: Colors.white.withValues(alpha: 0.16),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => const IconThemeData(color: Colors.white),
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: TextStyle(color: textPrimary),
      ),
    );
  }
}
