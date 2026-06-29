import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'animated_count.dart';
import 'pressable_scale.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            icon: Icons.remove_rounded,
            onTap: () {
              if (quantity > 1) {
                onChanged(quantity - 1);
              }
            },
            isEnabled: quantity > 1,
          ),
          SizedBox(
            width: 40,
            child: AnimatedCount(
              value: quantity,
              style: AppTextStyles.heading3,
            ),
          ),
          _buildButton(
            icon: Icons.add_rounded,
            onTap: () {
              onChanged(quantity + 1);
            },
            isEnabled: true,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isEnabled,
  }) {
    return PressableScale(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(999),
      semanticLabel: icon == Icons.add_rounded ? 'Adedi artır' : 'Adedi azalt',
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isEnabled ? AppColors.cardBackground : Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          size: 20,
          color: isEnabled ? AppColors.textPrimary : AppColors.border,
        ),
      ),
    );
  }
}
