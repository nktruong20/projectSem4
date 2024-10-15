import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart';

class OrderService {
  final String baseUrl = 'http://10.0.0.2:3000'; // Thay đổi địa chỉ nếu cần

  Future<List<Order>> getOrders(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders'),
      headers: {'x-access-token': token},
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Order.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<void> placeOrder(String token, List<Map<String, dynamic>> cartItems, double totalPrice) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: {'x-access-token': token, 'Content-Type': 'application/json'},
      body: json.encode({'cart_items': cartItems, 'total_price': totalPrice}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to place order');
    }
  }
}
