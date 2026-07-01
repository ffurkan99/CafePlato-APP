import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/navigation/app_modal.dart';
import '../../core/navigation/app_page_route.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/theme_reactivity.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_feedback.dart';
import '../../widgets/pressable_scale.dart';
import 'notification_settings_screen.dart';
import 'favorites_screen.dart';
import 'order_history_screen.dart';
import 'theme_picker_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLogoutDialog(BuildContext context) {
    AppModal.showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Çıkış yapılsın mı?', style: AppTextStyles.heading3),
                const SizedBox(height: 8),
                const Text(
                  'Hesap bilgilerin cihazda kalır; daha sonra tekrar giriş yapabilirsin.',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: PressableScale(
                        semanticLabel: 'İptal',
                        onTap: () => Navigator.pop(dialogContext),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'İptal',
                            style: AppTextStyles.controlLabel,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: PressableScale(
                        semanticLabel: 'Çıkış Yap',
                        overlayColor: Colors.black,
                        onTap: () async {
                          await context.read<AuthProvider>().logout();
                          if (!context.mounted) return;
                          Navigator.of(dialogContext).pop();
                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Çıkış Yap',
                            style: AppTextStyles.button,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showNotImplementedSnackBar(BuildContext context, String feature) {
    AppFeedback.show(
      context,
      '$feature henüz prototip aşamasında aktif değil.',
    );
  }

  @override
  Widget build(BuildContext context) {
    dependOnThemeChanges(context);

    final user = context.watch<AuthProvider>().currentUser;
    final fullName = user?.fullName.isNotEmpty == true
        ? user!.fullName
        : 'CafePlato Üyesi';
    final contact = user?.email.isNotEmpty == true
        ? user!.email
        : (user?.phone ?? '');
    final initial = (user?.firstName.isNotEmpty == true ? user!.firstName : 'C')
        .characters
        .first
        .toUpperCase();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 20, 8),
              child: Row(
                children: [
                  PressableScale(
                    semanticLabel: 'Geri',
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => Navigator.of(context).maybePop(),
                    child: const SizedBox(
                      width: 44,
                      height: 44,
                      child: Icon(Icons.arrow_back_rounded),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text('Profil', style: AppTextStyles.heading3),
                ],
              ),
            ),
            const SizedBox(height: 10),
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
                    child: Text(
                      initial,
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
                        Text(
                          fullName,
                          style: AppTextStyles.heading2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          contact,
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
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.champagneLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.champagne, width: 0.8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.champagne,
                      size: 13,
                    ),
                    const SizedBox(width: 6),
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
                    onTap: () => _showNotImplementedSnackBar(
                      context,
                      'Kayıtlı Adresler',
                    ),
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
                    onTap: () => _showNotImplementedSnackBar(
                      context,
                      'Yardım ve Destek',
                    ),
                  ),
                  _buildMenuItem(
                    icon: Icons.info_outline_rounded,
                    title: 'Uygulama Hakkında',
                    onTap: () => _showNotImplementedSnackBar(
                      context,
                      'Uygulama Hakkında',
                    ),
                    isLast: true,
                  ),
                  const SizedBox(height: 24),

                  _buildGroupTitle('Prototip'),
                  _buildMenuItem(
                    icon: Icons.palette_outlined,
                    title: 'Tema Değiştir',
                    onTap: () {
                      AppNavigator.push(context, const ThemePickerScreen());
                    },
                    isLast: true,
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: PressableScale(
                      semanticLabel: 'Çıkış Yap',
                      onTap: () => _showLogoutDialog(context),
                      pressedScale: 0.97,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Icon(
                                Icons.logout_rounded,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Çıkış Yap',
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
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
            borderRadius: BorderRadius.circular(14),
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
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
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
