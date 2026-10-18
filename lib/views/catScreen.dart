import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'homeScreen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<Map<String, dynamic>> categoriesList = [
    {
      'id': '1',
      'name': 'Electronics',
      'icon': Icons.devices,
      'color': Colors.blue,
      'itemCount': '45+ Products',
    },
    {
      'id': '2',
      'name': "Men's Clothing",
      'icon': Icons.checkroom,
      'color': Colors.orange,
      'itemCount': '120+ Products',
    },
    {
      'id': '3',
      'name': "Women's Clothing",
      'icon': Icons.woman,
      'color': Colors.pink,
      'itemCount': '210+ Products',
    },
    {
      'id': '4',
      'name': 'Jewelery',
      'icon': Icons.diamond,
      'color': Colors.amber,
      'itemCount': '35+ Products',
    },
    {
      'id': '5',
      'name': 'Sports & Outdoors',
      'icon': Icons.sports_basketball,
      'color': Colors.green,
      'itemCount': '80+ Products',
    },
    {
      'id': '6',
      'name': 'Beauty & Personal Care',
      'icon': Icons.brush,
      'color': Colors.purple,
      'itemCount': '95+ Products',
    },
  ];

  List<Map<String, dynamic>> filteredList = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredList = categoriesList;
  }

  void _filterCategories(String query) {
    setState(() {
      searchQuery = query;
      filteredList = categoriesList
          .where(
            (c) => c['name'].toString().toLowerCase().contains(
              query.toLowerCase(),
            ),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _filterCategories,
              decoration: InputDecoration(
                hintText: 'Search categories...',
                prefixIcon: const Icon(Icons.search, color: Colors.green),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredList.isEmpty
                ? const Center(child: Text('No categories found'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final cat = filteredList[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundColor: (cat['color'] as Color)
                                .withValues(),
                            child: Icon(
                              cat['icon'] as IconData,
                              color: cat['color'] as Color,
                            ),
                          ),
                          title: Text(
                            cat['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            cat['itemCount'],
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => const HomeScreen(),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }
}
