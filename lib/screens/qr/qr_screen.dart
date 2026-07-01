import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/theme_reactivity.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_feedback.dart';
import '../../widgets/cafe_plato_arc.dart';
import '../../widgets/loyalty_activity_sections.dart';
import '../../widgets/pressable_scale.dart';

class QrScreen extends StatelessWidget {
  const QrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    dependOnThemeChanges(context);

    final user = context.watch<AuthProvider>().currentUser;
    final branch = context.watch<AppStateProvider>().selectedBranch;
    final payload = 'CAFEPLATO-DEMO-${user?.phone ?? 'GUEST'}';

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final qrSize = math.min(constraints.maxWidth - 92, 250.0);
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('QR Kodum', style: AppTextStyles.heading1),
                const SizedBox(height: 5),
                Text(
                  'Kasada okut, puan kazan.',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 22),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CafePlatoArc(
                          color: AppColors.primary,
                          opacity: 0.05,
                          alignment: Alignment.bottomRight,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    user?.fullName ?? 'CafePlato Üyesi',
                                    style: AppTextStyles.heading3,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 9,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.champagneLight,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppColors.champagne,
                                    ),
                                  ),
                                  child: const Text(
                                    'Gold Üye',
                                    style: AppTextStyles.label,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: QrImageView(
                                data: payload,
                                version: QrVersions.auto,
                                size: qrSize,
                                padding: EdgeInsets.zero,
                                eyeStyle: const QrEyeStyle(
                                  eyeShape: QrEyeShape.square,
                                  color: AppColors.textPrimary,
                                ),
                                dataModuleStyle: const QrDataModuleStyle(
                                  dataModuleShape: QrDataModuleShape.square,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text('1.240', style: AppTextStyles.displayValue),
                            Text('CafePuan', style: AppTextStyles.bodyMedium),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                _InfoRow(
                  icon: Icons.storefront_outlined,
                  label: 'Seçili şube',
                  value: branch.name,
                ),
                const SizedBox(height: 10),
                const _InfoRow(
                  icon: Icons.qr_code_scanner_rounded,
                  label: 'Nasıl kullanılır?',
                  value: 'Siparişten önce kasada göster.',
                ),
                const SizedBox(height: 14),
                PressableScale(
                  semanticLabel: 'Kodu yenile',
                  onTap: () => AppFeedback.show(
                    context,
                    'Demo QR kodun kullanıma hazır.',
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Kodu Yenile',
                      style: AppTextStyles.controlLabel.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const LoyaltyActivitySections(),
                const SizedBox(height: 4),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 21),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.label),
                const SizedBox(height: 2),
                Text(value, style: AppTextStyles.bodyLarge, maxLines: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
