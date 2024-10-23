// providers/auth_provider.dart
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _userRole; // Biến để lưu vai trò của người dùng
  bool _isLoggedIn = false; // Biến để theo dõi trạng thái đăng nhập

  String? get userRole => _userRole;
  bool get isLoggedIn => _isLoggedIn;

  // Hàm đăng nhập
  Future<void> login(String role) async {
    _userRole = role;
    _isLoggedIn = true;
    notifyListeners(); // Thông báo cho các widget lắng nghe rằng trạng thái đã thay đổi
  }

  // Hàm đăng xuất
  Future<void> logout() async {
    _userRole = null;
    _isLoggedIn = false;
    notifyListeners(); // Thông báo cho các widget lắng nghe rằng trạng thái đã thay đổi
  }
}
