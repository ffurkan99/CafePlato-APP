import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../data/mock_data.dart';
import 'app_feedback.dart';
import 'pressable_scale.dart';
import 'section_header.dart';

class LoyaltyActivitySections extends StatelessWidget {
  const LoyaltyActivitySections({super.key});

  void _showCouponFeedback(BuildContext context) {
    AppFeedback.show(context, 'Kupon kullanımı prototipte henüz aktif değil.');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Aktif Kuponlar',
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 16),
        ),
        for (final coupon in MockData.coupons)
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 4, bottom: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border, width: 0.8),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.card_giftcard_rounded,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      coupon.title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  PressableScale(
                    semanticLabel: '${coupon.title} kuponunu kullan',
                    onTap: () => _showCouponFeedback(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        'Kullan',
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SectionHeader(
          title: 'Son İşlemler',
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 16),
        ),
        for (var index = 0; index < MockData.recentTransactions.length; index++)
          _TransactionRow(index: index),
      ],
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final transaction = MockData.recentTransactions[index];
    final isPositive = transaction.pointDelta > 0;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isPositive
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPositive ? Icons.add_rounded : Icons.remove_rounded,
                  color: isPositive ? AppColors.success : AppColors.primary,
                  size: 16,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  transaction.description,
                  style: AppTextStyles.bodyLarge,
                ),
              ),
              Text(
                '${isPositive ? '+' : ''}${transaction.pointDelta}',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: isPositive ? AppColors.success : AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        if (index < MockData.recentTransactions.length - 1)
          const Divider(
            height: 1,
            indent: 44,
            endIndent: 4,
            color: AppColors.border,
          ),
      ],
    );
  }
}
