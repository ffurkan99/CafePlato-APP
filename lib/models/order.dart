import 'cart_item.dart';
import 'branch.dart';

class Order {
  final String orderNumber;
  final List<CartItem> items;
  final Branch selectedBranch;
  final DateTime orderDate;
  final String estimatedPreparationTime;
  final double subtotal;
  final double total;

  Order({
    required this.orderNumber,
    required this.items,
    required this.selectedBranch,
    required this.orderDate,
    required this.estimatedPreparationTime,
    required this.subtotal,
    required this.total,
  });
}
