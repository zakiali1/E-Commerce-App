import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  static const String _baseUrl = 'https://fakestoreapi.com/products';

  static final List<Product> _fallbackProducts = [
    Product(
      id: '1',
      title: 'Fjallraven - Foldsack No. 1 Backpack',
      price: 109.95,
      description:
          'Your everyday pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday pack.',
      category: "men's clothing",
      image: 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg',
      rating: 3.9,
      ratingCount: 120,
    ),
    Product(
      id: '2',
      title: 'Mens Casual Premium Slim Fit T-Shirts',
      price: 22.3,
      description:
          'Slim-fit style, contrast raglan long sleeve, three-button henley placket, light weight & soft fabric for breathable and comfortable wearing.',
      category: "men's clothing",
      image:
          'https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg',
      rating: 4.1,
      ratingCount: 259,
    ),
    Product(
      id: '3',
      title: 'Mens Cotton Jacket',
      price: 55.99,
      description:
          'Great outerwear jackets for Spring/Autumn/Winter, suitable for many occasions such as working, hiking, camping, mountain/rock climbing, cycling.',
      category: "men's clothing",
      image: 'https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_.jpg',
      rating: 4.7,
      ratingCount: 500,
    ),
    Product(
      id: '4',
      title: 'John Hardy Women\'s Legends Naga Gold & Silver Dragon Bracelet',
      price: 695.0,
      description:
          'From our Legends Collection, the Naga was inspired by the mythical water dragon that protects the ocean\'s pearl. Wear facing inward to be bestowed with love and abundance.',
      category: 'jewelery',
      image: 'https://fakestoreapi.com/img/71pWzhdJNwL._AC_UL640_QL65_ML3_.jpg',
      rating: 4.6,
      ratingCount: 400,
    ),
    Product(
      id: '5',
      title: 'Solid Gold Petite Micropave',
      price: 168.0,
      description:
          'Satisfaction Guaranteed. Return or exchange any order within 30 days. Designed and sold by Hafeez Center in the United States.',
      category: 'jewelery',
      image: 'https://fakestoreapi.com/img/61sbMiAs0GL._AC_UL640_QL65_ML3_.jpg',
      rating: 3.9,
      ratingCount: 70,
    ),
    Product(
      id: '6',
      title: 'WD 2TB Elements Portable External Hard Drive - USB 3.0',
      price: 64.0,
      description:
          'USB 3.0 and USB 2.0 Compatibility Fast data transfers Improve PC Performance High Capacity; Compatibility Formatted NTFS for Windows 10, Windows 8.1, Windows 7.',
      category: 'electronics',
      image: 'https://fakestoreapi.com/img/61IBBVJvSDL._AC_SY879_.jpg',
      rating: 4.8,
      ratingCount: 319,
    ),
  ];

  static Future<List<Product>> fetchProducts() async {
    try {
      final response = await http
          .get(Uri.parse(_baseUrl))
          .timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        final List<dynamic> list = json.decode(response.body);
        return list.map((item) => Product.fromJson(item)).toList();
      }
    } catch (e) {
      // Fallback on timeout or connectivity error
    }
    return _fallbackProducts;
  }

  static Future<List<Product>> fetchProductsByCategory(String category) async {
    final allProducts = await fetchProducts();
    if (category.toLowerCase() == 'all') return allProducts;
    return allProducts
        .where(
          (p) => p.category.toLowerCase().contains(category.toLowerCase()),
        )
        .toList();
  }

  static Future<Product?> fetchProductById(String id) async {
    final allProducts = await fetchProducts();
    return allProducts.firstWhere(
      (p) => p.id == id,
      orElse: () => _fallbackProducts.first,
    );
  }
}
