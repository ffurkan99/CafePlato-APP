import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/price_formatter.dart';
import '../../../models/product.dart';
import '../../../models/product_size_option.dart';
import '../../../models/milk_option.dart';
import '../../../models/extra_option.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/favorites_provider.dart';
import '../../../widgets/quantity_selector.dart';
import '../../../widgets/primary_button.dart';

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
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isFavorite ? AppColors.primary : AppColors.textPrimary,
            ),
            onPressed: () {
              context.read<FavoritesProvider>().toggleFavorite(widget.product);
            },
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
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.product.placeholderIcon,
                      style: const TextStyle(fontSize: 100),
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
                                  Text(widget.product.name, style: AppTextStyles.heading1),
                                  const SizedBox(height: 8),
                                  Text(widget.product.description, style: AppTextStyles.bodyMedium),
                                ],
                              ),
                            ),
                            Text(
                              PriceFormatter.format(widget.product.price),
                              style: AppTextStyles.heading2.copyWith(color: AppColors.primary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        if (widget.product.availableSizes?.isNotEmpty == true) ...[
                          const Text('Boyut', style: AppTextStyles.heading3),
                          const SizedBox(height: 12),
                          Row(
                            children: widget.product.availableSizes!.map((size) {
                              final isSelected = _selectedSize == size;
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedSize = size;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.primary : AppColors.background,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected ? AppColors.primary : AppColors.border,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          size.name,
                                          style: TextStyle(
                                            color: isSelected ? Colors.white : AppColors.textPrimary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        if (size.priceDelta > 0) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            '+${PriceFormatter.format(size.priceDelta)}',
                                            style: TextStyle(
                                              color: isSelected ? Colors.white70 : AppColors.textSecondary,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ]
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                        ],
                        if (widget.product.availableMilkOptions?.isNotEmpty == true) ...[
                          const Text('Süt Seçimi', style: AppTextStyles.heading3),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.product.availableMilkOptions!.map((milk) {
                              final isSelected = _selectedMilk == milk;
                              return FilterChip(
                                label: Text(milk.name),
                                selected: isSelected,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      _selectedMilk = milk;
                                    });
                                  }
                                },
                                backgroundColor: AppColors.background,
                                selectedColor: AppColors.primaryLight,
                                checkmarkColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: isSelected ? AppColors.primary : AppColors.border,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                        ],
                        if (widget.product.availableExtras?.isNotEmpty == true) ...[
                          const Text('Ekstralar', style: AppTextStyles.heading3),
                          const SizedBox(height: 12),
                          ...widget.product.availableExtras!.map((extra) {
                            final isSelected = _selectedExtras.contains(extra);
                            return CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(extra.name, style: AppTextStyles.bodyLarge),
                              subtitle: Text('+${PriceFormatter.format(extra.priceDelta)}', style: AppTextStyles.bodySmall),
                              value: isSelected,
                              activeColor: AppColors.primary,
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (checked) {
                                setState(() {
                                  if (checked == true) {
                                    _selectedExtras.add(extra);
                                  } else {
                                    _selectedExtras.remove(extra);
                                  }
                                });
                              },
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
                )
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
                      text: 'Sepete Ekle • ${PriceFormatter.format(_totalPrice)}',
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
