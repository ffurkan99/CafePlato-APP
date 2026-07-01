import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/branch.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../services/order_storage_service.dart';

class OrderHistoryProvider extends ChangeNotifier {
  OrderHistoryProvider({
    OrderStorageService? storage,
    DateTime Function()? now,
    this._statusCheckInterval = const Duration(seconds: 1),
  }) : _storage = storage ?? OrderStorageService(),
       _now = now ?? DateTime.now;

  final OrderStorageService _storage;
  final DateTime Function() _now;
  final Duration _statusCheckInterval;
  final List<Order> _orders = [];

  bool _isLoading = false;
  String? _activeOrderId;
  Future<void>? _restoreFuture;
  Future<void> _persistenceQueue = Future.value();
  Timer? _statusTimer;

  List<Order> get orders {
    final sortedOrders = List<Order>.from(_orders)
      ..sort((a, b) => b.orderDate.compareTo(a.orderDate));
    return List.unmodifiable(sortedOrders);
  }

  bool get isLoading => _isLoading;
  String? get activeOrderId => _activeOrderId;
  bool get hasActiveOrder => activeOrder != null;
  OrderStatus? get activeOrderStatus => activeOrder?.status;

  Order? get activeOrder {
    if (_activeOrderId == null) return null;
    for (final order in _orders) {
      if (order.orderNumber == _activeOrderId &&
          order.status != OrderStatus.completed) {
        return order;
      }
    }
    return null;
  }

  Future<void> restore() {
    return _restoreFuture ??= _restore();
  }

  Future<void> _restore() async {
    _isLoading = true;
    notifyListeners();

    final restoredOrders = await _storage.readOrders();
    final restoredActiveOrderId = await _storage.readActiveOrderId();
    _orders
      ..clear()
      ..addAll(restoredOrders);
    _activeOrderId = restoredActiveOrderId;

    final restoredActiveOrder = activeOrder;
    if (restoredActiveOrder == null) {
      _activeOrderId = null;
    } else {
      _setOrderStatus(
        restoredActiveOrder.orderNumber,
        _statusFor(restoredActiveOrder),
      );
    }

    _isLoading = false;
    _manageStatusTimer();
    notifyListeners();
    await _persist();
  }

  Future<Order> addCafeOrder({
    required List<CartItem> items,
    required Branch selectedBranch,
    required double subtotal,
    required double total,
  }) async {
    if (_restoreFuture != null) await _restoreFuture;

    final itemIds = items.map((item) => item.uniqueCartId).toSet();
    for (final existing in _orders) {
      final existingItemIds = existing.items
          .map((item) => item.uniqueCartId)
          .toSet();
      if (itemIds.length == existingItemIds.length &&
          itemIds.containsAll(existingItemIds)) {
        if (existing.status != OrderStatus.completed) {
          _activeOrderId = existing.orderNumber;
          _manageStatusTimer();
          notifyListeners();
          await _persist();
        }
        return existing;
      }
    }

    final order = Order(
      orderNumber: _nextOrderNumber(),
      items: List<CartItem>.from(items),
      selectedBranch: selectedBranch,
      orderDate: _now(),
      estimatedPreparationTime: '10-15 dakika',
      subtotal: subtotal,
      total: total,
    );

    _orders.insert(0, order);
    _activeOrderId = order.orderNumber;
    _manageStatusTimer();
    notifyListeners();
    await _persist();
    return order;
  }

  Future<void> refreshActiveOrderStatus() async {
    final order = activeOrder;
    if (order == null) {
      _manageStatusTimer();
      return;
    }

    final changed = _setOrderStatus(order.orderNumber, _statusFor(order));
    _manageStatusTimer();
    if (!changed) return;

    notifyListeners();
    await _persist();
  }

  Future<void> completeActiveOrder() async {
    final order = activeOrder;
    if (order == null) return;

    _setOrderStatus(order.orderNumber, OrderStatus.completed);
    _activeOrderId = null;
    _manageStatusTimer();
    notifyListeners();
    await _persist();
  }

  Future<void> updateStatus(String orderNumber, OrderStatus status) async {
    if (!_setOrderStatus(orderNumber, status)) return;

    if (_activeOrderId == orderNumber && status == OrderStatus.completed) {
      _activeOrderId = null;
    }
    _manageStatusTimer();
    notifyListeners();
    await _persist();
  }

  OrderStatus _statusFor(Order order) {
    final elapsed = _now().difference(order.orderDate);
    if (elapsed < const Duration(seconds: 4)) return OrderStatus.received;
    if (elapsed < const Duration(seconds: 10)) return OrderStatus.preparing;
    return OrderStatus.ready;
  }

  bool _setOrderStatus(String orderNumber, OrderStatus status) {
    final index = _orders.indexWhere(
      (order) => order.orderNumber == orderNumber,
    );
    if (index < 0 || _orders[index].status == status) return false;
    _orders[index] = _orders[index].copyWith(status: status);
    return true;
  }

  void _manageStatusTimer() {
    final status = activeOrder?.status;
    if (status == null || status == OrderStatus.ready) {
      _statusTimer?.cancel();
      _statusTimer = null;
      return;
    }

    _statusTimer ??= Timer.periodic(
      _statusCheckInterval,
      (_) => unawaited(refreshActiveOrderStatus()),
    );
  }

  Future<void> _persist() {
    final ordersSnapshot = List<Order>.from(_orders);
    final activeOrderIdSnapshot = _activeOrderId;
    _persistenceQueue = _persistenceQueue.then(
      (_) => _storage.saveState(
        ordersSnapshot,
        activeOrderId: activeOrderIdSnapshot,
      ),
    );
    return _persistenceQueue;
  }

  String _nextOrderNumber() {
    var highestNumber = 1047;
    for (final order in _orders) {
      final numericPart = int.tryParse(
        order.orderNumber.replaceFirst('CP-', ''),
      );
      if (numericPart != null && numericPart > highestNumber) {
        highestNumber = numericPart;
      }
    }
    return 'CP-${highestNumber + 1}';
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }
}
