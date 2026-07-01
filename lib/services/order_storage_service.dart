import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/order.dart';

class OrderStorageService {
  static const _ordersKey = 'cafeplato_cafe_order_history';
  static const _activeOrderKey = 'cafeplato_active_cafe_order_id';

  Future<List<Order>> readOrders() async {
    final preferences = await SharedPreferences.getInstance();
    final encodedOrders = preferences.getString(_ordersKey);
    if (encodedOrders == null || encodedOrders.isEmpty) return [];

    try {
      final decoded = jsonDecode(encodedOrders);
      if (decoded is! List) return [];

      final orders = <Order>[];
      for (final rawOrder in decoded) {
        try {
          if (rawOrder is! Map) continue;
          final json = rawOrder.map(
            (key, value) => MapEntry(key.toString(), value),
          );
          orders.add(Order.fromJson(json));
        } on Object {
          // Skip only the damaged entry and preserve the remaining history.
        }
      }
      return orders;
    } on Object {
      return [];
    }
  }

  Future<String?> readActiveOrderId() async {
    final preferences = await SharedPreferences.getInstance();
    final activeOrderId = preferences.getString(_activeOrderKey);
    return activeOrderId == null || activeOrderId.isEmpty
        ? null
        : activeOrderId;
  }

  Future<void> saveState(
    List<Order> orders, {
    required String? activeOrderId,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _ordersKey,
      jsonEncode(orders.map((order) => order.toJson()).toList()),
    );
    if (activeOrderId == null) {
      await preferences.remove(_activeOrderKey);
    } else {
      await preferences.setString(_activeOrderKey, activeOrderId);
    }
  }
}
