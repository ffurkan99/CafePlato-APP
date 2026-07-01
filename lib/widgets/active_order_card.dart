import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_motion.dart';
import '../core/theme/app_text_styles.dart';
import '../models/order.dart';
import 'pressable_scale.dart';

class ActiveOrderCard extends StatelessWidget {
  const ActiveOrderCard({
    super.key,
    required this.order,
    required this.onComplete,
  });

  final Order order;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final status = order.status;
    final subtitle = switch (status) {
      OrderStatus.received => 'Siparişiniz kafeye iletildi.',
      OrderStatus.preparing => 'Baristanız siparişinizi hazırlıyor.',
      OrderStatus.ready => 'Siparişinizi seçili şubeden teslim alabilirsiniz.',
      OrderStatus.completed => '',
    };
    final estimate = switch (status) {
      OrderStatus.received => 'Yaklaşık 10 dakika',
      OrderStatus.preparing => 'Yaklaşık 5–8 dakika',
      OrderStatus.ready => 'Teslim alınmaya hazır',
      OrderStatus.completed => '',
    };

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: status == OrderStatus.ready
                      ? AppColors.success.withValues(alpha: 0.09)
                      : AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(11),
                ),
                alignment: Alignment.center,
                child: Icon(
                  status == OrderStatus.ready
                      ? Icons.coffee_rounded
                      : Icons.schedule_rounded,
                  size: 20,
                  color: status == OrderStatus.ready
                      ? AppColors.success
                      : AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedSwitcher(
                      duration: AppMotion.duration(context, AppMotion.slow),
                      switchInCurve: AppMotion.entrance,
                      switchOutCurve: AppMotion.exit,
                      child: Text(
                        status.title,
                        key: ValueKey(status),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.heading3.copyWith(fontSize: 17),
                      ),
                    ),
                    const SizedBox(height: 3),
                    AnimatedSwitcher(
                      duration: AppMotion.duration(context, AppMotion.normal),
                      child: Text(
                        subtitle,
                        key: ValueKey('subtitle-${status.name}'),
                        style: AppTextStyles.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '${order.orderNumber} · ${order.selectedBranch.name}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              Expanded(
                child: Text(
                  order.productSummary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: AnimatedSwitcher(
                  duration: AppMotion.duration(context, AppMotion.normal),
                  child: Text(
                    estimate,
                    key: ValueKey('estimate-${status.name}'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: status == OrderStatus.ready
                          ? AppColors.success
                          : AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _OrderProgress(status: status),
          if (status == OrderStatus.ready) ...[
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: PressableScale(
                semanticLabel: 'Siparişi teslim aldım',
                onTap: onComplete,
                pressedScale: 0.99,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('Teslim Aldım', style: AppTextStyles.button),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OrderProgress extends StatelessWidget {
  const _OrderProgress({required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final activeIndex = switch (status) {
      OrderStatus.received => 0,
      OrderStatus.preparing => 1,
      OrderStatus.ready || OrderStatus.completed => 2,
    };
    const labels = ['Alındı', 'Hazırlanıyor', 'Hazır'];
    final duration = AppMotion.duration(context, AppMotion.slow);

    return Row(
      children: List.generate(labels.length, (index) {
        final isComplete = index < activeIndex;
        final isActive = index == activeIndex;
        final leftActive = index <= activeIndex;
        final rightActive = index < activeIndex;

        return Expanded(
          child: Column(
            children: [
              SizedBox(
                height: 26,
                child: Row(
                  children: [
                    Expanded(
                      child: AnimatedContainer(
                        duration: duration,
                        curve: AppMotion.standard,
                        height: 2,
                        color: index == 0
                            ? Colors.transparent
                            : leftActive
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                    AnimatedContainer(
                      duration: duration,
                      curve: AppMotion.standard,
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isComplete
                            ? AppColors.primary
                            : isActive
                            ? AppColors.primaryLight
                            : AppColors.background,
                        border: Border.all(
                          color: isComplete || isActive
                              ? AppColors.primary
                              : AppColors.border,
                          width: 1.5,
                        ),
                      ),
                      child: isComplete
                          ? const Icon(
                              Icons.check_rounded,
                              size: 14,
                              color: Colors.white,
                            )
                          : isActive
                          ? Center(
                              child: SizedBox(
                                width: 7,
                                height: 7,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            )
                          : null,
                    ),
                    Expanded(
                      child: AnimatedContainer(
                        duration: duration,
                        curve: AppMotion.standard,
                        height: 2,
                        color: index == labels.length - 1
                            ? Colors.transparent
                            : rightActive
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  labels[index],
                  maxLines: 1,
                  style: AppTextStyles.label.copyWith(
                    color: isComplete || isActive
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
