import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock_data.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/section_header.dart';
import '../../widgets/pressable_scale.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  void _showCouponSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kupon kullanımı prototipte henüz aktif değil.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedBranch = context.watch<AppStateProvider>().selectedBranch;

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(child: SectionHeader(title: 'Cüzdanım')),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      Color(0xFF8B1E24), // Tonal darker red
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.primaryGlow,
                      blurRadius: 24,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      '1.240',
                      style: AppTextStyles.displayValue.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'CafePuan',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFFFD700),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Gold Üye',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.location_on_rounded,
                            color: Colors.white70,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              selectedBranch.name,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.qr_code_2_rounded,
                            size: 96,
                            color: AppColors.textPrimary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Kasada QR kodunuzu okutun',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SectionHeader(title: 'Aktif Kuponlar'),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final coupon = MockData.coupons[index];
              return Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.champagne),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.card_giftcard_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          coupon.title,
                          style: AppTextStyles.heading3.copyWith(fontSize: 16),
                        ),
                      ),
                      PressableScale(
                        semanticLabel: '${coupon.title} kuponunu kullan',
                        onTap: () => _showCouponSnackBar(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.champagneLight,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            'Kullan',
                            style: TextStyle(
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
              );
            }, childCount: MockData.coupons.length),
          ),
          const SliverToBoxAdapter(child: SectionHeader(title: 'Son İşlemler')),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final transaction = MockData.recentTransactions[index];
              final isPositive = transaction.pointDelta > 0;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
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
                            isPositive
                                ? Icons.add_rounded
                                : Icons.remove_rounded,
                            color: isPositive
                                ? AppColors.success
                                : AppColors.primary,
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
                          style: TextStyle(
                            color: isPositive
                                ? AppColors.success
                                : AppColors.primary,
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
                      indent: 64,
                      endIndent: 24,
                      color: AppColors.border,
                    ),
                ],
              );
            }, childCount: MockData.recentTransactions.length),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}
