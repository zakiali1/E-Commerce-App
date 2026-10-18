import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  String _appliedPromo = '';
  double _discountPercent = 0.0;

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalItemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get discount => subtotal * _discountPercent;

  double get tax => (subtotal - discount) * 0.075; // 7.5% Tax

  double get shippingFee => subtotal > 0 ? (subtotal > 150 ? 0.0 : 15.0) : 0.0;

  double get grandTotal => (subtotal - discount) + tax + shippingFee;

  String get appliedPromo => _appliedPromo;

  CartProvider() {
    _loadCartFromStorage();
  }

  void addToCart(Product product, {String size = 'M', String color = 'Default', int quantity = 1}) {
    final existingIndex = _items.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedSize == size &&
          item.selectedColor == color,
    );

    if (existingIndex != -1) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(
        CartItem(
          id: '${product.id}_${size}_$color',
          product: product,
          selectedSize: size,
          selectedColor: color,
          quantity: quantity,
        ),
      );
    }
    _saveCartToStorage();
    notifyListeners();
  }

  void updateQuantity(String cartItemId, int newQuantity) {
    final index = _items.indexWhere((item) => item.id == cartItemId);
    if (index != -1) {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQuantity;
      }
      _saveCartToStorage();
      notifyListeners();
    }
  }

  void removeFromCart(String cartItemId) {
    _items.removeWhere((item) => item.id == cartItemId);
    _saveCartToStorage();
    notifyListeners();
  }

  bool applyPromoCode(String code) {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode == 'SAVE10') {
      _appliedPromo = cleanCode;
      _discountPercent = 0.10;
      notifyListeners();
      return true;
    } else if (cleanCode == 'SHOPEASY20') {
      _appliedPromo = cleanCode;
      _discountPercent = 0.20;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removePromoCode() {
    _appliedPromo = '';
    _discountPercent = 0.0;
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _appliedPromo = '';
    _discountPercent = 0.0;
    _saveCartToStorage();
    notifyListeners();
  }

  Future<void> _saveCartToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = json.encode(_items.map((i) => i.toJson()).toList());
      await prefs.setString('user_cart_data', cartJson);
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }

  Future<void> _loadCartFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartString = prefs.getString('user_cart_data');
      if (cartString != null && cartString.isNotEmpty) {
        final List<dynamic> jsonList = json.decode(cartString);
        _items.clear();
        _items.addAll(jsonList.map((j) => CartItem.fromJson(j)));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading cart: $e');
    }
  }
}
