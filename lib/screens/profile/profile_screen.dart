import 'package:flutter/material.dart';
import '../../core/navigation/app_modal.dart';
import '../../core/navigation/app_page_route.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/pressable_scale.dart';
import 'notification_settings_screen.dart';
import 'favorites_screen.dart';
import 'order_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLogoutDialog(BuildContext context) {
    AppModal.showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Çıkış Yap', style: AppTextStyles.heading3),
          content: const Text(
            'Bu prototipte kullanıcı oturumu açık kalmaktadır.',
          ),
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
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.champagneLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.champagne),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'F',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Furkan', style: AppTextStyles.heading2),
                      const SizedBox(height: 4),
                      Text(
                        'furkan@example.com',
                        style: AppTextStyles.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.champagneLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.champagne),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: AppColors.champagne,
                  size: 16,
                ),
                const SizedBox(width: 8),
                const Flexible(
                  child: Text(
                    'Gold Üye • 1.240 Puan',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                _buildGroupTitle('Hesabım'),
                _buildMenuItem(
                  icon: Icons.history_rounded,
                  title: 'Sipariş Geçmişim',
                  onTap: () {
                    AppNavigator.push(context, const OrderHistoryScreen());
                  },
                ),
                _buildMenuItem(
                  icon: Icons.favorite_border_rounded,
                  title: 'Favorilerim',
                  onTap: () {
                    AppNavigator.push(context, const FavoritesScreen());
                  },
                ),
                _buildMenuItem(
                  icon: Icons.location_on_outlined,
                  title: 'Kayıtlı Adresler',
                  onTap: () =>
                      _showNotImplementedSnackBar(context, 'Kayıtlı Adresler'),
                  isLast: true,
                ),
                const SizedBox(height: 24),

                _buildGroupTitle('Tercihler'),
                _buildMenuItem(
                  icon: Icons.notifications_none_rounded,
                  title: 'Bildirim Ayarları',
                  onTap: () {
                    AppNavigator.push(
                      context,
                      const NotificationSettingsScreen(),
                    );
                  },
                  isLast: true,
                ),
                const SizedBox(height: 24),

                _buildGroupTitle('Destek'),
                _buildMenuItem(
                  icon: Icons.help_outline_rounded,
                  title: 'Yardım ve Destek',
                  onTap: () =>
                      _showNotImplementedSnackBar(context, 'Yardım ve Destek'),
                ),
                _buildMenuItem(
                  icon: Icons.info_outline_rounded,
                  title: 'Uygulama Hakkında',
                  onTap: () =>
                      _showNotImplementedSnackBar(context, 'Uygulama Hakkında'),
                  isLast: true,
                ),
                const SizedBox(height: 48),
                Center(
                  child: GestureDetector(
                    onTap: () => _showLogoutDialog(context),
                    child: Text(
                      'Çıkış Yap',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.label.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return _ProfileMenuItem(
      icon: icon,
      title: title,
      onTap: onTap,
      isLast: isLast,
    );
  }
}

class _ProfileMenuItem extends StatefulWidget {
  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.isLast,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isLast;

  @override
  State<_ProfileMenuItem> createState() => _ProfileMenuItemState();
}

class _ProfileMenuItemState extends State<_ProfileMenuItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final duration = AppMotion.duration(
      context,
      _isPressed ? AppMotion.instant : AppMotion.fast,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          PressableScale(
            semanticLabel: widget.title,
            pressedScale: 0.99,
            onPressedChanged: (value) => setState(() => _isPressed = value),
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: duration,
              curve: AppMotion.standard,
              constraints: const BoxConstraints(minHeight: 56),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: _isPressed
                    ? AppColors.primaryLight.withValues(alpha: 0.55)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Icon(
                      widget.icon,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(widget.title, style: AppTextStyles.bodyLarge),
                  ),
                  AnimatedSlide(
                    offset: _isPressed ? const Offset(0.12, 0) : Offset.zero,
                    duration: duration,
                    curve: AppMotion.standard,
                    child: const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!widget.isLast)
            const Divider(
              height: 1,
              indent: 8,
              endIndent: 8,
              color: AppColors.border,
            ),
        ],
      ),
    );
  }
}
