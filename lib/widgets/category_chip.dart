import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_text_styles.dart';
import 'pressable_scale.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final duration = AppMotion.duration(context, AppMotion.normal);

    return PressableScale(
      semanticLabel: '$label kategorisi',
      selected: isSelected,
      onTap: () {
        if (!isSelected) {
          HapticFeedback.selectionClick();
          onTap();
        }
      },
      child: AnimatedContainer(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        duration: duration,
        curve: AppMotion.standard,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1 : 1,
          ),
        ),
        child: AnimatedDefaultTextStyle(
          duration: duration,
          curve: AppMotion.standard,
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 13,
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
          child: Text(label),
        ),
      ),
    );
  }
}
