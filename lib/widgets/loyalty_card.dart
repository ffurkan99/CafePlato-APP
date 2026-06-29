import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class LoyaltyCard extends StatelessWidget {
  const LoyaltyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.champagne),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowTint,
              blurRadius: 24,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CafePlato',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.champagne,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '1.240 Puan',
                        style: AppTextStyles.displayValue.copyWith(
                          fontSize: 28,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.champagneLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.champagne),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.champagne,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Gold Üye',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) {
                final isActive = index < 3;
                return Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primaryLight
                        : AppColors.background,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isActive ? AppColors.primary : AppColors.border,
                      width: isActive ? 1.5 : 1.0,
                    ),
                  ),
                  child: Icon(
                    Icons.local_cafe_rounded,
                    color: isActive ? AppColors.primary : AppColors.border,
                    size: 20,
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Ödül kahvene 2 kahve kaldı!',
                style: AppTextStyles.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
