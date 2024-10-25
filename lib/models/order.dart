class Order {
  final int id;
  final int userId;
  final double totalPrice;
  final String status;
  final DateTime createdAt; // Đảm bảo bạn có trường này
  final String address;
  final String phone;
  final String username;

  Order({
    required this.id,
    required this.userId,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.address,
    required this.phone,
    required this.username,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? 0, // Nếu 'id' là null, gán giá trị mặc định là 0
      userId: json['user_id'] ?? 0, // Tương tự cho 'user_id'
      totalPrice: (json['total_price'] ?? 0)
          .toDouble(), // Đảm bảo total_price là double
      status: json['status'] ??
          'Unknown', // Nếu 'status' là null, gán giá trị mặc định
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(), // Nếu 'created_at' là null, dùng thời gian hiện tại
      address: json['address'] ?? 'Unknown', // Giá trị mặc định cho address
      phone: json['phone'] ?? 'Unknown', // Giá trị mặc định cho phone
      username: json['username'] ?? 'Unknown', // Giá trị mặc định cho username
    );
  }
}


//order
