import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class WishlistProvider with ChangeNotifier {
  final List<Product> _wishlist = [];

  List<Product> get items => List.unmodifiable(_wishlist);

  WishlistProvider() {
    _loadWishlistFromStorage();
  }

  bool isFavorite(String productId) {
    return _wishlist.any((item) => item.id == productId);
  }

  void toggleFavorite(Product product) {
    final index = _wishlist.indexWhere((item) => item.id == product.id);
    if (index != -1) {
      _wishlist.removeAt(index);
    } else {
      _wishlist.add(product);
    }
    _saveWishlistToStorage();
    notifyListeners();
  }

  Future<void> _saveWishlistToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _wishlist.map((p) => p.toJson()).toList();
      await prefs.setString('user_wishlist_data', json.encode(jsonList));
    } catch (e) {
      debugPrint('Error saving wishlist: $e');
    }
  }

  Future<void> _loadWishlistFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final str = prefs.getString('user_wishlist_data');
      if (str != null && str.isNotEmpty) {
        final List<dynamic> jsonList = json.decode(str);
        _wishlist.clear();
        _wishlist.addAll(jsonList.map((j) => Product.fromJson(j)));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading wishlist: $e');
    }
  }
}
