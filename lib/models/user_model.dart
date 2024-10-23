// models/user_model.dart

class User {

  final String username;
  final String email;
  final String role;

  User({

    required this.username,
    required this.email,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(

      username: json['username'] ?? 'Unknown', // Cung cấp giá trị mặc định nếu là null
      email: json['email'] ?? 'unknown@example.com', // Cung cấp giá trị mặc định nếu là null
      role: json['role'] ?? 'user', // Cung cấp giá trị mặc định nếu là null
    );
  }
}
