class Order {
  final int id;
  final int userId;
  final double totalPrice;
  final String status;
  final DateTime createdAt;

  Order({required this.id, required this.userId, required this.totalPrice, required this.status, required this.createdAt});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      totalPrice: json['total_price'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
