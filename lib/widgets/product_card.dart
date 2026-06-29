import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/navigation/app_page_route.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/price_formatter.dart';
import '../../core/utils/product_icon_helper.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../screens/product_detail/product_detail_screen.dart';
import 'app_feedback.dart';
import 'favorite_button.dart';
import 'pressable_scale.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Timer? _addedFeedbackTimer;
  bool _justAdded = false;

  Product get product => widget.product;

  @override
  void dispose() {
    _addedFeedbackTimer?.cancel();
    super.dispose();
  }

  void _onAddPressed(BuildContext context) {
    if (product.availableSizes != null ||
        product.availableMilkOptions != null ||
        product.availableExtras != null) {
      AppNavigator.push(context, ProductDetailScreen(product: product));
    } else {
      context.read<CartProvider>().addItem(
        product: product,
        calculatedUnitPrice: product.price,
      );
      HapticFeedback.lightImpact();
      _addedFeedbackTimer?.cancel();
      setState(() => _justAdded = true);
      _addedFeedbackTimer = Timer(const Duration(milliseconds: 650), () {
        if (mounted) setState(() => _justAdded = false);
      });
      AppFeedback.show(
        context,
        '${product.name} sepete eklendi.',
        type: AppFeedbackType.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<FavoritesProvider, bool>(
      (provider) => provider.isFavorite(product),
    );

    final iconBg = ProductIconHelper.backgroundForCategory(product.category);

    return PressableScale(
      pressedScale: 0.99,
      borderRadius: BorderRadius.circular(16),
      hoverColor: AppColors.primary,
      allowChildInteractions: true,
      onTap: () =>
          AppNavigator.push(context, ProductDetailScreen(product: product)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          // Nötr ince border — gold yok
          border: Border.all(color: AppColors.border, width: 0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Görsel alan: toplam kartın ~40%'ı (flex 2 / 5)
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      ProductIconHelper.iconForCategory(product.category),
                      size: 40,
                      color: ProductIconHelper.iconColorForCategory(
                        product.category,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: FavoriteButton(
                      isFavorite: isFavorite,
                      backgroundColor: AppColors.cardBackground.withAlpha(220),
                      onTap: () {
                        context.read<FavoritesProvider>().toggleFavorite(
                          product,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // İçerik alanı: ~60%
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: AppTextStyles.productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.description,
                      style: AppTextStyles.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            PriceFormatter.format(product.price),
                            style: AppTextStyles.price.copyWith(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        PressableScale(
                          semanticLabel: '${product.name} sepete ekle',
                          onTap: () => _onAddPressed(context),
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            width: 28,
                            height: 28,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: AnimatedSwitcher(
                              duration: AppMotion.duration(
                                context,
                                AppMotion.fast,
                              ),
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  ),
                                );
                              },
                              child: Icon(
                                _justAdded
                                    ? Icons.check_rounded
                                    : Icons.add_rounded,
                                key: ValueKey(_justAdded),
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
