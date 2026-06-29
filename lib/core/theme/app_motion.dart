import 'package:flutter/material.dart';

class AppMotion {
  AppMotion._();

  static const Duration instant = Duration(milliseconds: 90);
  static const Duration fast = Duration(milliseconds: 160);
  static const Duration normal = Duration(milliseconds: 220);
  static const Duration slow = Duration(milliseconds: 360);
  static const Duration intro = Duration(milliseconds: 480);

  static const Curve standard = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve emphasis = Curves.easeOutCubic;
  static const Curve entrance = Curves.easeOutCubic;

  static bool reduceMotion(BuildContext context) {
    return MediaQuery.maybeOf(context)?.disableAnimations ?? false;
  }

  static Duration duration(BuildContext context, Duration preferred) {
    return reduceMotion(context) ? instant : preferred;
  }
}
