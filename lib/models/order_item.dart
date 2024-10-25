class OrderItem {
  final int id;
  final String productName;
  final String productImage;
  final int productId;
  final double price;
  final int quantity;

  OrderItem({
    required this.id,
    required this.productName,
    required this.productImage,
    required this.productId,
    required this.price,
    required this.quantity
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'], // Nếu 'id' là null, gán giá trị mặc định là 0
      price: (json['price'] is int) ? json['price'].toDouble() : json['price'],
      productId: json['productId'],
      productImage: json['productImage'],
      productName: json['productName'],
        quantity: json['quantity']
    );
  }
}
