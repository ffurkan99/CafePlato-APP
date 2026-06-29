import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/price_formatter.dart';
import '../../../core/utils/product_icon_helper.dart';
import '../../../models/product.dart';
import '../../../models/product_size_option.dart';
import '../../../models/milk_option.dart';
import '../../../models/extra_option.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/favorites_provider.dart';
import '../../../widgets/quantity_selector.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/favorite_button.dart';
import '../../../widgets/pressable_scale.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductSizeOption? _selectedSize;
  MilkOption? _selectedMilk;
  final List<ExtraOption> _selectedExtras = [];
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    if (widget.product.availableSizes?.isNotEmpty == true) {
      _selectedSize = widget.product.availableSizes!.first;
    }
    if (widget.product.availableMilkOptions?.isNotEmpty == true) {
      _selectedMilk = widget.product.availableMilkOptions!.first;
    }
  }

  double get _calculatedUnitPrice {
    double price = widget.product.price;
    if (_selectedSize != null) price += _selectedSize!.priceDelta;
    if (_selectedMilk != null) price += _selectedMilk!.priceDelta;
    for (var extra in _selectedExtras) {
      price += extra.priceDelta;
    }
    return price;
  }

  double get _totalPrice => _calculatedUnitPrice * _quantity;

  void _onAddToCart() {
    context.read<CartProvider>().addItem(
      product: widget.product,
      size: _selectedSize,
      milk: _selectedMilk,
      extras: _selectedExtras,
      quantity: _quantity,
      calculatedUnitPrice: _calculatedUnitPrice,
    );
    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} sepete eklendi.'),
        action: SnackBarAction(
          label: 'Sepete Git',
          onPressed: () {
            // Need to close detail screen and switch tab to Cart.
            // We can just close for now, user can use tab. Or we could pop to root and set tab.
            Navigator.pop(context);
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<FavoritesProvider, bool>(
      (provider) => provider.isFavorite(widget.product),
    );

    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FavoriteButton(
              isFavorite: isFavorite,
              iconSize: 24,
              padding: 12,
              onTap: () {
                context.read<FavoritesProvider>().toggleFavorite(
                  widget.product,
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 240,
                    decoration: BoxDecoration(
                      color: ProductIconHelper.backgroundForCategory(
                        widget.product.category,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(32),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      ProductIconHelper.iconForCategory(widget.product.category),
                      size: 80,
                      color: ProductIconHelper.iconColorForCategory(
                        widget.product.category,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.product.name,
                                    style: AppTextStyles.heading1,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.product.description,
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              PriceFormatter.format(widget.product.price),
                              style: AppTextStyles.heading2.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        if (widget.product.availableSizes?.isNotEmpty ==
                            true) ...[
                          const Text('Boyut', style: AppTextStyles.heading3),
                          const SizedBox(height: 12),
                          Row(
                            children: widget.product.availableSizes!.map((
                              size,
                            ) {
                              final isSelected = _selectedSize == size;
                              return Expanded(
                                child: PressableScale(
                                  semanticLabel: '${size.name} boy',
                                  selected: isSelected,
                                  onTap: () {
                                    if (isSelected) return;
                                    HapticFeedback.selectionClick();
                                    setState(() {
                                      _selectedSize = size;
                                    });
                                  },
                                  child: AnimatedScale(
                                    scale: isSelected ? 1 : 0.98,
                                    duration: AppMotion.duration(
                                      context,
                                      AppMotion.normal,
                                    ),
                                    curve: AppMotion.standard,
                                    child: AnimatedContainer(
                                      margin: const EdgeInsets.only(right: 8),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      duration: AppMotion.duration(
                                        context,
                                        AppMotion.normal,
                                      ),
                                      curve: AppMotion.standard,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.background,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.border,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          AnimatedDefaultTextStyle(
                                            duration: AppMotion.duration(
                                              context,
                                              AppMotion.normal,
                                            ),
                                            curve: AppMotion.standard,
                                            style: TextStyle(
                                              fontFamily:
                                                  AppTextStyles.fontFamily,
                                              fontSize: 14,
                                              color: isSelected
                                                  ? Colors.white
                                                  : AppColors.textPrimary,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w500,
                                            ),
                                            child: Text(size.name),
                                          ),
                                          if (size.priceDelta > 0) ...[
                                            const SizedBox(height: 4),
                                            AnimatedDefaultTextStyle(
                                              duration: AppMotion.duration(
                                                context,
                                                AppMotion.normal,
                                              ),
                                              curve: AppMotion.standard,
                                              style: TextStyle(
                                                fontFamily:
                                                    AppTextStyles.fontFamily,
                                                color: isSelected
                                                    ? Colors.white70
                                                    : AppColors.textSecondary,
                                                fontSize: 12,
                                              ),
                                              child: Text(
                                                '+${PriceFormatter.format(size.priceDelta)}',
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                        ],
                        if (widget.product.availableMilkOptions?.isNotEmpty ==
                            true) ...[
                          const Text(
                            'Süt Seçimi',
                            style: AppTextStyles.heading3,
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.product.availableMilkOptions!.map((
                              milk,
                            ) {
                              final isSelected = _selectedMilk == milk;
                              return PressableScale(
                                semanticLabel: '${milk.name} süt seçeneği',
                                selected: isSelected,
                                onTap: () {
                                  if (isSelected) return;
                                  HapticFeedback.selectionClick();
                                  setState(() {
                                    _selectedMilk = milk;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: AppMotion.duration(
                                    context,
                                    AppMotion.normal,
                                  ),
                                  curve: AppMotion.standard,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primaryLight
                                        : AppColors.background,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.border,
                                    ),
                                  ),
                                  child: AnimatedDefaultTextStyle(
                                    duration: AppMotion.duration(
                                      context,
                                      AppMotion.normal,
                                    ),
                                    curve: AppMotion.standard,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.textPrimary,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                    child: Text(milk.name),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                        ],
                        if (widget.product.availableExtras?.isNotEmpty ==
                            true) ...[
                          const Text(
                            'Ekstralar',
                            style: AppTextStyles.heading3,
                          ),
                          const SizedBox(height: 12),
                          ...widget.product.availableExtras!.map((extra) {
                            final isSelected = _selectedExtras.contains(extra);
                            return PressableScale(
                              pressedScale: 0.99,
                              semanticLabel: '${extra.name} ekstra seçeneği',
                              selected: isSelected,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() {
                                  if (isSelected) {
                                    _selectedExtras.remove(extra);
                                  } else {
                                    _selectedExtras.add(extra);
                                  }
                                });
                              },
                              child: SizedBox(
                                height: 52,
                                child: Row(
                                  children: [
                                    AnimatedContainer(
                                      width: 24,
                                      height: 24,
                                      duration: AppMotion.duration(
                                        context,
                                        AppMotion.normal,
                                      ),
                                      curve: AppMotion.standard,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.primary
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(7),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.border,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: AnimatedSwitcher(
                                        duration: AppMotion.duration(
                                          context,
                                          AppMotion.fast,
                                        ),
                                        child: isSelected
                                            ? const Icon(
                                                Icons.check_rounded,
                                                key: ValueKey(true),
                                                color: Colors.white,
                                                size: 17,
                                              )
                                            : const SizedBox(
                                                key: ValueKey(false),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            extra.name,
                                            style: AppTextStyles.bodyLarge,
                                          ),
                                          Text(
                                            '+${PriceFormatter.format(extra.priceDelta)}',
                                            style: AppTextStyles.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  QuantitySelector(
                    quantity: _quantity,
                    onChanged: (val) {
                      setState(() {
                        _quantity = val;
                      });
                    },
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PrimaryButton(
                      text:
                          'Sepete Ekle • ${PriceFormatter.format(_totalPrice)}',
                      onPressed: _onAddToCart,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
