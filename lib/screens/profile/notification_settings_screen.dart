import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/theme_reactivity.dart';
import '../../providers/app_state_provider.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    dependOnThemeChanges(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bildirim Ayarları'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<AppStateProvider>(
        builder: (context, provider, child) {
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _buildSwitchItem(
                title: 'Kampanyalar',
                description: 'Özel indirimler ve fırsatlardan haberdar olun.',
                value: provider.campaignNotifications,
                onChanged: provider.setCampaignNotifications,
              ),
              _buildSwitchItem(
                title: 'Sipariş Durumu',
                description: 'Siparişinizin hazırlanma ve teslimat durumu.',
                value: provider.orderStatusNotifications,
                onChanged: provider.setOrderStatusNotifications,
              ),
              _buildSwitchItem(
                title: 'Yeni Ürünler',
                description: 'Menüye eklenen yeni lezzetleri keşfedin.',
                value: provider.newProductNotifications,
                onChanged: provider.setNewProductNotifications,
              ),
              _buildSwitchItem(
                title: 'CafePuan Bildirimleri',
                description: 'Kazandığınız ve harcadığınız puanlar.',
                value: provider.cafePointNotifications,
                onChanged: provider.setCafePointNotifications,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSwitchItem({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.heading3.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(description, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Switch.adaptive(
            value: value,
            onChanged: (newValue) {
              if (newValue != value) {
                HapticFeedback.selectionClick();
                onChanged(newValue);
              }
            },
            activeThumbColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.35),
          ),
        ],
      ),
    );
  }
}
