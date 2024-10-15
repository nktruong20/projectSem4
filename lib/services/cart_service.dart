import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart.dart';

class CartService {
  final String baseUrl = 'http://10.0.0.2:3000'; // Thay đổi địa chỉ nếu cần

  Future<List<CartItem>> getCart(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/cart'),
      headers: {'x-access-token': token},
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => CartItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load cart');
    }
  }

  Future<void> addToCart(String token, int productId, int quantity) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cart'),
      headers: {'x-access-token': token, 'Content-Type': 'application/json'},
      body: json.encode({'product_id': productId, 'quantity': quantity}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add to cart');
    }
  }

  Future<void> deleteCartItem(String token, int itemId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/cart/$itemId'),
      headers: {'x-access-token': token},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete cart item');
    }
  }
}
