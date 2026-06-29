import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_motion.dart';

class PressableScale extends StatefulWidget {
  const PressableScale({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.semanticLabel,
    this.selected,
    this.pressedScale = 0.98,
    this.pressedOpacity = 1,
    this.onPressedChanged,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.overlayColor,
    this.hoverColor,
    this.enableHover = true,
    this.enableHaptic = false,
    this.splashFactory = InkRipple.splashFactory,
    this.enabled = true,
    this.allowChildInteractions = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? semanticLabel;
  final bool? selected;
  final double pressedScale;
  final double pressedOpacity;
  final ValueChanged<bool>? onPressedChanged;
  final BorderRadius borderRadius;
  final Color? overlayColor;
  final Color? hoverColor;
  final bool enableHover;
  final bool enableHaptic;
  final InteractiveInkFeatureFactory splashFactory;
  final bool enabled;
  final bool allowChildInteractions;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _isPressed = false;
  bool _isHovered = false;

  bool get _isEnabled =>
      widget.enabled && (widget.onTap != null || widget.onLongPress != null);

  void _handleTap() {
    if (widget.enableHaptic) HapticFeedback.selectionClick();
    widget.onTap?.call();
  }

  void _setPressed(bool value) {
    if (!_isEnabled || _isPressed == value) return;

    setState(() => _isPressed = value);
    widget.onPressedChanged?.call(value);
  }

  void _setHovered(bool value) {
    if (!_isEnabled || !widget.enableHover || _isHovered == value) return;
    setState(() => _isHovered = value);
  }

  Widget _animatedSurface(BuildContext context, Widget child) {
    final duration = AppMotion.duration(
      context,
      _isPressed ? AppMotion.instant : AppMotion.fast,
    );

    return AnimatedScale(
      scale: _isPressed ? widget.pressedScale : 1,
      duration: duration,
      curve: AppMotion.standard,
      child: AnimatedOpacity(
        opacity: _isPressed ? widget.pressedOpacity : 1,
        duration: duration,
        curve: AppMotion.standard,
        child: ClipRRect(borderRadius: widget.borderRadius, child: child),
      ),
    );
  }

  Widget _buildChildInteractiveSurface(BuildContext context) {
    final baseColor = widget.overlayColor ?? const Color(0xFFB3262E);
    final hoverColor = widget.hoverColor ?? baseColor;
    final stateColor = _isPressed
        ? baseColor.withValues(alpha: 0.05)
        : _isHovered
        ? hoverColor.withValues(alpha: 0.035)
        : Colors.transparent;

    return MouseRegion(
      cursor: _isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        excludeFromSemantics: true,
        onTapDown: _isEnabled ? (_) => _setPressed(true) : null,
        onTapUp: _isEnabled ? (_) => _setPressed(false) : null,
        onTapCancel: _isEnabled ? () => _setPressed(false) : null,
        onTap: _isEnabled && widget.onTap != null ? _handleTap : null,
        onLongPress: _isEnabled ? widget.onLongPress : null,
        child: _animatedSurface(
          context,
          Stack(
            fit: StackFit.passthrough,
            children: [
              widget.child,
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedContainer(
                    duration: AppMotion.duration(context, AppMotion.fast),
                    curve: AppMotion.standard,
                    color: stateColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: _isEnabled,
      label: widget.semanticLabel,
      selected: widget.selected,
      onTap: _isEnabled && widget.onTap != null ? _handleTap : null,
      onLongPress: _isEnabled ? widget.onLongPress : null,
      child: widget.allowChildInteractions
          ? _buildChildInteractiveSurface(context)
          : _animatedSurface(
              context,
              Stack(
                fit: StackFit.passthrough,
                clipBehavior: Clip.hardEdge,
                children: [
                  widget.child,
                  Positioned.fill(
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        excludeFromSemantics: true,
                        borderRadius: widget.borderRadius,
                        customBorder: RoundedRectangleBorder(
                          borderRadius: widget.borderRadius,
                        ),
                        mouseCursor: _isEnabled
                            ? SystemMouseCursors.click
                            : SystemMouseCursors.basic,
                        splashFactory: widget.splashFactory,
                        splashColor:
                            (widget.overlayColor ?? const Color(0xFFB3262E))
                                .withValues(alpha: 0.08),
                        highlightColor:
                            (widget.overlayColor ?? const Color(0xFFB3262E))
                                .withValues(alpha: 0.05),
                        hoverColor: widget.enableHover
                            ? (widget.hoverColor ??
                                      widget.overlayColor ??
                                      const Color(0xFFB3262E))
                                  .withValues(alpha: 0.035)
                            : Colors.transparent,
                        focusColor:
                            (widget.hoverColor ??
                                    widget.overlayColor ??
                                    const Color(0xFFB3262E))
                                .withValues(alpha: 0.045),
                        onHighlightChanged: _setPressed,
                        onTap: _isEnabled && widget.onTap != null
                            ? _handleTap
                            : null,
                        onLongPress: _isEnabled ? widget.onLongPress : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
