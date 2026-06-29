import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_motion.dart';
import 'pressable_scale.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onTap,
    this.iconSize = 20,
    this.padding = 8,
    this.backgroundColor = Colors.transparent,
  });

  final bool isFavorite;
  final VoidCallback onTap;
  final double iconSize;
  final double padding;
  final Color backgroundColor;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  int _animationVersion = 0;

  @override
  void didUpdateWidget(FavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorite != widget.isFavorite) {
      _animationVersion++;
    }
  }

  double _scaleFor(double value) {
    if (value < 0.45) {
      return 0.85 + ((1.12 - 0.85) * (value / 0.45));
    }
    return 1.12 - ((1.12 - 1) * ((value - 0.45) / 0.55));
  }

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      semanticLabel: widget.isFavorite
          ? 'Favorilerden çıkar'
          : 'Favorilere ekle',
      selected: widget.isFavorite,
      borderRadius: BorderRadius.circular(999),
      onTap: () {
        HapticFeedback.selectionClick();
        widget.onTap();
      },
      child: Container(
        width: widget.iconSize + (widget.padding * 2),
        height: widget.iconSize + (widget.padding * 2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          shape: BoxShape.circle,
        ),
        child: TweenAnimationBuilder<double>(
          key: ValueKey(_animationVersion),
          tween: Tween(begin: _animationVersion == 0 ? 1 : 0, end: 1),
          duration: AppMotion.duration(context, AppMotion.normal),
          curve: AppMotion.standard,
          builder: (context, value, child) {
            return Transform.scale(scale: _scaleFor(value), child: child);
          },
          child: AnimatedSwitcher(
            duration: AppMotion.duration(context, AppMotion.fast),
            child: Icon(
              widget.isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              key: ValueKey(widget.isFavorite),
              color: AppColors.primary,
              size: widget.iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
