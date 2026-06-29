import 'package:flutter/material.dart';

import '../core/theme/app_motion.dart';

class AnimatedCount extends StatelessWidget {
  const AnimatedCount({
    super.key,
    required this.value,
    required this.style,
    this.textAlign = TextAlign.center,
  });

  final int value;
  final TextStyle style;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedSwitcher(
        duration: AppMotion.duration(context, AppMotion.fast),
        switchInCurve: AppMotion.standard,
        switchOutCurve: AppMotion.exit,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -0.16),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: Text(
          value.toString(),
          key: ValueKey(value),
          textAlign: textAlign,
          style: style,
        ),
      ),
    );
  }
}
