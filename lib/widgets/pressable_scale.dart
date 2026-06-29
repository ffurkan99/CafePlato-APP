import 'package:flutter/material.dart';

import '../core/theme/app_motion.dart';

class PressableScale extends StatefulWidget {
  const PressableScale({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.semanticLabel,
    this.selected,
    this.pressedScale = 0.97,
    this.pressedOpacity = 0.96,
    this.onPressedChanged,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? semanticLabel;
  final bool? selected;
  final double pressedScale;
  final double pressedOpacity;
  final ValueChanged<bool>? onPressedChanged;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _isPressed = false;

  bool get _isEnabled => widget.onTap != null || widget.onLongPress != null;

  void _setPressed(bool value) {
    if (!_isEnabled || _isPressed == value) return;

    setState(() => _isPressed = value);
    widget.onPressedChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final duration = AppMotion.duration(
      context,
      _isPressed ? AppMotion.instant : AppMotion.fast,
    );

    return Semantics(
      button: true,
      enabled: _isEnabled,
      label: widget.semanticLabel,
      selected: widget.selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        excludeFromSemantics: true,
        onTapDown: _isEnabled ? (_) => _setPressed(true) : null,
        onTapUp: _isEnabled ? (_) => _setPressed(false) : null,
        onTapCancel: _isEnabled ? () => _setPressed(false) : null,
        onTap: _isEnabled ? widget.onTap : null,
        onLongPress: _isEnabled ? widget.onLongPress : null,
        child: AnimatedScale(
          scale: _isPressed ? widget.pressedScale : 1,
          duration: duration,
          curve: AppMotion.standard,
          child: AnimatedOpacity(
            opacity: _isPressed ? widget.pressedOpacity : 1,
            duration: duration,
            curve: AppMotion.standard,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
