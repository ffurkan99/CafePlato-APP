import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../models/product_size_option.dart';
import '../models/milk_option.dart';
import '../models/extra_option.dart';
import 'package:uuid/uuid.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  final Uuid _uuid = const Uuid();

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  double get subtotal {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  double get total => subtotal; // No extra fees for now

  void addItem({
    required Product product,
    ProductSizeOption? size,
    MilkOption? milk,
    List<ExtraOption> extras = const [],
    int quantity = 1,
    required double calculatedUnitPrice,
  }) {
    // Check if identical item exists
    final existingIndex = _items.indexWhere((item) {
      if (item.product.id != product.id) return false;
      if (item.selectedSize?.name != size?.name) return false;
      if (item.selectedMilk?.name != milk?.name) return false;

      // Check extras equality
      if (item.selectedExtras.length != extras.length) return false;
      final existingExtraIds = item.selectedExtras.map((e) => e.id).toSet();
      final newExtraIds = extras.map((e) => e.id).toSet();
      if (!existingExtraIds.containsAll(newExtraIds)) return false;

      return true;
    });

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(
        CartItem(
          uniqueCartId: _uuid.v4(),
          product: product,
          selectedSize: size,
          selectedMilk: milk,
          selectedExtras: extras,
          quantity: quantity,
          unitPrice: calculatedUnitPrice,
        ),
      );
    }
    notifyListeners();
  }

  void incrementQuantity(String uniqueCartId) {
    final index = _items.indexWhere(
      (item) => item.uniqueCartId == uniqueCartId,
    );
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(String uniqueCartId) {
    final index = _items.indexWhere(
      (item) => item.uniqueCartId == uniqueCartId,
    );
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeItem(String uniqueCartId) {
    _items.removeWhere((item) => item.uniqueCartId == uniqueCartId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
