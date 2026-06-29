import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Ana renkler
  static const Color primary = Color(0xFFB3262E); // Ana vurgu kırmızısı
  static const Color background = Color(0xFFF7F5F2); // Ana arka plan
  static const Color cardBackground = Color(0xFFFFFFFF); // Kart arka planı
  
  // Metin renkleri
  static const Color textPrimary = Color(0xFF181818); // Ana yazı rengi
  static const Color textSecondary = Color(0xFF6F6F6F); // İkincil yazı rengi
  
  // Yüzey ve yardımcı renkler
  static const Color primaryLight = Color(0xFFF7E9E9); // Açık kırmızı yüzey
  static const Color border = Color(0xFFE8E5E1); // Border rengi
  static const Color success = Color(0xFF2F7D52); // Başarılı işlem rengi

  static const Color grey = Color(0xFF9E9E9E);
  static const Color darkGrey = Color(0xFF424242);
  
  // Premium Vurgular
  static const Color champagne = Color(0xFFD6C2A6); // Şampanya / sıcak bej
  static const Color champagneLight = Color(0xFFF9F6F0); // Çok hafif şampanya yüzey

  // Gölgeler ve glow (parlama) efektleri
  static const Color primaryGlow = Color(0x26B3262E); // %15 opacity primary
  static const Color primaryBorder = Color(0x0DB3262E); // %5 opacity primary
  static const Color shadowTint = Color(0x0D5A3B3B); // %5 opacity sıcak gölge
  static const Color successGlow = Color(0x262F7D52); // %15 opacity success
}
