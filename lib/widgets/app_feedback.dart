import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

enum AppFeedbackType { success, info, error }

class AppFeedback {
  AppFeedback._();

  static void show(
    BuildContext context,
    String message, {
    AppFeedbackType type = AppFeedbackType.info,
  }) {
    final accent = switch (type) {
      AppFeedbackType.success => AppColors.success,
      AppFeedbackType.info => AppColors.primary,
      AppFeedbackType.error => const Color(0xFFC73A42),
    };
    final icon = switch (type) {
      AppFeedbackType.success => Icons.check_circle_outline_rounded,
      AppFeedbackType.info => Icons.info_outline_rounded,
      AppFeedbackType.error => Icons.error_outline_rounded,
    };

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowTint,
                blurRadius: 14,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: accent, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
