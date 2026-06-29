import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_text_styles.dart';
import 'pressable_scale.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: PressableScale(
        semanticLabel: text,
        onTap: isLoading ? null : onPressed,
        child: AnimatedContainer(
          duration: AppMotion.duration(context, AppMotion.fast),
          curve: AppMotion.standard,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isLoading
                ? AppColors.primary.withAlpha(150)
                : AppColors.primary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
              width: 1.5,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
            boxShadow: isLoading
                ? null
                : const [
                    BoxShadow(
                      color: AppColors.primaryGlow,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
          ),
          child: AnimatedSwitcher(
            duration: AppMotion.duration(context, AppMotion.fast),
            child: isLoading
                ? const SizedBox(
                    key: ValueKey('loading'),
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(text, key: ValueKey(text), style: AppTextStyles.button),
          ),
        ),
      ),
    );
  }
}
