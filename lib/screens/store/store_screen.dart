import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/navigation/app_page_route.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/price_formatter.dart';
import '../../data/store_products.dart';
import '../../models/store_product.dart';
import '../../providers/store_cart_provider.dart';
import '../../widgets/app_feedback.dart';
import '../../widgets/cafe_plato_arc.dart';
import '../../widgets/pressable_scale.dart';
import 'store_cart_screen.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  String _category = StoreProducts.categories.first;

  List<StoreProduct> get _filteredProducts => _category == 'Tümü'
      ? StoreProducts.items
      : StoreProducts.items
            .where((product) => product.category == _category)
            .toList();

  void _add(StoreProduct product) {
    context.read<StoreCartProvider>().addProduct(product);
    AppFeedback.show(
      context,
      '${product.name} mağaza sepetine eklendi.',
      type: AppFeedbackType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final popular = StoreProducts.items
        .where((product) => product.isPopular)
        .toList();
    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildHero()),
          SliverToBoxAdapter(child: _buildCategories()),
          if (_category == 'Tümü') ...[
            SliverToBoxAdapter(child: _SectionTitle(title: 'Çok Satanlar')),
            SliverToBoxAdapter(child: _buildPopularRail(popular)),
          ],
          SliverToBoxAdapter(
            child: _SectionTitle(
              title: _category == 'Tümü' ? 'Tüm Ürünler' : _category,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            sliver: SliverList.separated(
              itemCount: _filteredProducts.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _StoreProductCard(
                product: _filteredProducts[index],
                onAdd: () => _add(_filteredProducts[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 16, 18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CafePlato Mağaza', style: AppTextStyles.heading1),
                const SizedBox(height: 4),
                Text(
                  'Kahve ritüelini yanında taşı.',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
          Consumer<StoreCartProvider>(
            builder: (context, cart, child) {
              return PressableScale(
                semanticLabel: 'Mağaza sepeti, ${cart.totalItems} ürün',
                onTap: () =>
                    AppNavigator.push(context, const StoreCartScreen()),
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Icon(
                            Icons.shopping_bag_outlined,
                            size: 21,
                          ),
                        ),
                      ),
                      if (cart.totalItems > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            constraints: const BoxConstraints(
                              minWidth: 19,
                              minHeight: 19,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${cart.totalItems}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        children: [
          const Positioned.fill(
            child: CafePlatoArc(
              color: AppColors.primary,
              opacity: 0.05,
              alignment: Alignment.centerRight,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Günün eşlikçisi',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text('CafePlato Termos', style: AppTextStyles.heading3),
                    const SizedBox(height: 5),
                    Text(
                      'Sıcaklığı koru, ritüeli sürdür.',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              Container(
                width: 62,
                height: 78,
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(
                  Icons.coffee_rounded,
                  color: AppColors.primary,
                  size: 31,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 68,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        itemCount: StoreProducts.categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = StoreProducts.categories[index];
          final selected = category == _category;
          return PressableScale(
            semanticLabel: category,
            selected: selected,
            pressedScale: 0.98,
            borderRadius: BorderRadius.circular(999),
            onTap: () => setState(() => _category = category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.cardBackground,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Text(
                category,
                style: AppTextStyles.controlLabel.copyWith(
                  color: selected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopularRail(List<StoreProduct> products) {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        itemCount: products.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) => SizedBox(
          width: 280,
          child: _StoreProductCard(
            product: products[index],
            onAdd: () => _add(products[index]),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Text(title, style: AppTextStyles.heading3),
    );
  }
}

class _StoreProductCard extends StatelessWidget {
  const _StoreProductCard({required this.product, required this.onAdd});

  final StoreProduct product;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 66,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              product.placeholderIcon,
              color: AppColors.primary,
              size: 27,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: AppTextStyles.productName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (product.isPopular || product.isNew)
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: product.isPopular
                              ? AppColors.champagneLight
                              : AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          product.isPopular ? 'Çok Satan' : 'Yeni',
                          style: AppTextStyles.label.copyWith(fontSize: 9),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  product.description,
                  style: AppTextStyles.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        PriceFormatter.format(product.price),
                        style: AppTextStyles.price,
                      ),
                    ),
                    PressableScale(
                      semanticLabel: '${product.name} sepete ekle',
                      onTap: onAdd,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Ekle',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
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
