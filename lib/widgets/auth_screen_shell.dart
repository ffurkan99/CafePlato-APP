import 'package:flutter/material.dart';

import '../core/theme/app_text_styles.dart';
import 'app_logo.dart';

class AuthScreenShell extends StatelessWidget {
  const AuthScreenShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.showBackButton = false,
    this.centerContent = false,
    this.maxContentWidth = 480,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final bool showBackButton;
  final bool centerContent;
  final double maxContentWidth;

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final keyboardVisible = keyboardInset > 0;
    final centerHeader = centerContent || showBackButton;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            const horizontalPadding = 24.0;
            const topPadding = 12.0;
            final bottomPadding = keyboardVisible ? 16.0 : 28.0;
            final minimumHeight =
                (constraints.maxHeight - topPadding - bottomPadding).clamp(
                  0.0,
                  double.infinity,
                );

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                topPadding,
                horizontalPadding,
                bottomPadding,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: minimumHeight),
                child: Align(
                  alignment: centerContent && !keyboardVisible
                      ? const Alignment(0, -0.08)
                      : Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxContentWidth),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showBackButton)
                          IconButton(
                            onPressed: () => Navigator.of(context).maybePop(),
                            padding: EdgeInsets.zero,
                            alignment: Alignment.centerLeft,
                            icon: const Icon(Icons.arrow_back_rounded),
                          )
                        else if (!centerContent)
                          const SizedBox(height: 36),
                        if (showBackButton || !centerContent)
                          const SizedBox(height: 18),
                        Align(
                          alignment: centerHeader
                              ? Alignment.center
                              : Alignment.centerLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: centerHeader
                                ? CrossAxisAlignment.center
                                : CrossAxisAlignment.start,
                            children: [
                              AppLogo(width: centerHeader ? 190 : 154),
                              const SizedBox(height: 18),
                              Text(
                                title,
                                textAlign: centerHeader
                                    ? TextAlign.center
                                    : TextAlign.start,
                                style: AppTextStyles.heading1,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                subtitle,
                                textAlign: centerHeader
                                    ? TextAlign.center
                                    : TextAlign.start,
                                style: AppTextStyles.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        child,
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
