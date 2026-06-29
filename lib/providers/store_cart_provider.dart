import 'package:flutter/foundation.dart';

import '../models/store_cart_item.dart';
import '../models/store_product.dart';

class StoreCartProvider extends ChangeNotifier {
  final List<StoreCartItem> _items = [];

  List<StoreCartItem> get items => List.unmodifiable(_items);
  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => _items.fold(0, (sum, item) => sum + item.totalPrice);
  double get total => subtotal;

  void addProduct(StoreProduct product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index == -1) {
      _items.add(StoreCartItem(product: product));
    } else {
      _items[index].quantity++;
    }
    notifyListeners();
  }

  void increment(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index == -1) return;
    _items[index].quantity++;
    notifyListeners();
  }

  void decrement(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index == -1) return;
    if (_items[index].quantity == 1) {
      _items.removeAt(index);
    } else {
      _items[index].quantity--;
    }
    notifyListeners();
  }

  void remove(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
