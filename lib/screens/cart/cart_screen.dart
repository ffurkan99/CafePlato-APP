import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/price_formatter.dart';
import '../../providers/cart_provider.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/quantity_selector.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/empty_state.dart';
import '../order_success/order_success_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = false;

  void _completeOrder(BuildContext context, CartProvider cart) async {
    final selectedBranchName = context.read<AppStateProvider>().selectedBranch.name;
    final total = cart.total;

    setState(() {
      _isLoading = true;
    });

    // Simulate network request
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!context.mounted) return;
    
    // Navigate to success
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OrderSuccessScreen(
          branchName: selectedBranchName,
          total: total,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sepetim'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return EmptyState(
              message: 'Sepetiniz şu anda boş',
              icon: Icons.shopping_basket_outlined,
            );
          }

          final selectedBranch = context.watch<AppStateProvider>().selectedBranch;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.storefront_rounded, color: AppColors.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Mağazadan Teslim Al', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                                Text(selectedBranch.name, style: AppTextStyles.bodySmall),
                                const Text('Hazırlanma süresi: 10-15 dakika', style: TextStyle(fontSize: 12, color: AppColors.primary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ...cart.items.map((item) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Text(item.product.placeholderIcon, style: const TextStyle(fontSize: 32)),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.product.name,
                                          style: AppTextStyles.heading3.copyWith(fontSize: 16),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary, size: 20),
                                        onPressed: () {
                                          cart.removeItem(item.uniqueCartId);
                                        },
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  if (item.selectedSize != null)
                                    Text('Boyut: ${item.selectedSize!.name}', style: AppTextStyles.bodySmall),
                                  if (item.selectedMilk != null)
                                    Text('Süt: ${item.selectedMilk!.name}', style: AppTextStyles.bodySmall),
                                  if (item.selectedExtras.isNotEmpty)
                                    Text('Ekstra: ${item.selectedExtras.map((e) => e.name).join(', ')}', style: AppTextStyles.bodySmall),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        PriceFormatter.format(item.totalPrice),
                                        style: AppTextStyles.price,
                                      ),
                                      QuantitySelector(
                                        quantity: item.quantity,
                                        onChanged: (newVal) {
                                          if (newVal > item.quantity) {
                                            cart.incrementQuantity(item.uniqueCartId);
                                          } else {
                                            cart.decrementQuantity(item.uniqueCartId);
                                          }
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Ara Toplam', style: AppTextStyles.bodyMedium),
                          Text(PriceFormatter.format(cart.subtotal), style: AppTextStyles.bodyLarge),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Hizmet Bedeli', style: AppTextStyles.bodyMedium),
                          Text(PriceFormatter.format(0), style: AppTextStyles.bodyLarge),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('İndirim', style: AppTextStyles.bodyMedium),
                          Text(PriceFormatter.format(0), style: AppTextStyles.bodyLarge),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(height: 1, color: AppColors.border),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Genel Toplam', style: AppTextStyles.heading3),
                          Text(
                            PriceFormatter.format(cart.total),
                            style: AppTextStyles.heading2.copyWith(color: AppColors.primary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        text: 'Siparişi Tamamla',
                        isLoading: _isLoading,
                        onPressed: () => _completeOrder(context, cart),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
