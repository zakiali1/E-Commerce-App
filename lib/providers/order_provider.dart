import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

class OrderProvider with ChangeNotifier {
  final List<OrderModel> _orders = [];

  List<OrderModel> get orders => List.unmodifiable(_orders);

  OrderProvider() {
    _loadOrdersFromStorage();
  }

  Future<OrderModel> placeOrder({
    required List<CartItem> cartItems,
    required double totalAmount,
    required String shippingAddress,
    required String paymentMethod,
  }) async {
    final order = OrderModel(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
      items: List.from(cartItems),
      totalAmount: totalAmount,
      date: DateTime.now(),
      status: OrderStatus.processing,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
    );

    _orders.insert(0, order);
    await _saveOrdersToStorage();
    notifyListeners();
    return order;
  }

  Future<void> _saveOrdersToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _orders.map((o) => o.toJson()).toList();
      await prefs.setString('user_orders_data', json.encode(jsonList));
    } catch (e) {
      debugPrint('Error saving orders: $e');
    }
  }

  Future<void> _loadOrdersFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final str = prefs.getString('user_orders_data');
      if (str != null && str.isNotEmpty) {
        final List<dynamic> jsonList = json.decode(str);
        _orders.clear();
        _orders.addAll(jsonList.map((j) => OrderModel.fromJson(j)));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading orders: $e');
    }
  }
}
