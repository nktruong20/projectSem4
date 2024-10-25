import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';

class CategoryService {
  final String baseUrl = 'http://10.0.2.2:3000/categories'; // Địa chỉ API cho danh mục

  // Lấy danh sách category
  Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((category) => Category.fromJson(category)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Lấy category theo ID
  Future<Category> getCategory(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return Category.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load category');
    }
  }

  // Thêm category mới
  Future<void> addCategory(Category category, String token) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-access-token': token,
      },
      body: json.encode(category.toJson()),
    );

    if (response.statusCode != 201) {
      print('Response body: ${response.body}');
      throw Exception('Failed to add category');
    } else {
      print('Category added successfully');
    }
  }

  // Cập nhật category theo ID
  Future<void> updateCategory(int id, Category updatedCategory, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'x-access-token': token,
      },
      body: jsonEncode(updatedCategory.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update category');
    }
  }

  // Xóa category theo ID
  Future<void> deleteCategory(int id, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'x-access-token': token,
        },
      );

      if (response.statusCode == 200) {
        print('Category deleted successfully');
      } else {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to delete category: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while deleting category: $e');
      throw Exception('Error occurred while deleting category: $e');
    }
  }

}
