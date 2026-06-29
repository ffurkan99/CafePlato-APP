import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'cafe_plato_arc.dart';

class LoyaltyCard extends StatelessWidget {
  const LoyaltyCard({super.key});

  static const int _totalSteps = 5;
  static const int _completedSteps = 3;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border, width: 0.8),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowTint,
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // CafePlato Arc arka plan motifi (çok düşük opacity)
            Positioned.fill(
              child: CafePlatoArc(
                color: AppColors.champagne,
                opacity: 0.18,
                alignment: Alignment.centerRight,
                innerRadiusFactor: 0.6,
                outerRadiusFactor: 0.82,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Üst alan: marka adı + puan + badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CAFEPLATO',
                            style: AppTextStyles.label.copyWith(
                              color: AppColors.champagne,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.8,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '1.240',
                                style: AppTextStyles.displayValue.copyWith(
                                  fontSize: 30,
                                  letterSpacing: -1,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Puan',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Gold Üye badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.champagneLight,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppColors.champagne,
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: AppColors.champagne,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Gold',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              color: AppColors.textPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Bağlantılı ilerleme çubuğu
                _buildProgressRow(),
                const SizedBox(height: 12),
                Text(
                  'Ödül kahvene 2 kahve kaldı!',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const iconSize = 28.0;
        const lineHeight = 1.5;
        // Her bir ikon alanı için eşit genişlik bırak
        final stepWidth =
            (constraints.maxWidth - iconSize * _totalSteps) /
            (_totalSteps - 1);

        return SizedBox(
          height: iconSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Bağlantı çizgileri (ikonların arkasında)
              for (int i = 0; i < _totalSteps - 1; i++)
                Positioned(
                  left:
                      iconSize * (i + 1) + stepWidth * i + (stepWidth / 2) -
                      (stepWidth / 2),
                  child: Container(
                    width: stepWidth,
                    height: lineHeight,
                    color: i < _completedSteps - 1
                        ? AppColors.primary.withAlpha(180)
                        : AppColors.border,
                  ),
                ),
              // İkonlar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_totalSteps, (index) {
                  final isActive = index < _completedSteps;
                  final isLast = index == _totalSteps - 1;
                  final isReward = isLast;

                  return Container(
                    width: iconSize,
                    height: iconSize,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primary
                          : AppColors.background,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isActive
                            ? AppColors.primary
                            : AppColors.border,
                        width: 1.0,
                      ),
                    ),
                    child: isReward && !isActive
                        ? const Icon(
                            Icons.star_rounded,
                            color: AppColors.champagne,
                            size: 14,
                          )
                        : Icon(
                            Icons.local_cafe_rounded,
                            color: isActive
                                ? Colors.white
                                : AppColors.border,
                            size: 14,
                          ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
