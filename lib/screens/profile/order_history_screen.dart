import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock order history data
    final orders = [
      {
        'date': '24 Haziran 2026, 14:30',
        'branch': 'Kadıköy Moda Şubesi',
        'items': 'Iced Latte',
        'total': '145.00 ₺',
        'status': 'Teslim Edildi',
      },
      {
        'date': '20 Haziran 2026, 09:15',
        'branch': 'Beşiktaş Çarşı Şubesi',
        'items': 'Flat White',
        'total': '135.00 ₺',
        'status': 'Teslim Edildi',
      },
      {
        'date': '15 Haziran 2026, 18:45',
        'branch': 'Nişantaşı Şubesi',
        'items': 'San Sebastian, Americano',
        'total': '310.00 ₺',
        'status': 'Teslim Edildi',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Sipariş Geçmişim'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: orders.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final order = orders[index];
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(order['date']!, style: AppTextStyles.bodySmall),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.success.withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        order['status']!,
                        style: const TextStyle(
                          color: AppColors.success,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.storefront_rounded, size: 20, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Text(order['branch']!, style: AppTextStyles.bodyMedium),
                  ],
                ),
                const SizedBox(height: 8),
                Text(order['items']!, style: AppTextStyles.heading3.copyWith(fontSize: 14)),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Toplam Tutar', style: AppTextStyles.bodyMedium),
                    Text(order['total']!, style: AppTextStyles.heading3.copyWith(color: AppColors.primary)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
