import 'package:flutter/material.dart';
import '../models/cart.dart'; // Import model CartItem

class CartController extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(CartItem item) {
    _items.add(item);
    notifyListeners(); // Cập nhật UI
  }

  void removeItem(int id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners(); // Cập nhật UI
  }

  double get totalPrice {
    return _items.fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  void clearCart() {
    _items.clear();
    notifyListeners(); // Cập nhật UI
  }
}
