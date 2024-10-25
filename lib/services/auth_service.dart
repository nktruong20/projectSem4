import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:3000'; // Thay đổi nếu cần
  final FlutterSecureStorage storage = FlutterSecureStorage(); // Khai báo storage

  Future<User?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Login data: $data'); // Thêm dòng này để kiểm tra phản hồi

      // Lưu thông tin vào secure storage
      await storage.write(key: 'username', value: data['username']); // Lưu tên người dùng vào secure storage
      await storage.write(key: 'role', value: data['role']); // Lưu vai trò vào secure storage
      await storage.write(key: 'token', value: data['token']); // Lưu token vào secure storage
      await storage.write(key: 'user_id', value: data['user_id'].toString()); // Lưu user_id vào secure storage

      // In ra thông tin cần thiết
      print('Username: ${data['username']}'); // In tên người dùng
      print('Token: ${data['token']}'); // In token
      print('User ID: ${data['user_id']}'); // In user_id

      return User.fromJson(data); // Tạo đối tượng User từ phản hồi
    } else {
      print('Login failed: ${response.body}'); // In ra thông điệp lỗi
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }

  Future<bool> isLoggedIn() async {
    String? token = await getToken(); // Kiểm tra token
    return token != null; // Trả về true nếu token không null
  }

  Future<void> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to register');
    }
  }

  Future<void> logout() async {
    await storage.deleteAll(); // Xóa tất cả key-value trong secure storage
  }


  Future<String?> getUsername() async {
    return await storage.read(key: 'username'); // Lấy tên người dùng từ secure storage
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<String?> getRole() async {
    return await storage.read(key: 'role'); // Lấy vai trò từ secure storage
  }
  Future<String?> getUserId() async {
    return await storage.read(key: 'user_id'); // Lấy user_id từ secure storage
  }

}
