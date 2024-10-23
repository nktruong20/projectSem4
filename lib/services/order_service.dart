import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:project_sem4/models/cart.dart';
import '../models/order.dart';

class OrderService {
  final String baseUrl = 'http://10.0.2.2:3000'; // Thay đổi địa chỉ nếu cần

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

  Future<void> PostOrder(String token, List<CartItem> cartItems, double totalPrice, String address, String phone) async {
    String arrayStringCartId = "[";

    cartItems.forEach((item) {
      arrayStringCartId += '${item.id},';
    });

    if (arrayStringCartId.endsWith(',')) {
      arrayStringCartId = arrayStringCartId.substring(0, arrayStringCartId.length - 1);
    }

    arrayStringCartId += ']';

    // Print each field
    print('Token: $token');
    print('Cart Items: $arrayStringCartId');
    print('Total Price: $totalPrice');
    print('Address: $address');
    print('Phone: $phone');
    print('Status: pending');

    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: {
        'x-access-token': token,
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'cart_items': arrayStringCartId,
        'total_price': totalPrice,
        'address': address,
        'phone': phone,
        'status': 'pending',
      }),
    );

    print('Response status code: ${response.statusCode}');

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to place order');
    }
  }

}