import 'store_product.dart';

class StoreCartItem {
  StoreCartItem({required this.product, this.quantity = 1});

  final StoreProduct product;
  int quantity;

  double get totalPrice => product.price * quantity;
}
