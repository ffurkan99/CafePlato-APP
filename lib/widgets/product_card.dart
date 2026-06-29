import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/navigation/app_page_route.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/price_formatter.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../screens/product_detail/product_detail_screen.dart';
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
      // Go to detail screen
      AppNavigator.push(context, ProductDetailScreen(product: product));
    } else {
      // Add to cart directly
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product.name} sepete eklendi.'),
          duration: const Duration(milliseconds: 1400),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<FavoritesProvider, bool>(
      (provider) => provider.isFavorite(product),
    );

    return GestureDetector(
      onTap: () {
        AppNavigator.push(context, ProductDetailScreen(product: product));
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.champagne, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.cardBackground,
                          AppColors.champagneLight,
                        ],
                      ),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      product.placeholderIcon,
                      style: const TextStyle(fontSize: 48),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
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
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: AppTextStyles.productName,
                      maxLines: 1,
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
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                                size: 20,
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
