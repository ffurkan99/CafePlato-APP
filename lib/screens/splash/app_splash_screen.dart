import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_logo.dart';

class AppSplashScreen extends StatefulWidget {
  const AppSplashScreen({super.key});

  @override
  State<AppSplashScreen> createState() => _AppSplashScreenState();
}

class _AppSplashScreenState extends State<AppSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _intro;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
    _intro = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.42, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = AppMotion.reduceMotion(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final logoWidth = screenWidth.clamp(0, 520) * 0.58;

    if (reduceMotion && _controller.isAnimating) {
      _controller.stop();
    } else if (!reduceMotion && !_controller.isAnimating) {
      _controller.repeat();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.2),
            radius: 0.9,
            colors: [
              AppColors.champagneLight.withValues(alpha: 0.72),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final introValue = reduceMotion ? 1.0 : _intro.value;
                final breathe = reduceMotion
                    ? 1.0
                    : 1 + (math.sin(_controller.value * math.pi * 2) * 0.012);

                return Opacity(
                  opacity: introValue,
                  child: Transform.scale(
                    scale: (0.94 + (introValue * 0.06)) * breathe,
                    child: child,
                  ),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: logoWidth.toDouble().clamp(220, 300),
                    height: 150,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 0,
                          child: AnimatedBuilder(
                            animation: _controller,
                            builder: (context, _) {
                              return CustomPaint(
                                size: const Size(112, 72),
                                painter: _SteamPainter(
                                  progress: reduceMotion
                                      ? 0.35
                                      : _controller.value,
                                ),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: AppLogo(
                            width: logoWidth.toDouble().clamp(220, 300),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Hoşgeldiniz',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 18),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return _LoadingDots(
                        progress: reduceMotion ? 0 : _controller.value,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingDots extends StatelessWidget {
  const _LoadingDots({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final phase = (progress + (index * 0.18)) % 1;
        final lift = math.sin(phase * math.pi * 2).clamp(0.0, 1.0);
        return Transform.translate(
          offset: Offset(0, -4 * lift),
          child: Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.35 + lift * 0.45),
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
}

class _SteamPainter extends CustomPainter {
  const _SteamPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.4;

    for (var i = 0; i < 3; i++) {
      final phase = (progress + (i * 0.24)) % 1;
      final opacity = (math.sin(phase * math.pi).clamp(0.0, 1.0) * 0.34);
      final drift = (phase - 0.5) * 12;
      final x = (size.width * (0.35 + i * 0.15)) + drift;
      final yOffset = -phase * 18;

      paint.color = AppColors.primary.withValues(alpha: opacity);

      final path = Path()
        ..moveTo(x, size.height * 0.78 + yOffset)
        ..cubicTo(
          x - 16,
          size.height * 0.58 + yOffset,
          x + 18,
          size.height * 0.42 + yOffset,
          x,
          size.height * 0.18 + yOffset,
        );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SteamPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
