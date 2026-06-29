import 'package:flutter/material.dart';

import '../theme/app_motion.dart';

class AnimatedIndexedStack extends StatelessWidget {
  const AnimatedIndexedStack({
    super.key,
    required this.index,
    required this.children,
  });

  final int index;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final duration = AppMotion.duration(context, AppMotion.normal);

    return Stack(
      fit: StackFit.expand,
      children: List.generate(children.length, (childIndex) {
        final isActive = childIndex == index;

        return AnimatedOpacity(
          key: ValueKey(childIndex),
          opacity: isActive ? 1 : 0,
          duration: duration,
          curve: AppMotion.standard,
          child: AnimatedSlide(
            offset: isActive ? Offset.zero : const Offset(0, 0.012),
            duration: duration,
            curve: AppMotion.standard,
            child: TickerMode(
              enabled: isActive,
              child: IgnorePointer(
                ignoring: !isActive,
                child: ExcludeSemantics(
                  excluding: !isActive,
                  child: children[childIndex],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
