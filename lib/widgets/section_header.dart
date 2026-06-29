import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionTitle;
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionTitle,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.heading3,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (actionTitle != null && onActionTap != null) ...[
            const SizedBox(width: 12),
            TextButton(onPressed: onActionTap, child: Text(actionTitle!)),
          ],
        ],
      ),
    );
  }
}
