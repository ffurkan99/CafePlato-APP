import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
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
import '../../core/utils/price_formatter.dart';
import '../../widgets/cart_summary_bar.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = MockData.categories.first;
  
  List<Product> get _filteredProducts {
    if (_selectedCategory == 'Tümü') {
      return MockData.products;
    }
    return MockData.products.where((p) => p.category == _selectedCategory).toList();
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
      calculatedUnitPrice: product.price + (product.availableSizes?[1].priceDelta ?? 0) + (product.availableMilkOptions?[1].priceDelta ?? 0),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tekrar eklendi.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
          SliverToBoxAdapter(
            child: AppHeader(
              title: 'Günaydın, Furkan',
              subtitle: 'Bugün hangi kahveyi tercih edersin?',
              onNotificationTap: () => _showNotificationSnackBar(context),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 8),
          ),
          const SliverToBoxAdapter(
            child: BranchSelector(),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
          const SliverToBoxAdapter(
            child: LoyaltyCard(),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                scrollDirection: Axis.horizontal,
                itemCount: MockData.campaigns.length,
                itemBuilder: (context, index) {
                  return CampaignCard(campaign: MockData.campaigns[index]);
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SectionHeader(title: 'Tekrar Sipariş Ver'),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(MockData.lastOrder.placeholderIcon, style: const TextStyle(fontSize: 24)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(MockData.lastOrder.name, style: AppTextStyles.heading3.copyWith(fontSize: 16)),
                          Text('Orta boy • Laktozsuz süt', style: AppTextStyles.bodySmall),
                          const SizedBox(height: 4),
                          Text(PriceFormatter.format(MockData.lastOrder.price), style: AppTextStyles.price.copyWith(fontSize: 14)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _showReorderSnackBar(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: const Text('Tekrar Ekle'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
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
          const SliverToBoxAdapter(
            child: SectionHeader(title: 'Popüler Ürünler'),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.60,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ProductCard(product: _filteredProducts[index]);
                },
                childCount: _filteredProducts.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 80), // To make room for CartSummaryBar
          ),
        ],
      ),
      Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: const CartSummaryBar(),
      ),
    ],
  ),
),
    );
  }
}
