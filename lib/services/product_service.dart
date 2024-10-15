import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductService {
  final String baseUrl = 'http://10.0.2.2:3000/products';

  // Lấy danh sách sản phẩm
  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Lấy sản phẩm theo ID
  Future<Product> getProduct(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }

  // Thêm sản phẩm mới
  Future<void> addProduct(Product product, String token) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-access-token': token,
      },
      body: json.encode(product.toJson()),
    );

    if (response.statusCode != 201) {
      print('Response body: ${response.body}');
      throw Exception('Failed to add product');
    } else {
      print('Product added successfully');
    }
  }

  // Cập nhật sản phẩm theo ID
  Future<void> updateProduct(int id, Product updatedProduct, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'x-access-token': token,
      },
      body: jsonEncode(updatedProduct.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
    }
  }

  // Xóa sản phẩm theo ID
  Future<void> deleteProduct(int id, String token) async {
    try {
      // Chỉnh sửa endpoint cho phù hợp với cấu trúc
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'), // Đảm bảo không có lặp lại "products"
        headers: {
          'x-access-token': token,
        },
      );

      // Kiểm tra mã phản hồi
      if (response.statusCode == 200) {
        print('Product deleted successfully');
      } else {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to delete product: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while deleting product: $e');
      throw Exception('Error occurred while deleting product: $e');
    }
  }


}
