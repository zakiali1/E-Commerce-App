import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../views/homeScreen.dart';
import '../views/catScreen.dart';
import '../views/cartScreen.dart';
import '../views/profileScreen.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget targetScreen;
    switch (index) {
      case 0:
        targetScreen = const HomeScreen();
        break;
      case 1:
        targetScreen = const CategoriesScreen();
        break;
      case 2:
        targetScreen = const Cartscreen();
        break;
      case 3:
        targetScreen = const ProfileScreen();
        break;
      default:
        targetScreen = const HomeScreen();
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, anim1, anim2) => targetScreen,
        transitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().totalItemCount;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: Colors.green[700],
      unselectedItemColor: Colors.grey[600],
      backgroundColor: Colors.white,
      elevation: 10,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      onTap: (index) => _onItemTapped(context, index),
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.category_outlined),
          activeIcon: Icon(Icons.category),
          label: 'Categories',
        ),
        BottomNavigationBarItem(
          icon: Badge(
            isLabelVisible: cartCount > 0,
            label: Text(
              '$cartCount',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            backgroundColor: Colors.redAccent,
            child: const Icon(Icons.shopping_cart_outlined),
          ),
          activeIcon: Badge(
            isLabelVisible: cartCount > 0,
            label: Text(
              '$cartCount',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            backgroundColor: Colors.redAccent,
            child: const Icon(Icons.shopping_cart),
          ),
          label: 'Cart',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
