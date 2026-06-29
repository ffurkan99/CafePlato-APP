import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock_data.dart';
import '../../models/product.dart';
import '../../widgets/app_header.dart';
import '../../widgets/branch_selector.dart';
import '../../widgets/loyalty_card.dart';
import '../../widgets/campaign_card.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/product_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/pressable_scale.dart';
import '../../core/utils/product_icon_helper.dart';

import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String _selectedCategory = MockData.categories.first;
  late final AnimationController _introController;

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: AppMotion.intro,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (AppMotion.reduceMotion(context)) {
        _introController.value = 1;
      } else {
        _introController.forward();
      }
    });
  }

  @override
  void dispose() {
    _introController.dispose();
    super.dispose();
  }

  Widget _introItem(int index, Widget child) {
    final start = index * 0.09;
    final end = start + 0.55;

    return AnimatedBuilder(
      animation: _introController,
      child: child,
      builder: (context, child) {
        final progress = Interval(
          start,
          end,
          curve: AppMotion.entrance,
        ).transform(_introController.value);

        return Opacity(
          opacity: progress,
          child: Transform.translate(
            offset: Offset(0, 12 * (1 - progress)),
            child: child,
          ),
        );
      },
    );
  }

  List<Product> get _filteredProducts {
    if (_selectedCategory == 'Tümü') {
      return MockData.products;
    }
    return MockData.products
        .where((p) => p.category == _selectedCategory)
        .toList();
  }

  void _showNotificationSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Henüz yeni bildiriminiz bulunmuyor.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showReorderSnackBar(BuildContext context) {
    // Add default order directly
    final product = MockData.lastOrder;
    context.read<CartProvider>().addItem(
      product: product,
      size: product.availableSizes?[1], // Orta boy
      milk: product.availableMilkOptions?[1], // Laktozsuz süt
      extras: [],
      quantity: 1,
      calculatedUnitPrice:
          product.price +
          (product.availableSizes?[1].priceDelta ?? 0) +
          (product.availableMilkOptions?[1].priceDelta ?? 0),
    );
    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tekrar eklendi.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _introItem(
              0,
              AppHeader(
                title: 'Günaydın, Furkan',
                subtitle: 'Bugün hangi kahveyi tercih edersin?',
                onNotificationTap: () => _showNotificationSnackBar(context),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          SliverToBoxAdapter(child: _introItem(1, const BranchSelector())),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverToBoxAdapter(child: _introItem(2, const LoyaltyCard())),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: _introItem(
              3,
              SizedBox(
                height: 160,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final cardWidth = constraints.maxWidth * 0.8;
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      scrollDirection: Axis.horizontal,
                      itemCount: MockData.campaigns.length,
                      itemBuilder: (context, index) {
                        return CampaignCard(
                          campaign: MockData.campaigns[index],
                          width: cardWidth,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _introItem(
              4,
              const SectionHeader(title: 'Tekrar Sipariş Ver'),
            ),
          ),
          SliverToBoxAdapter(
            child: _introItem(
              4,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: AppColors.border, width: 0.8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: ProductIconHelper.backgroundForCategory(
                            MockData.lastOrder.category,
                          ),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          ProductIconHelper.iconForCategory(
                            MockData.lastOrder.category,
                          ),
                          size: 18,
                          color: ProductIconHelper.iconColorForCategory(
                            MockData.lastOrder.category,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              MockData.lastOrder.name,
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Orta boy',
                              style: AppTextStyles.bodySmall.copyWith(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PressableScale(
                        semanticLabel: 'Tekrar sepete ekle',
                        onTap: () => _showReorderSnackBar(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Text(
                            'Ekle',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverToBoxAdapter(
            child: _introItem(
              5,
              SizedBox(
                height: 40,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  scrollDirection: Axis.horizontal,
                  itemCount: MockData.categories.length,
                  itemBuilder: (context, index) {
                    final category = MockData.categories[index];
                    return CategoryChip(
                      label: category,
                      isSelected: _selectedCategory == category,
                      onTap: () {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _introItem(5, const SectionHeader(title: 'Popüler Ürünler')),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.72,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final product = _filteredProducts[index];
                return _introItem(
                  5,
                  AnimatedSwitcher(
                    duration: AppMotion.duration(context, AppMotion.fast),
                    child: ProductCard(
                      key: ValueKey(product.id),
                      product: product,
                    ),
                  ),
                );
              }, childCount: _filteredProducts.length),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
