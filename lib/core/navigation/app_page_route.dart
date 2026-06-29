import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/app_motion.dart';

class AppPageRoute {
  AppPageRoute._();

  static Route<T> build<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool fullscreenDialog = false,
  }) {
    final duration = AppMotion.duration(context, AppMotion.normal);

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return CupertinoPageRoute<T>(
        builder: builder,
        settings: settings,
        fullscreenDialog: fullscreenDialog,
      );
    }

    return PageRouteBuilder<T>(
      opaque: true,
      barrierColor: null,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      settings: settings,
      fullscreenDialog: fullscreenDialog,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: AppMotion.standard,
          reverseCurve: AppMotion.exit,
        );

        return FadeTransition(
          opacity: curvedAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.018),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }
}

class AppNavigator {
  AppNavigator._();

  static Future<T?> push<T>(BuildContext context, Widget page) {
    return Navigator.of(
      context,
    ).push<T>(AppPageRoute.build<T>(context: context, builder: (_) => page));
  }

  static Future<T?> pushReplacement<T, TO>(BuildContext context, Widget page) {
    return Navigator.of(context).pushReplacement<T, TO>(
      AppPageRoute.build<T>(context: context, builder: (_) => page),
    );
  }

  static Future<T?> pushAndRemoveUntil<T>(
    BuildContext context,
    Widget page,
    RoutePredicate predicate,
  ) {
    return Navigator.of(context).pushAndRemoveUntil<T>(
      AppPageRoute.build<T>(context: context, builder: (_) => page),
      predicate,
    );
  }
}
