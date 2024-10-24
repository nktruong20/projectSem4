import 'package:flutter/material.dart';
import 'package:project_sem4/models/order.dart';
import 'package:project_sem4/services/order_service.dart';

class OrderController with ChangeNotifier {
  final OrderService _orderService = OrderService();
  List<Order> _orders = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  /// Lấy danh sách đơn hàng cho admin
  Future<void> fetchOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      _orders = await _orderService.getOrderAdmin();

      // Sắp xếp đơn hàng theo thời gian giảm dần
      _orders.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Giả sử bạn có trường createdAt

      _errorMessage = '';
    } catch (error) {
      _errorMessage = error.toString();
      _orders = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
