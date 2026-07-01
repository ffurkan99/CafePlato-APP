import 'branch.dart';
import 'cart_item.dart';
import 'extra_option.dart';
import 'milk_option.dart';
import 'product.dart';
import 'product_size_option.dart';

enum OrderStatus { received, preparing, ready, completed }

extension OrderStatusLabel on OrderStatus {
  String get label => switch (this) {
    OrderStatus.received => 'Alındı',
    OrderStatus.preparing => 'Hazırlanıyor',
    OrderStatus.ready => 'Hazır',
    OrderStatus.completed => 'Teslim edildi',
  };

  String get title => switch (this) {
    OrderStatus.received => 'Siparişiniz alındı',
    OrderStatus.preparing => 'Siparişiniz hazırlanıyor',
    OrderStatus.ready => 'Siparişiniz hazır',
    OrderStatus.completed => 'Teslim edildi',
  };
}

class Order {
  const Order({
    required this.orderNumber,
    required this.items,
    required this.selectedBranch,
    required this.orderDate,
    required this.estimatedPreparationTime,
    required this.subtotal,
    required this.total,
    this.status = OrderStatus.received,
  });

  final String orderNumber;
  final List<CartItem> items;
  final Branch selectedBranch;
  final DateTime orderDate;
  final String estimatedPreparationTime;
  final double subtotal;
  final double total;
  final OrderStatus status;

  String get productSummary {
    if (items.isEmpty) return 'Sipariş';

    final names = items.map((item) => item.product.name).toList();
    if (names.length == 1) return names.first;
    if (names.length == 2) return names.join(', ');
    return '${names[0]}, ${names[1]} +${names.length - 2}';
  }

  Order copyWith({OrderStatus? status}) {
    return Order(
      orderNumber: orderNumber,
      items: items,
      selectedBranch: selectedBranch,
      orderDate: orderDate,
      estimatedPreparationTime: estimatedPreparationTime,
      subtotal: subtotal,
      total: total,
      status: status ?? this.status,
    );
  }

  Map<String, Object?> toJson() => {
    'orderNumber': orderNumber,
    'items': items.map(_cartItemToJson).toList(),
    'selectedBranch': {'id': selectedBranch.id, 'name': selectedBranch.name},
    'orderDate': orderDate.toIso8601String(),
    'estimatedPreparationTime': estimatedPreparationTime,
    'subtotal': subtotal,
    'total': total,
    'status': status.name,
  };

  factory Order.fromJson(Map<String, Object?> json) {
    final branchJson = _asMap(json['selectedBranch']);
    final rawItems = json['items'];
    if (rawItems is! List) throw const FormatException('Invalid order items');

    return Order(
      orderNumber: _requiredString(json['orderNumber']),
      items: rawItems.map((item) => _cartItemFromJson(_asMap(item))).toList(),
      selectedBranch: Branch(
        id: _requiredString(branchJson['id']),
        name: _requiredString(branchJson['name']),
      ),
      orderDate: DateTime.parse(_requiredString(json['orderDate'])),
      estimatedPreparationTime:
          json['estimatedPreparationTime'] as String? ?? '10-15 dakika',
      subtotal: _asDouble(json['subtotal']),
      total: _asDouble(json['total']),
      status: OrderStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => OrderStatus.received,
      ),
    );
  }

  static Map<String, Object?> _cartItemToJson(CartItem item) => {
    'uniqueCartId': item.uniqueCartId,
    'product': {
      'id': item.product.id,
      'name': item.product.name,
      'description': item.product.description,
      'category': item.product.category,
      'price': item.product.price,
      'isPopular': item.product.isPopular,
      'placeholderIcon': item.product.placeholderIcon,
    },
    'selectedSize': item.selectedSize == null
        ? null
        : {
            'name': item.selectedSize!.name,
            'priceDelta': item.selectedSize!.priceDelta,
          },
    'selectedMilk': item.selectedMilk == null
        ? null
        : {
            'name': item.selectedMilk!.name,
            'priceDelta': item.selectedMilk!.priceDelta,
          },
    'selectedExtras': item.selectedExtras
        .map(
          (extra) => {
            'id': extra.id,
            'name': extra.name,
            'priceDelta': extra.priceDelta,
          },
        )
        .toList(),
    'quantity': item.quantity,
    'unitPrice': item.unitPrice,
  };

  static CartItem _cartItemFromJson(Map<String, Object?> json) {
    final productJson = _asMap(json['product']);
    final sizeJson = json['selectedSize'] == null
        ? null
        : _asMap(json['selectedSize']);
    final milkJson = json['selectedMilk'] == null
        ? null
        : _asMap(json['selectedMilk']);
    final rawExtras = json['selectedExtras'];

    return CartItem(
      uniqueCartId: _requiredString(json['uniqueCartId']),
      product: Product(
        id: _requiredString(productJson['id']),
        name: _requiredString(productJson['name']),
        description: productJson['description'] as String? ?? '',
        category: productJson['category'] as String? ?? '',
        price: _asDouble(productJson['price']),
        isPopular: productJson['isPopular'] as bool? ?? false,
        placeholderIcon: productJson['placeholderIcon'] as String? ?? '',
      ),
      selectedSize: sizeJson == null
          ? null
          : ProductSizeOption(
              name: _requiredString(sizeJson['name']),
              priceDelta: _asDouble(sizeJson['priceDelta']),
            ),
      selectedMilk: milkJson == null
          ? null
          : MilkOption(
              name: _requiredString(milkJson['name']),
              priceDelta: _asDouble(milkJson['priceDelta']),
            ),
      selectedExtras: rawExtras is List
          ? rawExtras.map((rawExtra) {
              final extra = _asMap(rawExtra);
              return ExtraOption(
                id: _requiredString(extra['id']),
                name: _requiredString(extra['name']),
                priceDelta: _asDouble(extra['priceDelta']),
              );
            }).toList()
          : const [],
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      unitPrice: _asDouble(json['unitPrice']),
    );
  }

  static Map<String, Object?> _asMap(Object? value) {
    if (value is! Map) throw const FormatException('Invalid order data');
    return value.map((key, value) => MapEntry(key.toString(), value));
  }

  static String _requiredString(Object? value) {
    if (value is! String || value.isEmpty) {
      throw const FormatException('Missing order value');
    }
    return value;
  }

  static double _asDouble(Object? value) {
    if (value is num) return value.toDouble();
    throw const FormatException('Invalid order number');
  }
}
