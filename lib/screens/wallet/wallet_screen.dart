import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock_data.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/section_header.dart';

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
        slivers: [
          const SliverToBoxAdapter(
            child: SectionHeader(title: 'Cüzdanım'),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      '1.240',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -1,
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'Gold Üye',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.location_on_rounded, color: Colors.white70, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            selectedBranch.name,
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.qr_code_2_rounded, size: 120, color: AppColors.textPrimary),
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
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final coupon = MockData.coupons[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.card_giftcard_rounded, color: AppColors.primary),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(coupon.title, style: AppTextStyles.heading3.copyWith(fontSize: 16)),
                        ),
                        TextButton(
                          onPressed: () => _showCouponSnackBar(context),
                          child: const Text('Kullan'),
                        )
                      ],
                    ),
                  ),
                );
              },
              childCount: MockData.coupons.length,
            ),
          ),
          const SliverToBoxAdapter(
            child: SectionHeader(title: 'Son İşlemler'),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final transaction = MockData.recentTransactions[index];
                final isPositive = transaction.pointDelta > 0;
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  leading: CircleAvatar(
                    backgroundColor: isPositive ? AppColors.success.withValues(alpha: 0.1) : AppColors.primaryLight,
                    child: Icon(
                      isPositive ? Icons.add_rounded : Icons.remove_rounded,
                      color: isPositive ? AppColors.success : AppColors.primary,
                    ),
                  ),
                  title: Text(transaction.description, style: AppTextStyles.bodyLarge),
                  trailing: Text(
                    '${isPositive ? '+' : ''}${transaction.pointDelta}',
                    style: TextStyle(
                      color: isPositive ? AppColors.success : AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                );
              },
              childCount: MockData.recentTransactions.length,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 32),
          ),
        ],
      ),
    );
  }
}
