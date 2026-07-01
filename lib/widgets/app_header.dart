import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import 'app_logo.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onNotificationTap;

  const AppHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.heading1),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTextStyles.bodyMedium),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded),
                onPressed: onNotificationTap,
              ),
              const SizedBox(width: 12),
              Container(
                width: 92,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.champagne),
                ),
                alignment: Alignment.center,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: AppLogo(width: 74),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
