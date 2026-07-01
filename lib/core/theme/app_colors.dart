import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Ana renkler
  static const Color defaultPrimary = Color(0xFFB3262E);
  static Color _primary = defaultPrimary;

  static Color get primary => _primary;

  static Color get primaryLight {
    final hsl = HSLColor.fromColor(_primary);
    return hsl
        .withSaturation((hsl.saturation * 0.45).clamp(0.08, 0.32))
        .withLightness(0.94)
        .toColor();
  }

  static Color get primaryGlow => _primary.withValues(alpha: 0.15);
  static Color get primaryBorder => _primary.withValues(alpha: 0.05);

  static void updatePrimary(Color color) {
    _primary = Color(color.toARGB32()).withValues(alpha: 1);
  }

  static const Color background = Color(0xFFF7F5F2); // Ana arka plan
  static const Color cardBackground = Color(0xFFFFFFFF); // Kart arka planı

  // Metin renkleri
  static const Color textPrimary = Color(0xFF181818); // Ana yazı rengi
  static const Color textSecondary = Color(0xFF6F6F6F); // İkincil yazı rengi

  // Yüzey ve yardımcı renkler
  static const Color border = Color(0xFFE8E5E1); // Border rengi
  static const Color success = Color(0xFF2F7D52); // Başarılı işlem rengi

  static const Color grey = Color(0xFF9E9E9E);
  static const Color darkGrey = Color(0xFF424242);

  // Premium Vurgular
  static const Color champagne = Color(0xFFD6C2A6); // Şampanya / sıcak bej
  static const Color champagneLight = Color(
    0xFFF9F6F0,
  ); // Çok hafif şampanya yüzey

  // Gölgeler ve glow (parlama) efektleri
  static const Color shadowTint = Color(0x0D5A3B3B); // %5 opacity sıcak gölge
  static const Color successGlow = Color(0x262F7D52); // %15 opacity success
}
