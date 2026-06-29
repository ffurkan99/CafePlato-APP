import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Ürün kategorisine göre standart ikonlar döndürür.
/// Tüm ikonlar aynı Rounded stil ailesinden seçilmiştir.
class ProductIconHelper {
  ProductIconHelper._();

  static IconData iconForCategory(String category) {
    switch (category) {
      case 'Soğuk İçecekler':
        return Icons.local_drink_rounded;
      case 'Tatlılar':
        return Icons.cake_outlined;
      case 'Atıştırmalıklar':
        return Icons.bakery_dining_outlined;
      case 'Kahveler':
      default:
        return Icons.local_cafe_rounded;
    }
  }

  static Color iconColorForCategory(String category) {
    switch (category) {
      case 'Soğuk İçecekler':
        return AppColors.primary;
      case 'Tatlılar':
        return const Color(0xFF6B4E3D); // Sıcak kahverengi
      case 'Atıştırmalıklar':
        return const Color(0xFF7A6652); // Bej-antrasit
      case 'Kahveler':
      default:
        return AppColors.primary;
    }
  }

  static Color backgroundForCategory(String category) {
    switch (category) {
      case 'Soğuk İçecekler':
        return AppColors.primaryLight;
      case 'Tatlılar':
        return const Color(0xFFF3EDE8); // Sıcak bej
      case 'Atıştırmalıklar':
        return const Color(0xFFF2EDE9); // Kırık beyaz
      case 'Kahveler':
      default:
        return AppColors.champagneLight;
    }
  }

  /// Ürün kategorisine göre ikon widget'ı döndürür.
  static Widget buildProductIcon(String category, {double size = 42}) {
    return Container(
      width: size * 1.6,
      height: size * 1.6,
      decoration: BoxDecoration(
        color: backgroundForCategory(category),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        iconForCategory(category),
        size: size,
        color: iconColorForCategory(category),
      ),
    );
  }
}
