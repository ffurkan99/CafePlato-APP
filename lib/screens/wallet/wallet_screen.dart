import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock_data.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/section_header.dart';
import '../../widgets/pressable_scale.dart';
import '../../widgets/cafe_plato_arc.dart';
import '../../widgets/app_feedback.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  void _showCouponSnackBar(BuildContext context) {
    AppFeedback.show(context, 'Kupon kullanımı prototipte henüz aktif değil.');
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
              child: _buildMembershipCard(context, selectedBranch.name),
            ),
          ),
          const SliverToBoxAdapter(
            child: SectionHeader(title: 'Aktif Kuponlar'),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final coupon = MockData.coupons[index];
              return Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
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
                        child: const Icon(
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
                        onTap: () => _showCouponSnackBar(context),
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
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
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
                            fontFamily: AppTextStyles.fontFamily,
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

  Widget _buildMembershipCard(BuildContext context, String branchName) {
    return Container(
      decoration: BoxDecoration(
        // Hafif tonal gradient — banka kartı değil sadakat kartı
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFC0272E), // Biraz daha açık bordo
            Color(0xFF8E1F25), // Tonal koyu bordo
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: AppColors.primaryGlow,
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // CafePlato Arc motifi
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: const CafePlatoArc(
                color: Colors.white,
                opacity: 0.07,
                alignment: Alignment.centerRight,
                innerRadiusFactor: 0.65,
                outerRadiusFactor: 0.88,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Üst satır: Club label + Gold badge
                Row(
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'CAFEPLATO CLUB',
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: Colors.white.withAlpha(180),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.6,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(25),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: const Color(0xFFFFD700).withAlpha(120),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFFFD700),
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Gold Üye',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Puan gösterimi
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '1.240',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 38,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -1.5,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'CafePuan',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 14,
                          color: Colors.white.withAlpha(180),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                // Şube
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.white.withAlpha(160),
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        branchName,
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: Colors.white.withAlpha(160),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // QR alan — beyaz yüzen yüzey
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(30),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.qr_code_2_rounded,
                        size: 80,
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Text(
                          'Kasada QR kodunuzu okutun',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
