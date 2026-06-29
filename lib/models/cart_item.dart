import 'product.dart';
import 'product_size_option.dart';
import 'milk_option.dart';
import 'extra_option.dart';

class CartItem {
  final String uniqueCartId;
  final Product product;
  final ProductSizeOption? selectedSize;
  final MilkOption? selectedMilk;
  final List<ExtraOption> selectedExtras;
  int quantity;
  final double unitPrice;

  CartItem({
    required this.uniqueCartId,
    required this.product,
    this.selectedSize,
    this.selectedMilk,
    this.selectedExtras = const [],
    required this.quantity,
    required this.unitPrice,
  });

  double get totalPrice => unitPrice * quantity;
}
