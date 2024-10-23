// controllers/user_controller.dart

import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class UserController with ChangeNotifier {
  final AuthService authService = AuthService();
  User? _user;

  User? get user => _user;

  Future<void> login(String email, String password, BuildContext context) async {
    _user = await authService.login(email, password);
    notifyListeners();

    // Lấy vai trò của người dùng
    String? role = await authService.getRole();

    // Kiểm tra vai trò và điều hướng
    if (role == 'admin') {
      Navigator.pushReplacementNamed(context, '/adminScreen'); // Chuyển đến trang AdminScreen
    } else {
      Navigator.pushReplacementNamed(context, '/home'); // Chuyển đến trang Home
    }
  }

  Future<void> register(String username, String email, String password) async {
    await authService.register(username, email, password);
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
