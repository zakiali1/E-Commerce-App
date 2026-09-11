/// Mock API for categories (for testing without a backend)
class MockCategoryApi {
  static Future<List<Map<String, dynamic>>> fetchCategories() async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    return [
      {"id": "1", "name": "Electronics"},
      {"id": "2", "name": "Fashion"},
      {"id": "3", "name": "Books"},
      {"id": "4", "name": "Sports"},
      {"id": "5", "name": "Beauty"},
      {"id": "6", "name": "Toys"},
    ];
  }

  static Future<Map<String, dynamic>> fetchCategoryById(String id) async {
    await Future.delayed(Duration(milliseconds: 300));
    final categories = await fetchCategories();
    return categories.firstWhere(
      (cat) => cat["id"] == id,
      orElse: () => {"id": id, "name": "Unknown"},
    );
  }
}
