import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'notification_settings_screen.dart';
import 'favorites_screen.dart';
import 'order_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.cardBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Çıkış Yap', style: AppTextStyles.heading3),
          content: const Text('Bu prototipte kullanıcı oturumu açık kalmaktadır.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Anladım'),
            ),
          ],
        );
      },
    );
  }

  void _showNotImplementedSnackBar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature henüz prototip aşamasında aktif değil.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 32),
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text(
              'F',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 36,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Furkan', style: AppTextStyles.heading2),
          const SizedBox(height: 4),
          Text('furkan@example.com', style: AppTextStyles.bodyMedium),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Gold Üye',
                  style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '1.240 CafePuan',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView(
              children: [
                _buildMenuItem(
                  icon: Icons.history_rounded,
                  title: 'Sipariş Geçmişim',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.favorite_border_rounded,
                  title: 'Favorilerim',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FavoritesScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.location_on_outlined,
                  title: 'Kayıtlı Adresler',
                  onTap: () => _showNotImplementedSnackBar(context, 'Kayıtlı Adresler'),
                ),
                _buildMenuItem(
                  icon: Icons.notifications_none_rounded,
                  title: 'Bildirim Ayarları',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.help_outline_rounded,
                  title: 'Yardım ve Destek',
                  onTap: () => _showNotImplementedSnackBar(context, 'Yardım ve Destek'),
                ),
                _buildMenuItem(
                  icon: Icons.info_outline_rounded,
                  title: 'Uygulama Hakkında',
                  onTap: () => _showNotImplementedSnackBar(context, 'Uygulama Hakkında'),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Divider(),
                ),
                _buildMenuItem(
                  icon: Icons.logout_rounded,
                  title: 'Çıkış Yap',
                  titleColor: AppColors.primary,
                  iconColor: AppColors.primary,
                  onTap: () => _showLogoutDialog(context),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color titleColor = AppColors.textPrimary,
    Color iconColor = AppColors.textSecondary,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title, style: AppTextStyles.bodyLarge.copyWith(color: titleColor)),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}
