import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_motion.dart';

class AppModal {
  AppModal._();

  static Future<T?> showBottomSheet<T>({
    required BuildContext context,
    required WidgetBuilder builder,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: AppColors.cardBackground,
      barrierColor: Colors.black.withValues(alpha: 0.28),
      clipBehavior: Clip.antiAlias,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      sheetAnimationStyle: AnimationStyle(
        duration: AppMotion.duration(context, AppMotion.normal),
        reverseDuration: AppMotion.duration(context, AppMotion.fast),
      ),
      builder: (sheetContext) {
        return SafeArea(top: false, child: builder(sheetContext));
      },
    );
  }

  static Future<T?> showDialog<T>({
    required BuildContext context,
    required WidgetBuilder builder,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withValues(alpha: 0.28),
      transitionDuration: AppMotion.duration(context, AppMotion.normal),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return SafeArea(child: builder(dialogContext));
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: AppMotion.standard,
          reverseCurve: AppMotion.exit,
        );

        return FadeTransition(
          opacity: curvedAnimation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.98, end: 1).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }
}
