import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../main_navigation.dart';
import '../splash/app_splash_screen.dart';
import 'login_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  static const _minimumSplashDuration = Duration(milliseconds: 1200);

  bool _minimumSplashElapsed = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(_minimumSplashDuration, () {
      if (!mounted) return;
      setState(() => _minimumSplashElapsed = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final themeColor = context.watch<ThemeProvider>().primaryColor;
    if (auth.isLoading || !_minimumSplashElapsed) {
      return const AppSplashScreen();
    }
    return KeyedSubtree(
      key: ValueKey(themeColor.toARGB32()),
      child: auth.isLoggedIn ? const MainNavigation() : const LoginScreen(),
    );
  }
}
