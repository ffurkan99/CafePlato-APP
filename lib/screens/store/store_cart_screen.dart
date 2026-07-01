import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/theme_reactivity.dart';
import '../../core/utils/price_formatter.dart';
import '../../models/store_cart_item.dart';
import '../../providers/store_cart_provider.dart';
import '../../widgets/app_feedback.dart';
import '../../widgets/pressable_scale.dart';
import '../../widgets/primary_button.dart';

class StoreCartScreen extends StatelessWidget {
  const StoreCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    dependOnThemeChanges(context);

    final cart = context.watch<StoreCartProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mağaza Sepeti'),
        actions: [
          if (cart.items.isNotEmpty)
            PressableScale(
              semanticLabel: 'Sepeti temizle',
              onTap: cart.clear,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Text(
                  'Temizle',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: cart.items.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 48,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 14),
                      Text('Mağaza sepetin boş', style: AppTextStyles.heading3),
                      const SizedBox(height: 6),
                      Text(
                        'Ritüeline eşlik edecek ürünleri mağazadan ekleyebilirsin.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                      itemCount: cart.items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) =>
                          _CartRow(item: cart.items[index]),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
                    decoration: const BoxDecoration(
                      color: AppColors.cardBackground,
                      border: Border(top: BorderSide(color: AppColors.border)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('Ara toplam', style: AppTextStyles.bodyMedium),
                            const Spacer(),
                            Text(
                              PriceFormatter.format(cart.subtotal),
                              style: AppTextStyles.price,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              'Genel toplam',
                              style: AppTextStyles.controlLabel,
                            ),
                            const Spacer(),
                            Text(
                              PriceFormatter.format(cart.total),
                              style: AppTextStyles.heading3.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        PrimaryButton(
                          text: 'Satın Al',
                          onPressed: () => AppFeedback.show(
                            context,
                            'Ödeme adımı bu prototipe dahil değil.',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _CartRow extends StatelessWidget {
  const _CartRow({required this.item});

  final StoreCartItem item;

  @override
  Widget build(BuildContext context) {
    final cart = context.read<StoreCartProvider>();
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              item.product.placeholderIcon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: AppTextStyles.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  PriceFormatter.format(item.totalPrice),
                  style: AppTextStyles.price,
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    _QuantityButton(
                      icon: Icons.remove_rounded,
                      label: 'Azalt',
                      onTap: () => cart.decrement(item.product.id),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '${item.quantity}',
                        style: AppTextStyles.controlLabel,
                      ),
                    ),
                    _QuantityButton(
                      icon: Icons.add_rounded,
                      label: 'Artır',
                      onTap: () => cart.increment(item.product.id),
                    ),
                    const Spacer(),
                    _QuantityButton(
                      icon: Icons.delete_outline_rounded,
                      label: 'Kaldır',
                      onTap: () => cart.remove(item.product.id),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      semanticLabel: label,
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(
          icon,
          size: 18,
          color: label == 'Kaldır' ? AppColors.primary : AppColors.textPrimary,
        ),
      ),
    );
  }
}
